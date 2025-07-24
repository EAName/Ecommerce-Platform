# E-commerce Data Warehouse

A production-ready, modular, and scalable data warehouse solution for e-commerce analytics. This project supports GDPR compliance, Airflow orchestration, and seamless cloud migration, making it suitable for both on-premise and cloud deployments.

## Project Overview
This repository provides a comprehensive data warehouse architecture for e-commerce businesses, enabling advanced analytics, business intelligence, and regulatory compliance. The solution is designed for extensibility, operational robustness, and ease of integration with modern data tools.

## Key Features
- **Modular ETL**: Easily extend or modify ETL logic for new sources or business rules.
- **Production-Grade Schemas**: Includes OLTP, star schema, and snowflake data marts.
- **Airflow Orchestration**: Sample DAG for automated ETL scheduling and monitoring.
- **GDPR Compliance**: Built-in patterns for data minimization, pseudonymization, and access control.
- **Cloud Migration Ready**: Compatible with BigQuery, Redshift, Snowflake, and managed Airflow.
- **Data Validation & Logging**: Automated tests and robust logging for data quality and traceability.

## Architecture & Folder Structure
```
Ecommerce Platform/
  production/
    configs/         # Environment and connection configs
    ddl/             # DDL scripts for OLTP, warehouse, marts
    etl/             # Modular ETL, validation, logging, Airflow DAG
    README.md        # Full setup and operational details
  archive/           # Reference SQL, ERDs, and advanced patterns
  README.md          # Project overview (this file)
```

## Prerequisites
- PostgreSQL (or compatible cloud data warehouse)
- Python 3.x (for Airflow DAGs)
- Airflow (optional, for orchestration)
- Access to cloud data warehouse (optional, for migration)

## Quick Start
1. **Clone the repository**
   ```sh
   git clone https://github.com/EAName/Ecommerce-Platform.git
   cd Ecommerce-Platform/production
   ```
2. **Deploy databases** (PostgreSQL recommended)
3. **Run DDL scripts** in `ddl/` to create schemas and sample data
4. **Configure environment variables** in `configs/`
5. **Set up users/roles** using `ddl/user_roles.sql`
6. **Schedule ETL** using Airflow (`etl/airflow_dag.py`) or cron
7. **Monitor ETL** with logging and validation scripts
8. **Connect BI tools or notebooks** to the warehouse/marts

For advanced setup, operational notes, and cloud migration, see [`production/README.md`](production/README.md).

## GDPR & Compliance Highlights
- Data minimization, pseudonymization, and access control patterns
- Right to erasure and audit logging
- Data retention and encryption best practices

## Cloud Migration Support
- Scripts compatible with BigQuery, Redshift, Snowflake
- Cloud-native partitioning, clustering, and managed Airflow support
- Config/secrets management and migration tooling guidance

## Contribution
Contributions are welcome! Please open issues or submit pull requests for improvements, bug fixes, or new features. For major changes, please discuss with the maintainers first.

---
For full setup and operational details, see [`production/README.md`](production/README.md). 