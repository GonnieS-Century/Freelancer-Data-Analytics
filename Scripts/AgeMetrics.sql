SELECT * 
FROM Clean_Freelancers --Main Table

SELECT *
FROM Freelancer_Analysis --Checking view

SELECT 
DISTINCT AGE
FROM Freelancer_Analysis
WHERE AGE != 0 --Checking the different amount of ages that exist, without duplicates

----//----

SELECT 
	Active,
    SUM(CASE WHEN Age BETWEEN '18' AND '27' THEN 1 ELSE 0 END) AS PreAdult,
    SUM(CASE WHEN Age BETWEEN '28' AND '37' THEN 1 ELSE 0 END) AS Adult,
    SUM(CASE WHEN Age BETWEEN '38' AND '47' THEN 1 ELSE 0 END) AS MiddleAged,
    SUM(CASE WHEN Age BETWEEN '48' AND '57' THEN 1 ELSE 0 END) AS NearRetiree,
	SUM(CASE WHEN Age >= '58' THEN 1 ELSE 0 END) AS Retiree
FROM Freelancer_Analysis
WHERE Age != 0
GROUP BY Active --Checking the age distribution across all rows, based on their active status


SELECT *
FROM  (
SELECT 
	Active,
    CASE
	WHEN Age BETWEEN '18' AND '27' THEN 'PreAdult'
    WHEN Age BETWEEN '28' AND '37' THEN 'Adult'
    WHEN Age BETWEEN '38' AND '47' THEN 'MiddleAged'
    WHEN Age BETWEEN '48' AND '57' THEN 'NearRetiree'
	WHEN Age >= '58' THEN 'Retiree'
	END AS AgeGroup
FROM Freelancer_Analysis
WHERE Age != 0
) AS Age_Group
PIVOT (
	COUNT(AgeGroup)
	FOR AgeGroup IN ([PreAdult], [Adult], [MiddleAged], [NearRetiree], [Retiree])
) AS PivotTable 
ORDER BY Active --Same as the operation above, but with Static Pivot table
				-- Not advisable to use dynamic pivot table for this operation

----//----

SELECT 
	Primary_Skill,
    SUM(CASE WHEN Age BETWEEN '18' AND '27' THEN 1 ELSE 0 END) AS PreAdult,
    SUM(CASE WHEN Age BETWEEN '28' AND '37' THEN 1 ELSE 0 END) AS Adult,
    SUM(CASE WHEN Age BETWEEN '38' AND '47' THEN 1 ELSE 0 END) AS MiddleAged,
    SUM(CASE WHEN Age BETWEEN '48' AND '57' THEN 1 ELSE 0 END) AS NearRetiree,
	SUM(CASE WHEN Age >= '58' THEN 1 ELSE 0 END) AS Retiree
FROM Freelancer_Analysis
WHERE Age != 0
GROUP BY Primary_Skill --Checking the age distribution across all rows, based on their primary skills


SELECT *
FROM  (
SELECT 
	Primary_Skill,
    CASE
	WHEN Age BETWEEN '18' AND '27' THEN 'PreAdult'
    WHEN Age BETWEEN '28' AND '37' THEN 'Adult'
    WHEN Age BETWEEN '38' AND '47' THEN 'MiddleAged'
    WHEN Age BETWEEN '48' AND '57' THEN 'NearRetiree'
	WHEN Age >= '58' THEN 'Retiree'
	END AS AgeGroup
FROM Freelancer_Analysis
WHERE Age != 0
) AS Age_Group
PIVOT (
	COUNT(AgeGroup)
	FOR AgeGroup IN ([PreAdult], [Adult], [MiddleAged], [NearRetiree], [Retiree])
) AS PivotTable 
ORDER BY Primary_Skill --Same as the operation above, but with Static Pivot table
						-- Not advisable to use dynamic pivot table for this operation

----//----

SELECT 
	Hourly_Rate_USD,
    SUM(CASE WHEN Age BETWEEN '18' AND '27' THEN 1 ELSE 0 END) AS PreAdult,
    SUM(CASE WHEN Age BETWEEN '28' AND '37' THEN 1 ELSE 0 END) AS Adult,
    SUM(CASE WHEN Age BETWEEN '38' AND '47' THEN 1 ELSE 0 END) AS MiddleAged,
    SUM(CASE WHEN Age BETWEEN '48' AND '57' THEN 1 ELSE 0 END) AS NearRetiree,
	SUM(CASE WHEN Age >= '58' THEN 1 ELSE 0 END) AS Retiree
FROM Freelancer_Analysis
WHERE Hourly_Rate_USD != 0
GROUP BY Hourly_Rate_USD --Checking the age distribution across all rows, based on their hourly rates


SELECT *
FROM  (
SELECT 
	Hourly_Rate_USD,
    CASE
	WHEN Age BETWEEN '18' AND '27' THEN 'PreAdult'
    WHEN Age BETWEEN '28' AND '37' THEN 'Adult'
    WHEN Age BETWEEN '38' AND '47' THEN 'MiddleAged'
    WHEN Age BETWEEN '48' AND '57' THEN 'NearRetiree'
	WHEN Age >= '58' THEN 'Retiree'
	END AS AgeGroup
FROM Freelancer_Analysis
WHERE Hourly_Rate_USD != 0
) AS Age_Group
PIVOT (
	COUNT(AgeGroup)
	FOR AgeGroup IN ([PreAdult], [Adult], [MiddleAged], [NearRetiree], [Retiree])
) AS PivotTable 
ORDER BY Hourly_Rate_USD --Same as the operation above, but with Static Pivot table
						-- Not advisable to use dynamic pivot table for this operation


----//----

SELECT
Primary_Skill,
MAX(Age) Highest_Age,
MIN(Age) Lowest_Age,
MAX(Age) - MIN(Age) Difference_Age,
ROUND(AVG(Age), 2) Avg_Age
FROM Freelancer_Analysis
WHERE Age != 0
GROUP BY Primary_Skill --Checking the highest, lowest, average and difference of ages in the dataset
						--In relation to the professions