import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";

const databaseUrl = process.env.DATABASE_URL;
if (!databaseUrl) {
  throw new Error("DATABASE_URL is not set");
}

const client = postgres(databaseUrl, { prepare: false });
const db = drizzle(client);

export type Role = "staff" | "exec";

export function dbFor(_role: Role) {
  return db;
}
