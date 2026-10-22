# Company Brain

An internal AI assistant for **Cardinal Peak Capital**, a (fictional) real estate investment firm that buys and operates short-term rentals (STR) and multifamily properties. An employee signs in, asks a question in plain English, and gets an answer grounded in the firm's own documents, spreadsheet and database, with a pointer to the source.

This is a take-home exam project. The assignment brief is in `docs/company-brain-assignment.docx`, and `docs/DATA_MAP.docx` is the source of truth for who may see what.

> **Status: work in progress.** See [Project status](#project-status) for what exists today. Sections marked _planned_ describe the intended design, not working code.

## The core idea: permissions come first

Investor (LP) data is sensitive. A staff member must never be able to get it, whether they ask directly, sideways, or try to talk the assistant out of its rules.

| Role | Can ask about | Never sees |
| --- | --- | --- |
| **staff** | Deals, pipeline, properties, financials, operations | Investor / LP data of any kind |
| **exec** | Everything, including investors | (nothing is off limits) |

Design rules the code follows:

1. **The role comes from the server**, from a signed session cookie. It is never read from the request body and never decided by the model.
2. **Restricted data is filtered before the model sees it.** Prompt instructions are not a security boundary.
3. **One choke point for database access:** `dbFor(role)` in `lib/db.ts`. Both roles share one connection today. It is the single place to split them later (for example, a restricted Postgres role for staff).
4. **Sensitivity is stored on the parent document**, not on each chunk, so a chunk can never disagree with its document. A single Excel file becomes two documents (one open tab, one restricted tab).
5. **Tools take structured inputs and use parameterized queries.** The model never writes free-form SQL.

## Data sources

| Source | What | Sensitivity |
| --- | --- | --- |
| Drive (Word) | `DealMemo_HarborView`, `DealMemo_CedarPark24`, `SOP_GuestDamage` | Internal |
| Drive (Word) | `RESTRICTED_LP_Quarterly_Update_Q1_2026`, `RESTRICTED_Investor_SideLetter_Tamarind` | **Restricted** (exec only) |
| Sheets | `CardinalPeak_Portfolio.xlsx`, tab `Pipeline` | Internal |
| Sheets | `CardinalPeak_Portfolio.xlsx`, tab `Investors_RESTRICTED` | **Restricted** (exec only) |
| Database | `properties`, `financials` | Internal |
| Database | `lp_distributions` | **Restricted** (exec only) |

The data deliberately contains look-alike names (two `Birch Court` properties, two `Harbor View`, and similar) to test disambiguation. The brain should show all matches labeled by city, or ask which one is meant.

## Tech stack

- **Next.js** (App Router) for frontend and backend route handlers, TypeScript
- **Postgres on Supabase**, accessed with **Drizzle ORM** (`postgres` driver)
- **Claude API** for answering, using tool use _(planned)_
- **Biome** for lint and format

## Prerequisites

- Node.js 22 (developed on 22.12.0; the version is not pinned yet)
- A package manager. The commands below use `npm`.
- A free [Supabase](https://supabase.com) project

## Setup

1. **Install dependencies**

   ```bash
   npm install
   ```

2. **Create a `.env` file** in the repo root:

   ```bash
   DATABASE_URL=postgresql://postgres.<project-ref>:<password>@aws-0-<region>.pooler.supabase.com:5432/postgres
   ```

   Use the **Session pooler** string from the Supabase dashboard (Connect). The direct connection (`db.<ref>.supabase.co`) is IPv6 only on the free tier and fails on IPv4-only networks. Avoid special characters in the database password, or percent-encode them.

   `.env` is git-ignored. Never commit it.

3. **Create the tables** (applies the migrations in `drizzle/`):

   ```bash
   npm run db:migrate
   ```

4. **Load the seed data.** Open the Supabase SQL Editor, paste the contents of `db/seeds/001_seed.sql`, and run it. Then check:

   ```sql
   select count(*) from properties;   -- expect 15
   ```

   > Do **not** run `docs/seed.sql` after migrating. It starts with `DROP TABLE` and recreates the tables outside the migration history. `db/seeds/001_seed.sql` holds the `INSERT` statements only. Run it on empty tables: the rows rely on `property_id` values 1 to 15.

5. **Start the app**

   ```bash
   npm run dev
   ```

   Open http://localhost:3000.

## Commands

| Command | What it does |
| --- | --- |
| `npm run dev` | Start the Next.js dev server |
| `npm run build` | Production build |
| `npm run start` | Run the production build |
| `npm run check` | Biome lint and format check |
| `npm run check:fix` | Biome check with auto-fix |
| `npm run lint` / `lint:fix` | Biome lint only |
| `npm run format` / `format:check` | Biome format only |
| `npm run db:generate` | Generate a SQL migration from `db/schema.ts` into `drizzle/` |
| `npm run db:migrate` | Apply pending migrations to the database |

## Database

The schema is **code first**: `db/schema.ts` is the single source of truth, and migrations in `drizzle/` are generated from it. Change the schema, run `npm run db:generate`, read the new SQL file, then `npm run db:migrate`.

| Table | Purpose | Visible to |
| --- | --- | --- |
| `properties` | Property facts | staff, exec |
| `financials` | NOI, cap rate, prices, debt | staff, exec |
| `lp_distributions` | Investor commitments and distributions | **exec only** |
| `documents` | One row per source file, or per file and tab. Holds `sensitivity` (`internal` or `restricted`, enforced by a `CHECK`). | per sensitivity |
| `chunks` | Searchable text for each document. Deleting a document deletes its chunks (`ON DELETE CASCADE`). | inherits from `documents` |

## How a question is answered _(planned)_

```
Browser --POST /api/chat--> 1. Verify session cookie  -> role (staff | exec)
                            2. Build the tool list for that role
                               (staff has no investor tool)
                            3. Call Claude with the question and tools
                            4. Claude asks for a tool; our code runs it with
                               dbFor(role), filtering restricted rows
                            5. Tool result (rows + source ids) goes back to Claude
                            6. Repeat until Claude writes the final answer
                            7. Check the answer, then return it with sources
```

Three layers protect restricted data:

- **Tool list:** staff never receives the investor tool.
- **Query filter:** every tool query excludes restricted rows for staff.
- **Output check:** the final text is scanned before it is returned.

### The allowed-plus-restricted gray area _(planned)_

A question like "Who invested in Birch Court and what is its cap rate?" has an allowed half and a restricted half. The brain answers the deal facts from internal sources and states that the investor part is restricted, without confirming or hinting at any investor detail.

### Honesty

If the answer is not in the data, the brain says so. It never estimates a number. A made-up cap rate is worse than "I couldn't find that."

## Project structure

```
app/            Next.js pages and API route handlers
lib/            Server-only code (database access, auth, tools)
db/             schema.ts (Drizzle schema), seeds/
drizzle/        Generated SQL migrations and snapshots
docs/           Exam brief and the provided source files
openspec/       Change specs and planning artifacts
```

## Project status

- [x] Next.js app scaffolded
- [x] Supabase database connected through Drizzle
- [x] Schema and migration for 5 tables, seed data loaded
- [ ] Ingest script: Word and Excel files into `documents` and `chunks`
- [ ] Login with a signed session cookie (two roles)
- [ ] Chat endpoint with the Claude tool-use loop
- [ ] Chat interface with source citations
- [ ] Red-team test script (personas and attack questions)
- [ ] Demo video and write-up

## Personas and test questions _(planned)_

To be filled in with the staff and exec personas tested, including direct, sideways and prompt-injection attempts, and what happened.

## Next steps with more time

To be filled in.
