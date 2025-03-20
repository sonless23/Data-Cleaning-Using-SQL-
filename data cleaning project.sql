-- data cleaning

SELECT * 
FROM layoffs;

-- 1 remove duplicates
-- 2 standardize the data
-- 3 null or blank values
-- 4 remove unneccesary columns 

CREATE TABLE layoffs_staging
LIKE layoffs;



INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- 1 to remove duplicates

-- adding a row number so that only duplicate rows would have a row number greater than 1
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`) 
AS `row_number`
FROM layoffs_staging;

-- creating a common table expression for the above
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) 
AS `row_number`
FROM layoffs_staging
)

-- selecting the duplicate rows
SELECT *
FROM duplicate_cte
WHERE `row_number`>1;

-- creating a new table named layoffs_staging2 for backup
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_number` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- inserting our table, along with row number column into new column
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) 
AS `row_number`
FROM layoffs_staging;

-- deleting duplicate rows
DELETE 
FROM layoffs_staging2
WHERE `row_number`>1;


-- 2 standardizing data

-- removing leading and trailing white spaces
UPDATE layoffs_staging2
SET company = TRIM(company),
location = TRIM(location),
industry = trim(industry);

SELECT DISTINCT industry
FROM layoffs_staging2;

-- formatting all crypto industry the same under the industry column
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE '%crypto%';

-- making sure all the crypto industry were formatted accordingly
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'
ORDER BY 1;

-- standardizing united states under country column
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE '%United States%';

-- changing date column from mm/dd/yyyy to yyyy/mm/dd
UPDATE layoffs_staging2
SET `date`=STR_TO_DATE(`date`, '%m/%d/%Y')
;

-- change the data type of date column into date type
ALTER TABLE layoffs_staging2
MODIFY `date` date;


-- 3 removing nulls 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE (t1.industry IS NOT NULL OR t1.industry=' ')
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2;

-- 4 remove unnecessary columns or rows

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN `row_number`;