import express, { Request, Response } from "express";
import cors from "cors";

const app = express();
app.use(
  cors({
    origin: "*",
    // origin: "https://dsyk0b4nlo587.cloudfront.net/",
    methods: "GET",
  })
);

app.get("/data", (_: Request, res: Response) => {
  res.send("Lorem Ipsum!");
});

app.get("/health", (_: Request, res: Response) => {
  res.send("OK");
});

app.listen(3000, () => console.log("Server is running on port 3000"));

process.on("SIGINT", () => process.exit());
