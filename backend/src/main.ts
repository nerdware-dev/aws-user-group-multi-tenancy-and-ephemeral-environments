import express, { Request, Response } from "express";
import cors from "cors";
import { config } from "dotenv";

config();
const app = express();
app.use(
  cors({
    origin: "*",
    // origin: "https://dsyk0b4nlo587.cloudfront.net/",
    methods: "GET",
  })
);

app.get("/tenant", (_: Request, res: Response) => {
  res.send(process.env.TENANT?.toUpperCase() ?? "UNKNOWN");
});

app.get("/health", (_: Request, res: Response) => {
  res.send("OK");
});

app.listen(3000, () => console.log("Server is running on port 3000"));

process.on("SIGINT", () => process.exit());
