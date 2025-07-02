-- EDA Tech_Layoffs_data

SELECT *
FROM tech_layoffs_data2;

SELECT MAX(tech_layoffs_data2), MIN(tech_layoffs_data2)
FROM tech_layoffs_data2;

-- Percentage of Laid Off
SELECT *
FROM tech_layoffs_data2
WHERE Percentage = 1
ORDER BY Laid_off DESC;

-- Sum of Total Laid off through out the years
SELECT Company, SUM(Laid_off)
FROM tech_layoffs_data2
GROUP BY Company
ORDER BY 2 DESC; 

-- SEE where layoffs started
SELECT MIN(`Date_Layoffs`), MAX(`Date_Layoffs`)
FROM tech_layoffs_data2;

-- SEE what industry, country, etc has the most laid off
SELECT Country, SUM(Laid_off)
FROM tech_layoffs_data2
GROUP BY Country
Order By 2 DESC;

-- SEE how many laid off in year, and per date
SELECT `Date_Layoffs`, SUM(Laid_off)
FROM tech_layoffs_data2
GROUP BY `Date_Layoffs`
Order By 1 DESC;

SELECT `Year`, SUM(Laid_off)
FROM tech_layoffs_data2
GROUP BY `Year`
Order By 1 DESC;

-- AVG Laid off by companies
SELECT Company, AVG(Laid_off)
FROM tech_layoffs_data2
GROUP BY Company
Order By 1 DESC;

-- See how many laid off per month
SELECT SUBSTRING(`Date_layoffs`,1,7) AS `MONTH`, SUM(Laid_Off)
FROM tech_layoffs_data2
WHERE SUBSTRING(`Date_layoffs`,1,7) IS NOT NULL 
GROUP BY `MONTH` 
ORDER BY 1 ASC;

-- Summing Laid Off month by month
WITH TOTAL_SUM AS (
    SELECT 
        SUBSTRING(`Date_layoffs`, 1, 7) AS `MONTH`, 
        SUM(Laid_Off) AS `Laid_Off`
    FROM tech_layoffs_data2
    WHERE SUBSTRING(`Date_layoffs`, 1, 7) IS NOT NULL 
    GROUP BY `MONTH`
)
SELECT `MONTH`, `Laid_Off`,
SUM(`Laid_Off`) OVER (ORDER BY `MONTH`) AS `Total_sum`
FROM TOTAL_SUM;

-- View Companies laid off per day
SELECT company, `Date_Layoffs`, SUM(Laid_off)
FROM tech_layoffs_data2
GROUP BY company, `Date_Layoffs`
Order By company ASC;

-- CTE top 5 company laid off per year
WITH Company_Year (Company, `Year`, Total_laid_off) AS
(
SELECT company, YEAR(`Date_Layoffs`), SUM(Laid_off)
FROM tech_layoffs_data2
GROUP BY company, YEAR(`Date_Layoffs`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK () OVER (PARTITION BY `Year` ORDER BY Total_laid_off DESC) AS Ranking
FROM Company_Year
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;


