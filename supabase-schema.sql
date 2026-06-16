-- SUPABASE SCHEMA FOR PM SHAPING TOOL
-- Run this in Supabase SQL Editor to create all tables

-- Ideas (core entity)
CREATE TABLE ideas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  owner_email TEXT NOT NULL,
  team TEXT DEFAULT '',
  stage TEXT DEFAULT 'discover',
  status TEXT DEFAULT 'draft',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Idea Cards (modular content)
CREATE TABLE idea_cards (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  idea_id UUID REFERENCES ideas(id) ON DELETE CASCADE,
  card_type TEXT NOT NULL, -- problem, user, context, constraints, impact, solution
  content TEXT DEFAULT '',
  version INT DEFAULT 1,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Scores
CREATE TABLE idea_scores (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  idea_id UUID REFERENCES ideas(id) ON DELETE CASCADE,
  impact INT DEFAULT 3,
  effort INT DEFAULT 3,
  confidence INT DEFAULT 3,
  base_score DECIMAL DEFAULT 0,
  org_modifier DECIMAL DEFAULT 1.0,
  final_score DECIMAL DEFAULT 0,
  tier TEXT DEFAULT 'LOW',
  problem_quality TEXT DEFAULT 'LOW',
  routing TEXT DEFAULT '',
  work_type TEXT DEFAULT '',
  readiness TEXT DEFAULT '',
  progress TEXT DEFAULT '',
  timeline TEXT DEFAULT '',
  leadership TEXT DEFAULT '',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Version history
CREATE TABLE idea_versions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  idea_id UUID REFERENCES ideas(id) ON DELETE CASCADE,
  version_number INT NOT NULL,
  snapshot JSONB NOT NULL, -- full idea state at this point
  changed_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- AI interactions log
CREATE TABLE ai_interactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  idea_id UUID REFERENCES ideas(id) ON DELETE CASCADE,
  action TEXT NOT NULL, -- challenge, rewrite, missing, chat
  prompt TEXT,
  response TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE ideas ENABLE ROW LEVEL SECURITY;
ALTER TABLE idea_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE idea_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE idea_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_interactions ENABLE ROW LEVEL SECURITY;

-- Policies (allow all for now — tighten with auth later)
CREATE POLICY "Allow all" ON ideas FOR ALL USING (true);
CREATE POLICY "Allow all" ON idea_cards FOR ALL USING (true);
CREATE POLICY "Allow all" ON idea_scores FOR ALL USING (true);
CREATE POLICY "Allow all" ON idea_versions FOR ALL USING (true);
CREATE POLICY "Allow all" ON ai_interactions FOR ALL USING (true);

-- Indexes
CREATE INDEX idx_ideas_owner ON ideas(owner_email);
CREATE INDEX idx_ideas_status ON ideas(status);
CREATE INDEX idx_idea_cards_idea ON idea_cards(idea_id);
CREATE INDEX idx_idea_scores_idea ON idea_scores(idea_id);
