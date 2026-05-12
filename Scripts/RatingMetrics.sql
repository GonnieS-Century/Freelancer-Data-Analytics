SELECT * 
FROM Clean_Freelancers --Main Table

SELECT *
FROM Freelancer_Analysis --Checking view


SELECT
Primary_Skill,
MAX(Rating) Highest_Rating,
MIN(Rating) Lowest_Rating,
MAX(Rating) - MIN(Rating) Difference_Rating,
CAST(
	AVG(Rating) 
	AS DECIMAL(5,2)
) AS Avg_Rating,
COUNT(Rating) Count_Ratings,
CAST(
	ROUND(COUNT(Rating) * 100.0 / SUM(COUNT(Rating)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Count
FROM Freelancer_Analysis
WHERE Rating != 9.99
AND Rating != 0.00
GROUP BY Primary_Skill --Checking the maximum and minimum rating among all the employees
						--As well as their difference, average, and count of all records, plus their percentage, in relation to profession
						--Without the null values, or 0 rating records



SELECT
Primary_Skill,
MAX(Rating) Highest_Rating,
MIN(Rating) Lowest_Rating,
MAX(Rating) - MIN(Rating) Difference_Rating,
CAST(
	AVG(Rating) 
	AS DECIMAL(5,2)
) AS Avg_Rating,
COUNT(Rating) Count_Ratings,
CAST(
	ROUND(COUNT(Rating) * 100.0 / SUM(COUNT(Rating)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Count
FROM Freelancer_Analysis
WHERE Rating != 9.99
GROUP BY Primary_Skill --Same as above, but with 0 ratings



WITH RatingRanked AS (
    SELECT
        Name,
		Primary_Skill,
		Rating,
        ROW_NUMBER() OVER (ORDER BY Rating DESC) AS Rating_top,
        ROW_NUMBER() OVER (ORDER BY Rating ASC)  AS Rating_bottom
    FROM Freelancer_Analysis
	WHERE Rating != 9.99
)
SELECT *
FROM RatingRanked
WHERE Rating_top <= 5 OR Rating_bottom <= 5


----//----

SELECT 
Active,
COUNT(Active),
CAST(
	ROUND(COUNT(Rating) * 100.0 / SUM(COUNT(Rating)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Count
FROM Freelancer_Analysis
GROUP BY Active --Checking the amount of active, inactive, and null valued records on the table
				--As well as the percentage


DECLARE @cols NVARCHAR(MAX);
DECLARE @act  NVARCHAR(MAX);

-- Step 1: Build column list dynamically
SELECT @cols = STRING_AGG(QUOTENAME(Active), ',')
FROM (SELECT DISTINCT Active FROM Freelancer_Analysis) AS a;

-- Step 2: Build the pivot query
SET @act = '
SELECT *
FROM (
    SELECT 
	Name, 
	Age,
	Active
    FROM Freelancer_Analysis
) AS ActSource
PIVOT (
    COUNT(Active)
    FOR Active IN (' + @cols + ')
) AS PivotAct
ORDER BY Name;
';

-- Step 3: Execute it
EXEC sp_executesql @act; --Registering the names in conjunction with their activity using a dynamic pivot table
						--The age column is added as a unique identifier to divide employees with similar names

