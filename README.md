# SQL Data Cleaning Project
## Project Overview
This project focuses on cleaning and transforming raw data in a SQL database to improve its quality for analysis. The dataset used contained inconsistencies such as missing values, incorrect data types, and formatting issues, which were systematically addressed using SQL queries.
## Dataset Description
The dataset comes from layoff_staging, which contains company layoff records. However, the raw data had several inconsistencies that needed cleaning. These included:

•	Date inconsistencies (stored as VARCHAR instead of DATE)

•	Null or missing values in critical fields

•	Duplicate records

•	Inconsistent text formatting (e.g., company names in mixed cases)
## SQL Techniques Used
To clean the data, the following SQL techniques were applied:
- ALTER TABLE 
- MODIFY COLUMN 
- STR_TO_DATE
-	UPDATE, 
- CASE WHEN
-	DELETE 
- ROW_NUMBER() 
- DISTINCT)
-	TRIM()
## Key Data Cleaning Steps
1.	Convert Date Format:
 ```sql
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
```

	ALTER TABLE layoffs_staging2
	MODIFY `date` DATE;

2.	Remove Duplicates:
```sql
DELETE FROM layoffs_staging2
WHERE id NOT IN (
SELECT MIN(id) FROM layoffs_staging2
GROUP BY company, date, total_laid_off;
```


3.	Standardize Text Fields:
```sql
-- removing leading and trailing white spaces
UPDATE layoffs_staging2
SET company = TRIM(company),
location = TRIM(location),
industry = trim(industry);
```

## Insights & Findings
•	Standardizing text fields and overall cleaning of dataset improved the accuracy of analysis.
## Future Improvements
•	Automate data cleaning using stored procedures.
•	Use data validation constraints to prevent dirty data from entering the system.

________________________________________


