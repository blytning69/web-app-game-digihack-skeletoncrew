-- seed.sql

-- Insert sample users
INSERT INTO users (username, email, password_hash)
VALUES
  ('alice', 'alice@example.com', 'hashedpassword1'),
  ('bob', 'bob@example.com', 'hashedpassword2');

-- Insert sample puzzles
INSERT INTO puzzles (question, answer, difficulty)
VALUES
  ('2 + 2 = ?', '4', 1),
  ('5 * 6 = ?', '30', 2),
  ('(12 / 4) + 7 = ?', '10', 2);

-- Insert sample attempts
INSERT INTO attempts (user_id, puzzle_id, is_correct, time_taken)
VALUES
  (1, 1, TRUE, 5.2),
  (1, 2, FALSE, 10.1),
  (2, 1, TRUE, 3.8);

-- Insert leaderboard entries
INSERT INTO leaderboard (user_id, score)
VALUES
  (1, 100),
  (2, 80);
