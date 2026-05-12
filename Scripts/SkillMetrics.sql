SELECT * 
FROM Clean_Freelancers --Main Table

SELECT *
FROM Freelancer_Analysis --Checking view


SELECT
DISTINCT Primary_Skill
FROM Freelancer_Analysis --Checking the different types of professions without duplicates


SELECT
Primary_Skill,
COUNT(Primary_Skill) Skill_Count,
CAST(
	ROUND(COUNT(Primary_Skill) * 100.0 / SUM(COUNT(Primary_Skill)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM Freelancer_Analysis
GROUP BY Primary_Skill  --Checking the amount of people populating each profession, 
						--As well as their percentage



WITH SkillRanked AS (
    SELECT Primary_Skill,
           RANK() OVER (ORDER BY COUNT(Primary_Skill) DESC) AS Highest,
           RANK() OVER (ORDER BY COUNT(Primary_Skill) ASC) AS Lowest
    FROM Freelancer_Analysis
	GROUP BY Primary_Skill
)
SELECT *
FROM SkillRanked
WHERE Highest = 1 
	OR Lowest = 1; --Using CTE to check the highest and lowest populated profession


SELECT 
MAX(t.Skill_Count) Highest_Skill,
MIN(t.Skill_Count) Lowest_Skill
FROM (
	SELECT 
	COUNT(Primary_Skill) AS Skill_Count
	FROM Freelancer_Analysis x
	GROUP BY Primary_Skill
) t --Using subquery to check the values of the most and least populated professions


----//----

DECLARE @colu NVARCHAR(MAX);
DECLARE @skill NVARCHAR(MAX);

--Step 1: dynamic column

SELECT @colu = STRING_AGG(QUOTENAME(Primary_Skill), ',')
FROM (SELECT DISTINCT Primary_Skill FROM Freelancer_Analysis) AS ps;

--Step 2: pivot query

SET @skill = '
SELECT *
FROM (
	SELECT 
	Gender,
	Primary_Skill
	FROM Freelancer_Analysis
) AS SkillGroup
PIVOT(
	COUNT(Primary_Skill)
	FOR Primary_Skill IN (' + @colu + ')
) AS PivotSkill
ORDER BY Gender
'
;

--Step 3: Execute

EXEC sp_executesql @skill --Checking the ratio of men and women populating each profession
							--Using a dynamic pivot table


----//----


DECLARE @colu NVARCHAR(MAX);
DECLARE @skill NVARCHAR(MAX);

--Step 1: dynamic column

SELECT @colu = STRING_AGG(QUOTENAME(Primary_Skill), ',')
FROM (SELECT DISTINCT Primary_Skill FROM Freelancer_Analysis) AS ps;

--Step 2: pivot query

SET @skill = '
SELECT *
FROM (
	SELECT 
	Language,
	Primary_Skill
	FROM Freelancer_Analysis
) AS SkillGroup
PIVOT(
	COUNT(Primary_Skill)
	FOR Primary_Skill IN (' + @colu + ')
) AS PivotSkill
ORDER BY Language
'
;

--Step 3: Execute

EXEC sp_executesql @skill --Checking the population of different languages in relation to the professions