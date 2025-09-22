-- Drop existing tables if they exist (safe reset)
DROP TABLE IF EXISTS attempts CASCADE;
DROP TABLE IF EXISTS leaderboard CASCADE;
DROP TABLE IF EXISTS puzzles CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Puzzles table
CREATE TABLE puzzles (
    id SERIAL PRIMARY KEY,
    maze_data JSONB NOT NULL,  -- store maze as JSON
    difficulty VARCHAR(20) NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Attempts table (records each user solving a puzzle)
CREATE TABLE attempts (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    puzzle_id INT REFERENCES puzzles(id) ON DELETE CASCADE,
    time_taken INTERVAL NOT NULL,
    solved BOOLEAN DEFAULT FALSE,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Leaderboard table (aggregated scores)
CREATE TABLE leaderboard (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    total_score INT DEFAULT 0,
    rank INT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_attempts_user ON attempts(user_id);
CREATE INDEX idx_attempts_puzzle ON attempts(puzzle_id);
CREATE INDEX idx_leaderboard_user ON leaderboard(user_id);
