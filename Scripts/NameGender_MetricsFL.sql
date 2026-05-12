SELECT * FROM Clean_Freelancers --Main Table

CREATE VIEW	Freelancer_Analysis AS (
	SELECT
	Name,
	Gender,
	Age,
	Country,
	Language,
	Primary_Skill,
	Years_of_Experience,
	Hourly_Rate_USD,
	Rating,
	Active,
	Client_Satisfaction
	FROM Clean_Freelancers
) --Creative view to hide FreelancerID, seemed unnecessary


SELECT *
FROM Freelancer_Analysis --Checking view

SELECT 
Gender, 
COUNT(Gender) Gender_Count,
CAST(
	ROUND(COUNT(Gender) * 100.0 / SUM(COUNT(Gender)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Gender_Percentage
FROM Freelancer_Analysis
GROUP BY Gender --Checking the male to female ratio of the dataset

SELECT 
*
FROM Freelancer_Analysis
WHERE Name LIKE '%mr%'
OR Name LIKE '%ms.%'
OR Name LIKE '%mrs.%' --Checking the married freelancers


SELECT 
CAST(
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Freelancer_Analysis)
    AS DECIMAL(5,2)) AS Percentage_with_Honorifics
FROM Freelancer_Analysis
WHERE Name LIKE 'Mr.%'
   OR Name LIKE 'Ms.%'
   OR Name LIKE 'Mrs.%';--Checking the amount of married freelancers


SELECT 
*
FROM Freelancer_Analysis
WHERE Name LIKE '%dr.%'
OR Name LIKE '%md%' --Checking the people with doctorates

SELECT 
CAST(
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Freelancer_Analysis)
    AS DECIMAL(5,2)) AS Percentage_with_Honorifics
FROM Freelancer_Analysis
WHERE Name LIKE '%dr.%' 
	OR Name LIKE '%md%'
	OR Name LIKE '%DDS%'
	OR Name LIKE '%DVM%' --Checking the amount of freelancers with doctorates

----//----


SELECT *
FROM (
	SELECT 
	Primary_Skill,
	Gender
FROM Freelancer_Analysis
) AS GenderGroup
PIVOT(
	COUNT(Gender)
	FOR Gender IN ([F], [M])
) AS PivotGender
ORDER BY Primary_Skill --Checking the amount of Females and Males populating each different type of primary Skill
						--Using static pivot table


--Building a dynamic pivot table

DECLARE @colu NVARCHAR(MAX);
DECLARE @gend NVARCHAR(MAX);

--Step 1: dynamic column

SELECT @colu = STRING_AGG(QUOTENAME(Gender), ',')
FROM (SELECT DISTINCT Gender FROM Freelancer_Analysis) AS g;

--Step 2: pivot query

SET @gend = '
SELECT *
FROM (
	SELECT 
	Primary_Skill,
	Gender
	FROM Freelancer_Analysis
) AS GenderGroup
PIVOT(
	COUNT(Gender)
	FOR Gender IN (' + @colu + ')
) AS PivotGender
ORDER BY Primary_Skill
'
;

--Step 3: Execute

EXEC sp_executesql @gend --Same as above, but with Dynamic pivot table