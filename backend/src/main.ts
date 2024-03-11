import express, { Request, Response } from "express";
import cors from "cors";
import { config } from "dotenv";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  GetCommand,
  PutCommand,
} from "@aws-sdk/lib-dynamodb";

config();

if (!process.env.TABLE || !process.env.TENANT) {
  console.error("Missing TABLE or TENANT environment variable");
  process.exit(1);
}

const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocumentClient.from(client);

const seedDb = async () => {
  const params = {
    TableName: process.env.TABLE,
    Item: {
      Tenant: process.env.TENANT,
    },
  };

  try {
    await ddbDocClient.send(new PutCommand(params));
    console.log("Item put into DynamoDB table");
  } catch (error) {
    console.error("Error putting item into DynamoDB table", error);
  }
};

const getItem = async () => {
  const params = {
    TableName: process.env.TABLE,
    Key: {
      Tenant: process.env.TENANT,
    },
  };

  try {
    return await ddbDocClient.send(new GetCommand(params));
  } catch (error) {
    console.error("Error getting item from DynamoDB table", error);
    throw error;
  }
};

const app = express();

app.use(
  cors({
    origin: "*",
    methods: "GET",
  })
);

// Put an item into the DynamoDB table on server start for seeding
seedDb();

app.get("/tenant", async (_: Request, res: Response) => {
  try {
    const data = await getItem();
    res.send(data.Item?.Tenant.toUpperCase() + ' AWS User Group' ?? "UNKNOWN");
  } catch (error) {
    res.status(500).send("Error retrieving tenant");
  }
});

app.get("/health", (_: Request, res: Response) => {
  res.send("OK");
});

app.listen(3000, () => console.log("Server is running on port 3000"));

process.on("SIGINT", () => process.exit());
