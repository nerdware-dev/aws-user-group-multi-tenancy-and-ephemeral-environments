import express, { Request, Response } from "express";
import cors from "cors";
import { config } from "dotenv";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";

import {
  DynamoDBDocumentClient,
  GetCommand,
  PutCommand,
} from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocumentClient.from(client);

config();

const app = express();

app.use(
  cors({
    origin: "*",
    methods: "GET",
  })
);

// Put an item into the DynamoDB table on server start for seeding
const putParams = {
  TableName: process.env.TABLE,
  Item: {
    Tenant: process.env.TENANT,
  },
};

ddbDocClient
  .send(new PutCommand(putParams))
  .then(() => console.log("Item put into DynamoDB table"))
  .catch((error) =>
    console.error("Error putting item into DynamoDB table", error)
  );

app.get("/tenant", async (_: Request, res: Response) => {
  const params = {
    TableName: process.env.TABLE,
    Key: {
      Tenant: process.env.TENANT,
    },
  };

  try {
    const data = await ddbDocClient.send(new GetCommand(params));
    res.send(data.Item?.Tenant.toUpperCase() ?? "UNKNOWN");
  } catch (error) {
    console.error(error);
    res.status(500).send("Error retrieving tenant");
  }
});

app.get("/health", (_: Request, res: Response) => {
  res.send("OK");
});

app.listen(3000, () => console.log("Server is running on port 3000"));

process.on("SIGINT", () => process.exit());
