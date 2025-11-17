# sql-layoffs-cleaning-project
SQL Data Cleaning project using MySQL on the Layoffs dataset (2020–2023)
This project focuses on cleaning and preparing the global tech layoffs dataset using MySQL.
It demonstrates practical data-cleaning steps including:

Removing duplicates

Standardizing text fields

Fixing inconsistent date formats

Handling null values

Preparing a clean production-ready table

#Tools Used

MySQL 8

MySQL Workbench

The dataset includes global company layoff information with fields such as:

Company

Location

Industry

Total laid off

Percentage laid off

Date

Country

Stage

Funds raised

Data Cleaning Steps
1️⃣ Create a staging table

We first create a copy of the raw table to avoid modifying the original dataset.

2️⃣ Identify and remove duplicates

Using window functions (ROW_NUMBER) to detect duplicates.

3️⃣ Standardize text fields

Trimming spaces

Fixing inconsistent industry names

Removing trailing characters in country names

4️⃣ Fix date format

Converting text dates into proper MySQL DATE datatype.

5️⃣ Handle null and blank values

Filling missing industries using other rows of the same company

Removing rows with no useful data
📜 SQL Script

All SQL queries used in this project are included in the file:

➡️ layoffs_project.sql

This script is fully executable from start to finish.

📊 Final Output

The final cleaned dataset is stored in:

layoffs_staging2


This version is free of duplicates, null-data rows, formatting issues, and incorrect dates.

👨‍💻 About This Project

This is part of my SQL portfolio and demonstrates:

Real-world data cleaning

Complex SQL logic

Analytical preparation

Best practices for MySQL cleaning pipelines
