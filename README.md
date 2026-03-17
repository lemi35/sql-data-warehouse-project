# SQL Data Warehouse Project

Building a Data Warehouse solution using Microsoft SQL Server, including ETL processes, data modeling, and analytics.

## Project Overview

This project demonstrates an end-to-end data warehousing and analytics solution.  
It covers the full lifecycle of data processing — from ingesting raw data from source systems, transforming and loading it into a structured data warehouse, and finally generating analytical insights using SQL queries.

The purpose of this project is to simulate a real-world enterprise environment where multiple operational data sources are integrated into a centralized reporting system.

## Architecture

The project follows a traditional data warehouse architecture:

Source Systems → Staging Layer → Data Warehouse → Analytics / Reporting

### Main Components

- Raw source data (CSV or transactional datasets)
- Staging database layer
- ETL processes implemented with SQL scripts and stored procedures
- Dimensional Data Warehouse using Star Schema modeling
- Analytical SQL queries for business insights

## Technologies Used

- Microsoft SQL Server  
- T-SQL  
- SQL Server Management Studio (SSMS)  
- Stored Procedures for ETL logic  
- Dimensional Data Modeling (Star Schema)

Optional extensions:

- Power BI for visualization
- Python for automation
- Docker for environment setup

## Data Sources

The warehouse integrates structured datasets representing operational systems such as:

- Customer data
- Product catalog
- Sales transactions
- Order information

Data is first loaded into staging tables before transformation and loading into the warehouse.

## ETL Process

### Extract

- Import raw data into staging tables
- Validate data types and mandatory fields

### Transform

- Clean missing or inconsistent data
- Standardize formats
- Remove duplicate records
- Generate surrogate keys
- Apply business transformation rules

### Load

- Populate dimension tables
- Load fact tables
- Maintain referential integrity
- Support incremental loading strategies

## Data Warehouse Model

The warehouse is designed using a Star Schema approach.

### Dimension Tables

- DimCustomer  
- DimProduct  
- DimDate  
- DimRegion  

### Fact Tables

- FactSales  
- FactOrders  

This structure supports efficient aggregation and analytical queries.

## Analytics Use Cases

Example analytical queries include:

- Total sales by region and time period
- Monthly revenue trends
- Customer purchasing behavior analysis
- Product performance tracking
- Identification of top customers and products

## Data Quality and Validation

The project includes mechanisms to ensure data reliability:

- Duplicate detection queries
- Referential integrity validation
- ETL logging tables
- Error handling procedures

## How to Run the Project

1. Install Microsoft SQL Server (SQL Server container runs in linux/amd64 emulation on Apple Silicon)
2. Open SQL Server Management Studio (SSMS)
3. Create a new database
4. Execute SQL scripts in the following order:

- create_schema.sql
- create_staging_tables.sql
- etl_load.sql
- create_dw_tables.sql
- analytics_queries.sql

## Learning Objectives

This project demonstrates practical skills in:

- Data warehouse architecture design
- ETL pipeline development
- Dimensional data modeling
- SQL performance and query optimization
- Data validation and troubleshooting
- Business analytics reporting

## Future Improvements

- Implement automated incremental loading
- Add indexing and performance tuning
- Integrate Power BI dashboards
- Add Python orchestration scripts
- Implement logging and monitoring tools
- Containerize environment using Docker

## Author

This project was created as part of a technical portfolio to demonstrate skills in SQL, data engineering, analytics, and system integration concepts.
