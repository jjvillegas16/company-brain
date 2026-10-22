import { sql } from "drizzle-orm";
import {
  check,
  date,
  integer,
  numeric,
  pgTable,
  serial,
  text,
} from "drizzle-orm/pg-core";

export const properties = pgTable("properties", {
  propertyId: serial("property_id").primaryKey(),
  name: text("name").notNull(),
  street: text("street").notNull(),
  city: text("city").notNull(),
  state: text("state").notNull(),
  zip: text("zip").notNull(),
  propertyType: text("property_type").notNull(),
  beds: integer("beds"),
  baths: numeric("baths", { precision: 3, scale: 1 }),
  houseSizeSqft: integer("house_size_sqft"),
  units: integer("units"),
  acquisitionDate: date("acquisition_date"),
  status: text("status").notNull(),
});

export const financials = pgTable("financials", {
  propertyId: integer("property_id")
    .primaryKey()
    .references(() => properties.propertyId),
  purchasePrice: numeric("purchase_price", { precision: 12, scale: 2 }),
  listPrice: numeric("list_price", { precision: 12, scale: 2 }),
  noiAnnual: numeric("noi_annual", { precision: 12, scale: 2 }),
  capRate: numeric("cap_rate", { precision: 5, scale: 3 }),
  dscr: numeric("dscr", { precision: 4, scale: 2 }),
  debtAmount: numeric("debt_amount", { precision: 12, scale: 2 }),
  occupancyRate: numeric("occupancy_rate", { precision: 5, scale: 3 }),
});

export const lpDistributions = pgTable("lp_distributions", {
  id: serial("id").primaryKey(),
  investorName: text("investor_name").notNull(),
  propertyId: integer("property_id").references(() => properties.propertyId),
  commitment: numeric("commitment", { precision: 12, scale: 2 }),
  ownershipPct: numeric("ownership_pct", { precision: 5, scale: 2 }),
  distributionQ1_2026: numeric("distribution_q1_2026", {
    precision: 12,
    scale: 2,
  }),
});

export const documents = pgTable(
  "documents",
  {
    id: serial("id").primaryKey(),
    source: text("source").notNull(),
    file: text("file").notNull(),
    tab: text("tab"),
    sensitivity: text("sensitivity").notNull(),
  },
  (table) => [
    check(
      "documents_sensitivity_check",
      sql`${table.sensitivity} in ('internal', 'restricted')`,
    ),
  ],
);

export const chunks = pgTable("chunks", {
  id: serial("id").primaryKey(),
  documentId: integer("document_id")
    .notNull()
    .references(() => documents.id, { onDelete: "cascade" }),
  section: text("section").notNull(),
  text: text("text").notNull(),
});
