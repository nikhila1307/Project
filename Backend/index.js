console.log("Starting server...");
import express from "express";
import dotenv from "dotenv";

dotenv.config();

const app = express();
app.use(express.json());

// Test route
app.get("/", (req, res) => res.send("College API is running"));

const PORT = process.env.PORT || 5000;

app.listen(PORT, "127.0.0.1", () =>
  console.log(`Server running successfully on port ${PORT}`)
);
