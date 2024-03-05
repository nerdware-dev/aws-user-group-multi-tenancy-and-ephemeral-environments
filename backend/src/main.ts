import express, { Request, Response } from "express";

const app = express();

app.get("/data", (_: Request, res: Response) => {
  res.send("Lorem Ipsum!");
});

app.listen(3000, () => console.log("Server is running on port 3000"));

process.on("SIGINT", () => process.exit());
