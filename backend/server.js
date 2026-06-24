const express = require("express");
const cors = require("cors");
const { connectDB } = require("./db");
const studentRoutes = require("./routes/students");

require("dotenv").config();

const app = express();

app.use(cors());
app.use(express.json());

connectDB();

app.use("/students", studentRoutes);

app.listen(process.env.PORT, () => {
  console.log(`Server running on port ${process.env.PORT}`);
});