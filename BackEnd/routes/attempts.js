const express = require("express");
const router = express.Router();
const pool = require("../db");

// Submit attempt
router.post("/", async (req, res) => {
  const { user_id, puzzle_id, is_correct, time_taken } = req.body;
  try {
    const result = await pool.query(
      "INSERT INTO attempts (user_id, puzzle_id, is_correct, time_taken) VALUES ($1,$2,$3,$4) RETURNING *",
      [user_id, puzzle_id, is_correct, time_taken]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
