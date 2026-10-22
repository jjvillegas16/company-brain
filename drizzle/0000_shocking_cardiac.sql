CREATE TABLE "chunks" (
	"id" serial PRIMARY KEY NOT NULL,
	"document_id" integer NOT NULL,
	"section" text NOT NULL,
	"text" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "documents" (
	"id" serial PRIMARY KEY NOT NULL,
	"source" text NOT NULL,
	"file" text NOT NULL,
	"tab" text,
	"sensitivity" text NOT NULL,
	CONSTRAINT "documents_sensitivity_check" CHECK ("documents"."sensitivity" in ('internal', 'restricted'))
);
--> statement-breakpoint
CREATE TABLE "financials" (
	"property_id" integer PRIMARY KEY NOT NULL,
	"purchase_price" numeric(12, 2),
	"list_price" numeric(12, 2),
	"noi_annual" numeric(12, 2),
	"cap_rate" numeric(5, 3),
	"dscr" numeric(4, 2),
	"debt_amount" numeric(12, 2),
	"occupancy_rate" numeric(5, 3)
);
--> statement-breakpoint
CREATE TABLE "lp_distributions" (
	"id" serial PRIMARY KEY NOT NULL,
	"investor_name" text NOT NULL,
	"property_id" integer,
	"commitment" numeric(12, 2),
	"ownership_pct" numeric(5, 2),
	"distribution_q1_2026" numeric(12, 2)
);
--> statement-breakpoint
CREATE TABLE "properties" (
	"property_id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"street" text NOT NULL,
	"city" text NOT NULL,
	"state" text NOT NULL,
	"zip" text NOT NULL,
	"property_type" text NOT NULL,
	"beds" integer,
	"baths" numeric(3, 1),
	"house_size_sqft" integer,
	"units" integer,
	"acquisition_date" date,
	"status" text NOT NULL
);
--> statement-breakpoint
ALTER TABLE "chunks" ADD CONSTRAINT "chunks_document_id_documents_id_fk" FOREIGN KEY ("document_id") REFERENCES "public"."documents"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "financials" ADD CONSTRAINT "financials_property_id_properties_property_id_fk" FOREIGN KEY ("property_id") REFERENCES "public"."properties"("property_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "lp_distributions" ADD CONSTRAINT "lp_distributions_property_id_properties_property_id_fk" FOREIGN KEY ("property_id") REFERENCES "public"."properties"("property_id") ON DELETE no action ON UPDATE no action;