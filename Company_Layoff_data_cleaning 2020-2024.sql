-- Data Cleaning

SELECT *
FROM tech_layoffs_2020_to_2024
;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null Values or blank values
-- 4. Check columns and rows

CREATE TABLE tech_layoffs_data
LIKE tech_layoffs_2020_to_2024
;

SELECT *
FROM tech_layoffs_data
;

INSERT tech_layoffs_data
SELECT*
FROM tech_layoffs_2020_to_2024
;

-- Renaming Field Table Correctly
ALTER TABLE tech_layoffs_data
RENAME COLUMN `Company_Size_before_layoffs` to `Company_Size_Before_Layoffs`,
RENAME COLUMN `Company_Size_after_layoffs` to `Company_Size_After_Layoffs`,
RENAME COLUMN `Money_Raised_in_$_mil` to `Money_Raised`,
RENAME COLUMN `lat` to `LAT`,
RENAME COLUMN `lng` to `LNG`
;

-- Remove Row Number 
ALTER TABLE tech_layoffs_data
DROP COLUMN  `Row_Number`;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Company, Laid_Off, industry, DATE_Layoffs, Money_Raised, LAT, LNG) as row_num
FROM tech_layoffs_data
;

-- 1. CTE to see duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Company, Location_HQ, Country, Continent, Laid_Off, DATE_Layoffs, Percentage, Company_Size_Before_Layoffs, Company_Size_After_layoffs, Stage, Money_Raised, `Year`, LAT, LNG) as row_num
FROM tech_layoffs_data
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM tech_layoffs_data
WHERE Company = '10x Genomics';

CREATE TABLE `tech_layoffs_data2` (
  `Company` text,
  `Location_HQ` text,
  `Country` text,
  `Continent` text,
  `Laid_Off` int DEFAULT NULL,
  `Date_Layoffs` text,
  `Percentage` double DEFAULT NULL,
  `Company_Size_Before_Layoffs` int DEFAULT NULL,
  `Company_Size_After_Layoffs` int DEFAULT NULL,
  `Industry` text,
  `Stage` text,
  `Money_Raised` text,
  `Year` int DEFAULT NULL,
  `LAT` double DEFAULT NULL,
  `LNG` double DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM tech_layoffs_data2
WHERE row_num > 1;

INSERT INTO tech_layoffs_data2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Company, Location_HQ, Country, Continent, Laid_Off, DATE_Layoffs, Percentage, Company_Size_Before_Layoffs, Company_Size_After_layoffs, Stage, Money_Raised, `Year`, LAT, LNG) as row_num
FROM tech_layoffs_data;

DELETE
FROM tech_layoffs_data2
WHERE row_num > 1;

SELECT *
FROM tech_layoffs_data2;

-- 2. Standardizing Data
SELECT company, TRIM(Company)
FROM tech_layoffs_data2;

update tech_layoffs_data2
SET company = TRIM(company);

SELECT *
FROM tech_layoffs_data2;

-- SELECT Specific Field in order
SELECT DISTINCT Continent
FROM tech_layoffs_data2
Order By 1;

-- Find the specific data
SELECT *
FROM tech_layoffs_data2
WHERE Laid_Off Like ' '
;

-- Change the Specific dtech_layoffs_data2ata 
UPDATE tech_layoffs_data2
SET Country = 'United Arab Emirates'
WHERE Country LIKE 'United Arabian Emirates%'
;

-- Change Data Type of Date_Layoffs
ALTER TABLE tech_layoffs_data2
MODIFY COLUMN `Date_Layoffs` DATE;

-- 3. Null Values
SELECT *
FROM tech_layoffs_data2
WHERE `LNG` IS NULL
OR `LNG` = ' ';


