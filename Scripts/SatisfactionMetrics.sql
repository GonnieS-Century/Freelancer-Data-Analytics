SELECT * 
FROM Clean_Freelancers --Main Table

SELECT *
FROM Freelancer_Analysis --Checking view

SELECT
Primary_Skill,
MAX(Client_Satisfaction) Highest_Rating,
MIN(Client_Satisfaction) Lowest_Rating,
MAX(Client_Satisfaction) - MIN(Client_Satisfaction) Difference_Rating,
AVG(Client_Satisfaction) Avg_Rating,
COUNT(Client_Satisfaction) Count_Ratings,
CAST(
	ROUND(COUNT(Client_Satisfaction) * 100.0 / SUM(COUNT(Client_Satisfaction)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Count
FROM Freelancer_Analysis
WHERE Client_Satisfaction != 0
GROUP BY Primary_Skill --Checking the maximum and minimum client satisfaction recorded
						--As well as their difference, average, count, and percentage


WITH SatisfactionRanked AS (
    SELECT
        Name,
		Primary_Skill,
		Client_Satisfaction,
        ROW_NUMBER() OVER (ORDER BY Client_Satisfaction DESC) AS Satisfaction_top,
        ROW_NUMBER() OVER (ORDER BY Client_Satisfaction ASC)  AS Satisfaction_bottom
    FROM Freelancer_Analysis
	WHERE Client_Satisfaction != 0
)
SELECT *
FROM SatisfactionRanked
WHERE Satisfaction_top <= 5 OR Satisfaction_bottom <= 5 --Checking the top five and bottom five client satisfaction ratings
														--And the names and professions associated


----//----

DECLARE @cols NVARCHAR(MAX);
DECLARE @sat  NVARCHAR(MAX);

-- Step 1: Build column list dynamically
SELECT @cols = STRING_AGG(QUOTENAME(Primary_Skill), ',')
FROM (SELECT DISTINCT Primary_Skill FROM Freelancer_Analysis) AS cs;

-- Step 2: Build the pivot query
SET @sat = '
SELECT *
FROM (
    SELECT 
	Primary_Skill, 
	Client_Satisfaction
    FROM Freelancer_Analysis
	WHERE Client_Satisfaction != 0
) AS SatSource
PIVOT (
    AVG(Client_Satisfaction)
    FOR Primary_Skill IN (' + @cols + ')
) AS PivotSat

';

-- Step 3: Execute it
EXEC sp_executesql @sat; --Using a dynamic table to calculate the average client satisfaction of each profession