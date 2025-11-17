USE world_layoffs;
SELECT DATABASE();

-- 1. COPY RAW TABLE INTO A STAGING TABLE
CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- 2. CHECK DUPLICATES
WITH duplicate_cte AS (
    SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry,
                     total_laid_off, percentage_laid_off,
                     `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- 3. CREATE CLEAN STAGING2 TABLE
CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off BIGINT,
  percentage_laid_off BIGINT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT,
  row_num INT
);

-- POPULATE staging2 WITH ROW_NUM
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY company, location, industry,
                 total_laid_off, percentage_laid_off,
                 `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- REMOVE DUPLICATES
DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- 4. STANDARDIZE COMPANY NAMES
UPDATE layoffs_staging2
SET company = TRIM(company);

-- 5. FIX INDUSTRY SPELLINGS
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- 6. FIX COUNTRY FORMATTING
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- 7. CONVERT DATE TO DATE TYPE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 8. HANDLE MISSING INDUSTRIES USING SELF JOIN
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;

-- 9. REMOVE USELESS ROWS
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- 10. REMOVE TEMPORARY ROW_NUM COLUMN
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- FINAL CLEANED TABLE
SELECT * FROM layoffs_staging2;

