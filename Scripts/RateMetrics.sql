SELECT * 
FROM Clean_Freelancers --Main Table

SELECT *
FROM Freelancer_Analysis --Checking view


SELECT
Hourly_Rate_USD,
ROUND(AVG(Hourly_Rate_USD), 2) Avg_Rate,
COUNT(Hourly_Rate_USD) All_Rate,
SUM(Hourly_Rate_USD) AS Sum_of_Rate,
CAST(
	ROUND(SUM(Hourly_Rate_USD) * 100.0 / SUM(SUM(Hourly_Rate_USD)) OVER (),2) 
	AS DECIMAL (5,2)) AS Percentage_of_Total,
CAST(
	ROUND(COUNT(Hourly_Rate_USD) * 100.0 / SUM(COUNT(Hourly_Rate_USD)) OVER (),2) 
	AS DECIMAL (5,2)) AS Percentage_of_Count
FROM Freelancer_Analysis
WHERE Hourly_Rate_USD != 0
GROUP BY Hourly_Rate_USD 

--Finding all of the hourly rates populated, without the null values (0)
--As well as the percentage of recorded rates, average, sum, and count of records


SELECT
MAX(Hourly_Rate_USD) Highest_Rate,
MIN(Hourly_Rate_USD) Lowest_Rate,
MAX(Hourly_Rate_USD) - MIN(Hourly_Rate_USD) Difference_Rate
FROM Freelancer_Analysis
WHERE Hourly_Rate_USD != 0 --Checking the highest and lowest rates, and their difference

----//----

WITH RateData AS (
	SELECT
	Hourly_Rate_USD,
	ROUND(AVG(Hourly_Rate_USD), 2) Avg_Rate,
	COUNT(Hourly_Rate_USD) All_Rate,
	SUM(Hourly_Rate_USD) AS Sum_of_Rate,
	CAST(
		ROUND(SUM(Hourly_Rate_USD) * 100.0 / SUM(SUM(Hourly_Rate_USD)) OVER (),2) 
		AS DECIMAL (5,2)) AS Percentage_of_Total,
	CAST(
		ROUND(COUNT(Hourly_Rate_USD) * 100.0 / SUM(COUNT(Hourly_Rate_USD)) OVER (),2) 
		AS DECIMAL (5,2)) AS Percentage_of_Count
	FROM Freelancer_Analysis
	WHERE Hourly_Rate_USD != 0
	GROUP BY Hourly_Rate_USD 
),
SummaryData AS(
	SELECT
	MAX(Hourly_Rate_USD) Highest_Rate,
	MIN(Hourly_Rate_USD) Lowest_Rate,
	MAX(Hourly_Rate_USD) - MIN(Hourly_Rate_USD) Difference_Rate
	FROM Freelancer_Analysis
	WHERE Hourly_Rate_USD != 0
)

SELECT
s.*,
r.*
FROM RateData r
CROSS JOIN SummaryData s
ORDER BY r.Hourly_Rate_USD --Using CTE and Cross join to join the two tables above into one

----//----

DECLARE @colu NVARCHAR(MAX);
DECLARE @rate NVARCHAR(MAX);

--Step 1: dynamic column

SELECT @colu = STRING_AGG(QUOTENAME(Hourly_Rate_Usd), ',')
FROM (SELECT DISTINCT Hourly_Rate_USD FROM Freelancer_Analysis) AS hr;

--Step 2: pivot query

SET @rate = '
SELECT *
FROM (
	SELECT 
	Name,
	Hourly_Rate_USD
	FROM Freelancer_Analysis
) AS RateGroup
PIVOT(
	COUNT(Hourly_Rate_USD)
	FOR Hourly_Rate_USD IN (' + @colu + ')
) AS PivotLanguage
ORDER BY Name
'
;

--Step 3: Execute

EXEC sp_executesql @rate --Registering the rates from each employee in a dynamic pivot table

----//----

WITH RateRanked AS (
    SELECT
        Name,
		Hourly_Rate_USD,
        ROW_NUMBER() OVER (ORDER BY Hourly_Rate_USD DESC) AS Rate_top,
        ROW_NUMBER() OVER (ORDER BY Hourly_Rate_USD ASC)  AS Rate_bottom
    FROM Freelancer_Analysis
	WHERE Hourly_Rate_USD != 0
)
SELECT *
FROM RateRanked
WHERE Rate_top <= 5 OR Rate_bottom <= 5 --Checking the top and bottom 5 employees with highest/lowest rates



WITH RateSkilled AS (
    SELECT
        Name,
		Primary_Skill,
		Hourly_Rate_USD,
        ROW_NUMBER() OVER (PARTITION BY Primary_Skill ORDER BY Hourly_Rate_USD DESC) AS Rate_top,
        ROW_NUMBER() OVER (PARTITION BY Primary_Skill ORDER BY Hourly_Rate_USD ASC)  AS Rate_bottom
    FROM Freelancer_Analysis
	WHERE Hourly_Rate_USD != 0
)
SELECT *
FROM RateSkilled
WHERE Rate_top <= 5 OR Rate_bottom <= 5 --Same as above, but for each profession