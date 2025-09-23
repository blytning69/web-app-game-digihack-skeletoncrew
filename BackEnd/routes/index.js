const express = require("express");
const router = express.Router();

router.use("/users", require("./users"));
router.use("/puzzles", require("./puzzles"));
router.use("/attempts", require("./attempts"));
router.use("/leaderboard", require("./leaderboard"));

module.exports = router;
