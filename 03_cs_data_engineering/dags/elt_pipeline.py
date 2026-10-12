import os
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator

default_args = {
    'owner': 'BRAD',
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}

with DAG(
    dag_id='wwi_elt_pipeline',
    default_args=default_args,
    start_date=datetime(2026, 1, 1),
    schedule_interval=None,
    catchup=False,
    template_searchpath=['/opt/airflow/dags'] # Tells Airflow where to find the SQL files
) as dag:

    # 1. Extraction & Loading to Raw
    ingest_raw = BashOperator(
        task_id='ingest_kaggle_to_raw',
        bash_command='cd /opt/airflow/dags && python setup.py'
    )

    # 2. Build DDL Schemas (Strict Order)
    build_application = PostgresOperator(
        task_id='build_application_schema',
        postgres_conn_id='postgres_casestudy',
        sql='01_application_schema.sql'
    )

    build_purchasing = PostgresOperator(
        task_id='build_purchasing_schema',
        postgres_conn_id='postgres_casestudy',
        sql='02_purchasing_schema.sql'
    )

    build_warehouse = PostgresOperator(
        task_id='build_warehouse_schema',
        postgres_conn_id='postgres_casestudy',
        sql='03_warehouse_schema.sql'
    )

    build_sales = PostgresOperator(
        task_id='build_sales_schema',
        postgres_conn_id='postgres_casestudy',
        sql='04_sales_schema.sql'
    )

    # 3. Transform & Migrate Data
    migrate_oltp = PostgresOperator(
        task_id='migrate_raw_to_oltp',
        postgres_conn_id='postgres_casestudy',
        sql='05_migration.sql'
    )

    # Define the Foreign Key execution dependency chain
    ingest_raw >> build_application >> build_purchasing >> build_warehouse >> build_sales >> migrate_oltp