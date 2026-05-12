SELECT * 
FROM Clean_Freelancers --Main Table

SELECT *
FROM Freelancer_Analysis --Checking view


SELECT 
	DISTINCT Country
FROM Freelancer_Analysis

SELECT 
	DISTINCT Language
FROM Freelancer_Analysis


SELECT 
Language, 
COUNT(Country) CountryCount,
CAST(
	ROUND(COUNT(Country) * 100.0 / SUM(COUNT(Country)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM Freelancer_Analysis
GROUP BY Language --Checking the amount of countries populating the dataset
				--Based on the distinct languages


SELECT 
Country, 
COUNT(Language) LanguageCount,
CAST(
	ROUND(COUNT(Language) * 100.0 / SUM(COUNT(Language)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM Freelancer_Analysis
GROUP BY Country --Same as above, but with countries and languages reversed

----//----

SELECT 
    Language,
    COUNT(DISTINCT Country) AS CountryCount,
    STRING_AGG(Country, ', ') AS Countries
FROM
(
	SELECT
	DISTINCT Language,
	Country
	FROM Freelancer_Analysis --The table this is pulling from is used to remove duplicates 
) t
GROUP BY Language
HAVING COUNT(DISTINCT Country) > 1; --Checking the countries with overlapping languages

----//----

WITH CountryRanked AS (
    SELECT Country,
           RANK() OVER (ORDER BY COUNT(Country) DESC) AS MostRank,
           RANK() OVER (ORDER BY COUNT(Country) ASC) AS LeastRank
    FROM Freelancer_Analysis
	GROUP BY Country
)
SELECT *
FROM CountryRanked
WHERE MostRank = 1 
	OR LeastRank = 1; --Checking the most populated countries in the dataset

WITH LanguageRanked AS (
    SELECT Language,
           RANK() OVER (ORDER BY COUNT(Language) DESC) AS MostRank,
           RANK() OVER (ORDER BY COUNT(Language) ASC) AS LeastRank
    FROM Freelancer_Analysis
	GROUP BY Language
)
SELECT *
FROM LanguageRanked
WHERE MostRank = 1 
	OR LeastRank = 1; --Checking the most populated languages in the dataset
						
----//----

DECLARE @colu NVARCHAR(MAX);
DECLARE @count NVARCHAR(MAX);

--Step 1: dynamic column

SELECT @colu = STRING_AGG(QUOTENAME(Country), ',')
FROM (SELECT DISTINCT Country FROM Freelancer_Analysis) AS c;

--Step 2: pivot query

SET @count = '
SELECT *
FROM (
	SELECT 
	Primary_Skill,
	Country
	FROM Freelancer_Analysis
) AS CountryGroup
PIVOT(
	COUNT(Country)
	FOR Country IN (' + @colu + ')
) AS PivotCountry
ORDER BY Primary_Skill
'
;

--Step 3: Execute

EXEC sp_executesql @count --Checking the records of countries with the highest concentration of each primary skill 



DECLARE @colu NVARCHAR(MAX);
DECLARE @lang NVARCHAR(MAX);

--Step 1: dynamic column

SELECT @colu = STRING_AGG(QUOTENAME(Language), ',')
FROM (SELECT DISTINCT Language FROM Freelancer_Analysis) AS l;

--Step 2: pivot query

SET @lang = '
SELECT *
FROM (
	SELECT 
	Primary_Skill,
	Language
	FROM Freelancer_Analysis
) AS LanguageGroup
PIVOT(
	COUNT(Language)
	FOR Language IN (' + @colu + ')
) AS PivotLanguage
ORDER BY Primary_Skill
'
;

--Step 3: Execute

EXEC sp_executesql @lang --Same as above, but with language records