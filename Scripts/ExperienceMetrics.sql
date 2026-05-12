SELECT * 
FROM Clean_Freelancers --Main Table

SELECT *
FROM Freelancer_Analysis --Checking view


SELECT
Primary_Skill,
MAX(Years_of_Experience) Highest_Exp,
MIN(Years_of_Experience) Lowest_Exp,
MAX(Years_of_Experience) - MIN(Years_of_Experience) Difference_Exp,
ROUND(AVG(Years_of_Experience), 2) Avg_Exp,
COUNT(Years_of_Experience) All_Exp,
SUM(Years_of_Experience) AS Sum_of_Exp,
CAST(
	ROUND(SUM(Years_of_Experience) * 100.0 / SUM(SUM(Years_of_Experience)) OVER (),2) 
	AS DECIMAL (5,2)) AS Percentage_of_Total
FROM Freelancer_Analysis
WHERE Years_of_Experience != 99
GROUP BY Primary_Skill

--Finding the maximum and minimum years of experience populating each profession
--As well as the percentage of recorded years, average, sum, and their difference



WITH ExpRanked AS (
    SELECT
        Name,
		Primary_Skill,
		Years_of_Experience,
        ROW_NUMBER() OVER (PARTITION BY Primary_Skill ORDER BY Years_of_Experience DESC) AS Exp_top,
        ROW_NUMBER() OVER (PARTITION BY Primary_Skill ORDER BY Years_of_Experience ASC)  AS Exp_bottom
    FROM Freelancer_Analysis
	WHERE Years_of_Experience != 99
)
SELECT *
FROM ExpRanked
WHERE Exp_top <= 5 OR Exp_bottom <= 5 --Checking the top and bottom 5 years of experience recorded on the dataset



SELECT
TOP 5 Years_of_Experience,
Name,
Primary_Skill,
Hourly_Rate_USD
FROM Freelancer_Analysis
WHERE Years_of_Experience != 99
ORDER BY Years_of_Experience DESC

SELECT
TOP 5 Years_of_Experience,
Name,
Primary_Skill,
Hourly_Rate_USD
FROM Freelancer_Analysis
WHERE Years_of_Experience != 99
ORDER BY Years_of_Experience ASC --Checking the top and bottom 5 employees with the highest and lowest years of experience
								--As well as their respective profession and hourly rates


