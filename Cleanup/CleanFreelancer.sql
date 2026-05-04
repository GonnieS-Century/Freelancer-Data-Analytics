SELECT * FROM [global_freelancers_raw]

CREATE TABLE [Clean_Freelancers](
FreelancerID VARCHAR(MAX),
Name VARCHAR(MAX),
Gender VARCHAR(MAX),
Age INT,
Country VARCHAR(MAX),
Language VARCHAR(MAX),
Primary_Skill VARCHAR(MAX),
Years_of_Experience INT,
Hourly_Rate_USD INT,
Rating DECIMAL (5,2),
Active VARCHAR(MAX), 
Client_Satisfaction INT
)

SELECT * FROM Clean_Freelancers

INSERT INTO [Clean_Freelancers](FreelancerID) 
SELECT freelancerID 
FROM [gender_type] --Populating table with raw data

UPDATE c
SET c.Name = gt.name,
c.Gender = gt.gender
FROM [Clean_Freelancers] c
left join [gender_type] gt
ON c.FreelancerID = gt.freelancerID

UPDATE c
SET c.Age = s.age,
c.Country = s.country,
c.Language = s.language,
c.Primary_Skill = s.primary_Skill,
c.Years_of_Experience = s.years_of_experience
FROM [Clean_Freelancers] c
left join [Skills] s
ON c.FreelancerID = s.freelancerID

UPDATE c
SET c.Hourly_Rate_USD = sat.hourly_rate_USD,
c.Rating = sat.rating,
c.Active = sat.active,
c.Client_Satisfaction = sat.client_satisfaction
FROM [Clean_Freelancers] c
left join [Satisfaction] sat
ON c.FreelancerID = sat.freelancerID --Joining all the tables into one