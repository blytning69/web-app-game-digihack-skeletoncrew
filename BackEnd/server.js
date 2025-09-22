// BackEnd/server.js
require("dotenv").config();
const express = require("express");
const cors = require("cors");
const routes = require("./routes");

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());
app.use("/api", routes);

app.get("/", (req, res) => res.send("Backend server is running 🚀"));

app.listen(PORT, () => console.log(`Server listening on http://localhost:${PORT}`));
