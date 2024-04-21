-- create a copy of table

CREATE TABLE copy 
LIKE layoffs;

INSERT copy
SELECT * FROM layoffs;

SELECT * FROM copy;

-- removing duplicates


SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry,
  total_laid_off, percentage_laid_off,
  `date` , stage, country, funds_raised_millions) AS row_num
FROM copy;

WITH  duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry,
  total_laid_off, percentage_laid_off,
  `date`, stage, country, funds_raised_millions) AS row_num
FROM copy)
SELECT * FROM duplicate_cte
WHERE row_num > 1 ;

CREATE TABLE second_copy
(`company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date DEFAULT NULL,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO second_copy
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry,
  total_laid_off, percentage_laid_off,
  `date` , stage, country, funds_raised_millions) AS row_num
  FROM copy;
  
  DELETE 
  FROM second_copy
  WHERE row_num > 1;
  
  
-- data standardization

UPDATE second_copy
SET company = TRIM(company);

UPDATE second_copy
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";

UPDATE second_copy
SET country = TRIM(TRAILING '.' FROM country )
WHERE country LIKE "United States%";

-- populating empty spaces

SELECT * 
FROM second_copy AS t1
JOIN second_copy AS t2
ON t1.company=t2.company
AND t1.location=t2.location
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

UPDATE second_copy
SET industry = NULL
WHERE industry = '';

UPDATE second_copy AS t1
JOIN second_copy AS t2
  ON t1.company=t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- deleting row number
 
ALTER TABLE second_copy
DROP COLUMN row_num;

select * from second_copy