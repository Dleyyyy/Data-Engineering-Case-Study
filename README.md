# Wide World Importers Data Engineering Pipeline
**Author:** Dleyy

*I built this project as my official submission for the weekly case study requirement in the **Analytics Solutions Bootcamp** by Josh Dev PH.*

## AI Usage Disclosure
*   **Learning & Architecture:** Because building this pipeline involved tools and frameworks that were completely new to me, I utilized AI as a technical mentor to help me understand core concepts and guide my architectural decisions.
*   **Debugging & Best Practices:** I leveraged AI to learn industry best practices and troubleshoot unfamiliar errors. This guided approach allowed me to understand the mechanics behind the bugs so I could eventually write the solutions and fix the pipeline independently.

## Acknowledgements & Sources
*   **Dataset:** The raw CSV data was sourced from [Kaggle: Wide World Importers CSV dataset](https://www.kaggle.com/datasets/pauloviniciusornelas/wwimporters).
*   **Schema Documentation:** The database architecture and business rules were referenced from the official [Microsoft WideWorldImporters OLTP catalog](https://learn.microsoft.com/en-us/sql/samples/wide-world-importers-oltp-database-catalog) and [OLAP catalog](https://learn.microsoft.com/en-us/sql/samples/wide-world-importers-dw-database-catalog).

## Solution Overview
This repository contains an end-to-end ELT (Extract, Load, Transform) data pipeline for Wide World Importers (WWI), a fictional wholesale distributor. The pipeline extracts raw operational CSV data dynamically using Kagglehub, loads it into a normalized OLTP PostgreSQL database via DuckDB, and transforms it into an analytics-ready dimensional model (OLAP star schema) using dbt. The entire workflow is orchestrated via Apache Airflow.

## Technology Stack and Prerequisites
*   **Containerization:** Docker & Docker Compose (Hosts PostgreSQL and Airflow)
*   **Orchestration:** Apache Airflow
*   **Database:** PostgreSQL (Target OLTP & OLAP database)
*   **Extraction & Loading (EL):** Python (`kagglehub`) for extraction and DuckDB for fast bulk ingestion into PostgreSQL.
*   **Transformation (T):** dbt (Data Build Tool)

**Prerequisites:**
*   Docker Desktop installed and running.
*   Python 3.10+ (for local dbt execution).
*   A Python virtual environment (`venv`) to isolate local project dependencies.

## Setup Instructions

1.  **Configure Environment Variables:** 
    Create a local `.env` file in the root of the project:
    ```bash
    cp dags/.env.example dags/.env
    ```
    Open the `dags/.env` file and populate it with the required PostgreSQL and Airflow configuration:
    ```env
    POSTGRES_HOST="postgres-db-casestudy"
    POSTGRES_PORT=5432
    POSTGRES_USER="admin"
    POSTGRES_PASSWORD="password"
    POSTGRES_DB="casestudy_db"
    _PIP_ADDITIONAL_REQUIREMENTS="duckdb kagglehub python-dotenv"
    AIRFLOW_CONN_POSTGRES_CASESTUDY="postgresql://admin:password@postgres-db-casestudy:5432/casestudy_db"
    ```

2.  **Configure the Python Environment:** 
    Create and activate a virtual environment, then install the required dependencies (including dbt) from the `requirements.txt` file.
    ```bash
    python -m venv venv
    
    # On Windows:
    venv\Scripts\activate
    # On macOS/Linux:
    # source venv/bin/activate
    
    pip install -r requirements.txt
    ```

3.  **Start the Infrastructure:** 
    Boot up the Docker containers. The `_PIP_ADDITIONAL_REQUIREMENTS` variable will ensure Airflow installs the necessary libraries for the extraction script.
    ```bash
    docker compose up -d
    ```

## Pipeline Execution (One Entry Point)
The entire workflow is orchestrated as a single DAG in Apache Airflow. 
1. Open the Airflow UI (`http://localhost:8083`).
2. Unpause and trigger the `wwi_elt_pipeline` DAG. 
3. This single entry point will automatically:
    * Trigger `dags/setup.py` to download the CSV dataset via `kagglehub` and ingest it into the `raw` schema using DuckDB.
    * Build the OLTP schemas (Application, Purchasing, Warehouse, Sales).
    * Migrate the raw data into the normalized OLTP tables.
    * Trigger the `dbt run` and `dbt test` commands to build the final OLAP dimensional model.

---

## Data Architecture & Modeling

### Source-to-Target Table Mapping
| Target OLAP Table | Source OLTP Tables (Kaggle CSVs) | Description |
| :--- | :--- | :--- |
| `dim_date` | *Generated via dbt (GENERATE_SERIES)* | Standard calendar and custom WWI fiscal calendar. |
| `dim_city` | `cities`, `stateprovinces`, `countries` | Geographic dimensions and territories. |
| `dim_customer` | `customers`, `customercategories`, `buyinggroups` | Customer profiles and assigned categories. |
| `dim_employee` | `people` | Salesperson and employee profiles. |
| `dim_stock_item` | `stockitems`, `colors`, `packagetypes` | Product inventory and packaging details. |
| `fact_order` | `orders`, `orderlines` | Order transaction measures and dates. |
| `fact_sale` | `invoices`, `invoicelines` | Finalized sale metrics, taxes, and profits. |

### Fact-Table Grain Definitions
*   **`fact_order`:** The grain is **one row per customer order line**. It captures the specific quantity and expected dates at the moment the order was placed.
*   **`fact_sale`:** The grain is **one row per customer invoice line**. It captures the finalized financial metrics, including tax, extended amounts, and calculated profit.

### Explanation of the Dimensional Model
The model follows a standard Kimball Star Schema centered around sales activities. The normalized OLTP tables were denormalized into rich, wide dimension tables. The date dimension handles custom fiscal logic where the financial year begins on November 1. Surrogate keys are used exclusively to join facts to dimensions, abstracting away the source system's natural keys and enabling historical tracking.

### Slowly Changing Dimensions (SCD) Approach
*   **SCD Type 2 (History Tracking):** Applied to `dim_customer`. Configured via dbt snapshots, this tracks changes to customer attributes (like `CustomerCategory` or `CreditLimit`) over time. It generates a new surrogate key, closes the old record with an `effective_end_date`, and ensures past `fact_sale` records remain tied to the customer profile exactly as it existed on the transaction date.
*   **SCD Type 1 (Overwrite):** Applied to `dim_city`, `dim_employee`, and `dim_stock_item`. Geographic boundaries and employee names rarely require point-in-time historical reporting for basic sales analytics. Using Type 1 reduces pipeline complexity and storage overhead where historical context adds no business value.

---
## Engineering & Solution Answers

**1. Why did you choose your database, ingestion, transformation, and orchestration tools?**
*   **PostgreSQL:** A robust, open-source relational database that easily handles both OLTP constraints and moderate OLAP workloads.
*   **DuckDB:** Used for EL (Extract & Load) due to its exceptional speed in reading raw CSVs and executing bulk inserts directly into PostgreSQL.
*   **dbt:** The industry standard for SQL-first transformations, native data quality testing, and out-of-the-box SCD Type 2 snapshot handling.
*   **Airflow:** Provides robust dependency management, retry logic, and clear visibility into pipeline bottlenecks or failures.

**2. How does your pipeline prevent duplicates and produce consistent results when the same input is processed more than once?**
The pipeline is fully idempotent. 
*   The raw-to-OLTP ingestion utilizes `TRUNCATE` / `INSERT` or strictly defined Primary Keys to prevent duplicate source records. 
*   dbt snapshots use unique business keys and `strategy='check'` to only insert new rows if data actually changed. 
*   dbt mart tables are materialized as `table` or `view`, meaning they are cleanly dropped and recreated from the source of truth on every run, eliminating duplicate aggregations.

**3. What would you change if the source produced millions of records per day and the business required hourly warehouse updates?**
*   **Extraction:** Transition from batch CSV processing to incremental streaming (e.g., Kafka) or Change Data Capture (CDC via Debezium) tracking the source database logs.
*   **Transformation:** Change dbt materializations for fact tables from `table` to `incremental` so only the new hour's data is processed.
*   **Storage:** Partition the PostgreSQL fact tables by `date_key`, or migrate the OLAP layer to a distributed columnar data warehouse (e.g., Snowflake, BigQuery, or Redshift).

**4. Known Assumptions and Limitations**
*   **Missing Dates:** Null receipt and delivery dates are permitted in the OLTP schema, as real-world logistics assume not all orders are finalized immediately.
*   **Baseline Snapshot Dates:** The initial dbt snapshot for `dim_customer` is artificially backdated to `1900-01-01` to ensure historical Kaggle transactions (2013-2016) successfully resolve to a valid surrogate key.
*   **SCD Type 2 Demonstration:** Because the Kaggle dataset is a static historical extract, demonstrating SCD Type 2 requires a simulated update. After the initial pipeline run, users can manually trigger a downstream SQL update script to alter a customer's `CustomerCategory` in the OLTP database, followed by a second Airflow DAG run to observe dbt capturing the historical snapshot.

**5. How does your pipeline handle data-quality failures?**
Data quality is enforced using native `dbt test` definitions (e.g., `not_null`, `unique`, and relational integrity tests). I have configured the pipeline with a "fail clearly" behavior. If any critical data quality test fails during the transformation phase, the Airflow task will immediately fail and halt downstream execution. This prevents corrupted or orphaned analytics records from reaching the final presentation layer.

---

## Diagrams & Evidence

### Pipeline Architecture
![Pipeline Diagram](<pipeline diagram.png>)

### OLTP Schema
![OLTP Database Schema](WWI.png)

### OLAP Schema

![OLAP Database Schema](<WWI olap.png>)


### Business Questions
The complete SQL queries and result tables for the 10 case study business questions have been documented separately to keep this README concise.
[View the Business Questions & SQL Outputs here](BusinessQuestions.md)