# E-commerce Data Warehouse: Production Setup

## Overview
This folder contains scripts, configs, and documentation for a production-grade e-commerce data warehouse system, including:
- OLTP (transactional) schema
- Data warehouse (star schema)
- Data marts (snowflake schema)
- ETL orchestration (Airflow or cron)
- Logging, validation, and security
- GDPR compliance notes

## Folder Structure
```
production/
  README.md                # This file
  configs/
    airflow_connections.env
    warehouse.env
  etl/
    etl_main.sql           # Main ETL script (OLTP → warehouse → marts)
    etl_advanced.sql       # Advanced ETL logic (SCD, incremental, audit)
    etl_validation.sql     # Data validation SQL scripts
    etl_logging.sql        # ETL logging and error handling
    airflow_dag.py         # Sample Airflow DAG for ETL orchestration
  ddl/
    oltp_schema.sql        # Normalized OLTP schema
    warehouse_star.sql     # Star schema
    marts_snowflake.sql    # Data marts
    sample_data.sql        # Sample data for OLTP
    user_roles.sql         # User/role setup SQL
```

## Setup Steps
1. **Deploy OLTP and warehouse databases** (PostgreSQL recommended)
2. **Run DDL scripts** in `ddl/` to create schemas and sample data
3. **Configure environment variables** in `configs/`
4. **Set up users/roles** using `user_roles.sql`
5. **Schedule ETL** using Airflow (`airflow_dag.py`) or cron
6. **Monitor ETL** with logging and validation scripts
7. **Connect BI tools/data science notebooks** to the warehouse/marts

## GDPR Considerations
- **Data Minimization:** Only store necessary personal data in the warehouse.
- **Pseudonymization:** Use surrogate keys and avoid exposing direct identifiers to analysts.
- **Access Control:** Restrict access to PII (e.g., emails, names) via roles and views.
- **Right to Erasure:** Implement procedures to delete or anonymize user data upon request.
- **Audit Logging:** Log access to sensitive data and ETL operations.
- **Data Retention:** Define and enforce retention periods for personal data.
- **Encryption:** Ensure data is encrypted at rest and in transit.

## Operational Notes
- All ETL jobs are idempotent and can be rerun safely.
- ETL audit and error logs are stored in the warehouse for traceability.
- Data validation scripts should be run after each ETL batch.
- For production, use managed PostgreSQL or a cloud data warehouse with backups and monitoring.

## Cloud Migration Notes
- All ETL and schema scripts are compatible with major cloud data warehouses (BigQuery, Redshift, Snowflake).
- Use cloud-native partitioning and clustering for large tables.
- Use managed Airflow (e.g., Cloud Composer, MWAA) for orchestration.
- Store configs/secrets in cloud secret managers.
- For migration, export/import data using cloud tools (e.g., bq, aws s3, snowflake CLI).

## Modular ETL, Partitioning, and Monitoring
- ETL scripts are modular and can be run in parallel (see `etl/` folder).
- FactSales is partitioned by month for scalability.
- Automated data tests and monitoring scripts are provided in `etl/data_tests.sql`.

---
For questions or onboarding, contact the data engineering team. 