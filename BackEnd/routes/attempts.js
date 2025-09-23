const express = require("express");
const router = express.Router();
const pool = require("../db");

// Submit attempt
router.post("/", async (req, res) => {
  const { user_id, puzzle_id, is_correct, time_taken } = req.body;

  try {
    // 1. Insert attempt
    const attempt = await pool.query(
      "INSERT INTO attempts (user_id, puzzle_id, is_correct, time_taken) VALUES ($1,$2,$3,$4) RETURNING *",
      [user_id, puzzle_id, is_correct, time_taken]
    );

    let pointsAwarded = 0;

    // 2. Update user points if correct
    if (is_correct) {
      pointsAwarded = 10; // 🔥 adjust if you want different scoring
      await pool.query(
        "UPDATE users SET points = points + $1 WHERE id = $2",
        [pointsAwarded, user_id]
      );
    }

    // 3. Return response
    res.json({
      attempt: attempt.rows[0],
      is_correct,
      pointsAwarded,
      message: is_correct
        ? `Correct! You earned ${pointsAwarded} points.`
        : "Incorrect, no points awarded."
    });
  } catch (err) {
    console.error("Error inserting attempt:", err.message);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
