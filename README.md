# Delta Product Shaping Platform

AI-powered self-service product shaping tool for Delta Air Lines.

## Architecture

```
Frontend (Next.js + Tailwind) → API Routes → Gemini AI + Supabase DB
                                          → Scoring Engine
                                          → Export Engine
                                          → Notifications (Teams)
```

## Quick Start

```bash
cd pm-shaping-tool
npm install
npm run dev
```

Open http://localhost:3000 (Canvas UI) or double-click `shaping-app.html` (static version)

## API Routes

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/shape` | POST | Full AI shaping coach (guided flow) |
| `/api/copilot` | POST | AI actions (challenge, rewrite, missing, reflect, chat) |
| `/api/score` | POST | Scoring engine with guardrails + org inference |
| `/api/ideas` | GET/POST/PUT/DELETE | Ideas CRUD with Supabase |
| `/api/dashboard` | GET | Portfolio analytics + aggregation |
| `/api/insights` | GET | AI-powered portfolio insights |
| `/api/versions` | GET/POST | Version history for ideas |
| `/api/export` | POST | Generate docs (executive, PRD, Jira, Slack) |

## Libraries

| File | Purpose |
|------|---------|
| `src/lib/supabase.ts` | Database client + types |
| `src/lib/auth.ts` | Azure AD auth utilities |
| `src/lib/versions.ts` | Version history logic |
| `src/lib/realtime.ts` | Real-time collaboration (Supabase channels) |
| `src/lib/export.ts` | Document generation (exec summary, PRD, Jira, Slack) |
| `src/lib/notifications.ts` | Teams webhooks + in-app alerts |

## Setup

### 1. Supabase
1. Create project at [supabase.com](https://supabase.com)
2. Run `supabase-schema.sql` in SQL Editor
3. Copy URL + anon key to `.env.local`

### 2. Azure AD (for SSO)
1. Register app in Azure Portal → App Registrations
2. Set redirect URI: `https://your-domain.vercel.app/api/auth/callback`
3. Copy Client ID + Tenant ID to `.env.local`

### 3. Teams Notifications (optional)
1. Create incoming webhook in Teams channel
2. Copy webhook URL to `.env.local`

### 4. Deploy
1. Push to GitHub
2. Connect to [Vercel](https://vercel.com)
3. Add all env vars in Vercel project settings
4. Deploy

## Features

### Shaping Canvas (page.tsx)
- 6 editable cards: Problem, User, Context, Constraints, Impact, Solution
- Non-linear — edit any card at any time
- Real-time scoring on every edit
- AI Copilot sidebar (challenge, rewrite, missing, reflect)

### Scoring Engine
- Formula: (Impact² × Confidence²) ÷ Effort² × Clarity × Org Modifier
- Hard guardrails: blocks if Impact ≤ 2 or Confidence ≤ 2
- Auto-inferred org priority (keyword-based)
- Tiers: HIGHEST / HIGH / MEDIUM / LOW / BLOCKED

### AI Copilot
- Gemini 2.0 Flash powered
- Challenge, Rewrite, What's Missing, Reflect
- Floating chat box (always available)
- System prompt matches Delta shaping coach prompt

### Dashboard
- Pipeline flow (Funnel → Shaping → Ready → In Progress)
- Priority + Quality distribution
- AI-generated portfolio insights
- Filterable idea table with Refine button

### Collaboration
- Real-time updates via Supabase channels
- Presence indicators (who's editing)
- Version history with diffs
- Team-based filtering

### Export
- Executive Summary (1-page)
- PRD Starter (full template)
- Jira Ticket (ready to paste)
- Slack/Teams message

### Notifications
- Teams webhook integration
- In-app notification center
- Alerts when ideas are scored, ready, or need review

## File Structure

```
pm-shaping-tool/
├── shaping-app.html          ← Static version (works offline)
├── supabase-schema.sql       ← Database setup
├── vercel.json               ← Deploy config
├── .env.local                ← All environment variables
├── src/
│   ├── app/
│   │   ├── page.tsx          ← Canvas UI (main app)
│   │   ├── layout.tsx        ← Layout + global styles
│   │   ├── globals.css       ← Tailwind
│   │   └── api/
│   │       ├── shape/        ← AI shaping coach
│   │       ├── copilot/      ← AI actions
│   │       ├── score/        ← Scoring engine
│   │       ├── ideas/        ← Ideas CRUD
│   │       ├── dashboard/    ← Portfolio analytics
│   │       ├── insights/     ← AI portfolio insights
│   │       ├── versions/     ← Version history
│   │       └── export/       ← Document generation
│   └── lib/
│       ├── supabase.ts       ← DB client
│       ├── auth.ts           ← Azure AD
│       ├── versions.ts       ← Version logic
│       ├── realtime.ts       ← Collaboration
│       ├── export.ts         ← Export templates
│       └── notifications.ts  ← Alerts + webhooks
```
