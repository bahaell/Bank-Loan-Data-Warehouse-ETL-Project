Bank Loan Data Warehouse ETL Project
Overview
This project implements an ETL (Extract, Transform, Load) pipeline to build a Data Warehouse for analyzing bank loan data. The pipeline extracts data from multiple sources (SQL Server, MongoDB, and flat CSV files), transforms it for consistency and analysis, and loads it into a SQL Server Data Warehouse (BankLoanDW). The project uses SQL Server Integration Services (SSIS) for orchestration and includes scripts for data cleaning and validation.
The Data Warehouse supports analytical queries to derive insights such as loan amounts by state, average interest rates by loan grade, and borrower demographics.
Features

Data Sources:
SQL Server: BorrowerSource table in BankLoanDB.
MongoDB: LoanSource collection in BankLoanDB.
CSV Files: dim_loan.csv, dim_borrower.csv, dim_date.csv, dim_location.csv, staging_fact_loan.csv.


Staging Tables: Temporary tables (Staging_Loan, Staging_Borrower, Staging_Date, Staging_Location, Staging_FactLoan) for data extraction and transformation.
Dimension and Fact Tables: DimLoan, DimBorrower, DimDate, DimLocation, FactLoan for analytical queries.
ETL Pipeline: Built with SSIS to extract, clean, normalize, and load data.
Data Cleaning: Python scripts to validate and format CSV files.

Prerequisites

SQL Server: SQL Server 2019 or later with SQL Server Management Studio (SSMS).
SQL Server Integration Services (SSIS): Installed via Visual Studio (SQL Server Data Tools).
MongoDB: MongoDB Community Server (v5.0 or later).
Python: Python 3.8 or later with pandas library (pip install pandas).
Git: For cloning and managing the repository.
Windows OS: For SSMS and SSIS compatibility.

Installation

Clone the Repository:
git clone https://github.com/bahaell/Bank-Loan-Data-Warehouse-ETL-Project
cd bank-loan-dw


Set Up SQL Server:

Create the source database BankLoanDB:CREATE DATABASE BankLoanDB;


Create the Data Warehouse database BankLoanDW:CREATE DATABASE BankLoanDW;


Run the SQL scripts in sql/ to create tables:
sql/create_source_tables.sql: Creates BorrowerSource in BankLoanDB.
sql/create_staging_tables.sql: Creates staging tables in BankLoanDW.
sql/create_dw_tables.sql: Creates dimension and fact tables in BankLoanDW.




Set Up MongoDB:

Install MongoDB and ensure the server is running (mongod).
Create the LoanSource collection in the BankLoanDB database.
Import sample data (e.g., via mongoimport or a script in scripts/).


Prepare CSV Files:

Place the CSV files (dim_loan.csv, dim_borrower.csv, dim_date.csv, dim_location.csv, staging_fact_loan.csv) in the data/ directory.
Run the Python cleaning scripts to validate and format CSVs:python scripts/clean_fact_loan.py
python scripts/format_fact_loan.py




Configure SSIS:

Open BankLoanETL.sln in Visual Studio (SSDT).
Update connection strings for:
SQL Server (BankLoanDB and BankLoanDW).
MongoDB (requires a connector like CData SSIS Components for MongoDB).
Flat files (data/ directory).


Deploy the SSIS package (BankLoanETL.dtsx) to SQL Server.



Usage

Import CSV Data:

Use SSMS to import CSV files into staging tables:
Right-click BankLoanDW > Tasks > Import Data.
Select each CSV file from data/ and map to the corresponding staging table.


Alternatively, use sql/bulk_insert_staging.sql for BULK INSERT.


Run the ETL Pipeline:

Execute the SSIS package BankLoanETL.dtsx in Visual Studio or via SQL Server Agent.
The pipeline will:
Extract data from BorrowerSource (SQL Server), LoanSource (MongoDB), and staging tables.
Transform data (cleaning, normalization, key mapping).
Load data into dimension (DimLoan, DimBorrower, DimDate, DimLocation) and fact (FactLoan) tables.









