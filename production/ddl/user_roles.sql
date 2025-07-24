-- User and Role Setup for OLTP and Data Warehouse (GDPR Compliant)

-- OLTP Users
CREATE ROLE oltp_user LOGIN PASSWORD 'oltp_pass';
CREATE DATABASE oltp_db OWNER oltp_user;

-- Warehouse Users
CREATE ROLE warehouse_user LOGIN PASSWORD 'warehouse_pass';
CREATE DATABASE warehouse_db OWNER warehouse_user;

-- Read-only Analyst/Data Scientist Role
CREATE ROLE analyst_user LOGIN PASSWORD 'analyst_pass';
GRANT CONNECT ON DATABASE warehouse_db TO analyst_user;
GRANT USAGE ON SCHEMA public TO analyst_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO analyst_user;

-- Restrict access to PII columns (example: create views without PII)
-- CREATE VIEW vw_fact_sales_no_pii AS SELECT ... FROM FactSales ...; 