import os
import re
import duckdb
import kagglehub
import shutil
from os import getenv, getcwd
from pathlib import Path
from dotenv import load_dotenv


# Load environment variables from .env file
load_dotenv()

# Read database connection settings from .env file
PG_HOST = os.getenv("POSTGRES_HOST")
PG_PORT = os.getenv("POSTGRES_PORT")
PG_DB = os.getenv("POSTGRES_DB")
PG_USER = os.getenv("POSTGRES_USER")
PG_PASS = os.getenv("POSTGRES_PASSWORD")



# Initialize an in-memory DuckDB connection
conn = duckdb.connect(':memory:')
# Install and load the extension
conn.execute("INSTALL postgres;")
conn.execute("LOAD postgres;")
# Attach the PostgreSQL database
attach_query = f"""
    ATTACH 'host={PG_HOST} port={PG_PORT} dbname={PG_DB} user={PG_USER} password={PG_PASS}' 
    AS pg_link (TYPE POSTGRES);
"""
conn.execute(attach_query)




# Download kaggle dataset
KAGGLE_DATASET = "pauloviniciusornelas/wwimporters"
print(F"Downloading Kaggle dataset: {KAGGLE_DATASET}")
data_path = kagglehub.dataset_download(KAGGLE_DATASET)
csv_files = list(Path(data_path).rglob("*.csv"))

local_raw_dir = Path("./raw_data")
local_raw_dir.mkdir(parents=True, exist_ok=True)

# Clean table names from CSV files
def clean_table_name(filename):
    name = filename.lower().replace(".csv", "")
    name = re.sub(r"[^a-z0-9_]", "_", name)
    return name.strip("_")


for filepath in csv_files:
    table_name = clean_table_name(filepath.name)

    destination = local_raw_dir / filepath.name
    shutil.copy2(filepath, destination)

    print(f"Loading {filepath.name} into raw.{table_name}...")
    
    # Read the CSV and create the table inside the 'raw' schema
    ingest_query = f"""
        CREATE OR REPLACE TABLE pg_link.raw.{table_name} AS 
        SELECT * FROM read_csv_auto('{filepath}', nullstr='NULL');
    """
    conn.execute(ingest_query)

print("All files loaded into the raw schema successfully and copied to ./raw_data.")