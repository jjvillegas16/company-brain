import { sql } from "drizzle-orm";
import { dbFor } from "@/lib/db";

export async function GET() {
  try {
    const rows = await dbFor("staff").execute(
      sql`select count(*)::int as n from properties`,
    );
    return Response.json({ n: rows[0].n });
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    return Response.json({ error: message }, { status: 500 });
  }
}
