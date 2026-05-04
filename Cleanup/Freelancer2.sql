SELECT * FROM [global_freelancers_raw]

CREATE TABLE [Skills] (
FreelancerID VARCHAR(max),
Age FLOAT,
Country VARCHAR(max),
Language VARCHAR(max),
Primary_Skill VARCHAR(max),
Years_of_Experience FLOAT
)

INSERT INTO [Skills](FreelancerID) 
SELECT freelancer_ID 
FROM [global_freelancers_raw] --Populating table with raw data

UPDATE c
SET c.Age = gfr.age,
c.Country = gfr.country,
c.Language = gfr.language,
c.Primary_Skill = gfr.primary_Skill,
c.Years_of_Experience = gfr.years_of_experience
FROM [Skills] c
left join [global_freelancers_raw] gfr
ON c.FreelancerID = gfr.freelancer_ID --Joining into new table first


ALTER TABLE Skills
ALTER COLUMN Age INT

ALTER TABLE Skills
ALTER COLUMN Years_of_Experience INT --Altering column types for more appropriate values after join


UPDATE Skills
SET Age = COALESCE(Age, (18 + Years_of_Experience))
WHERE Age is null -- filling in null and blank values with the minimum possible values, in this case being 18 as is the legal age eligible for work

UPDATE skills 
SET Years_of_Experience = '99'
WHERE years_of_Experience is null -- filling null values with proper values for future data collection and correction