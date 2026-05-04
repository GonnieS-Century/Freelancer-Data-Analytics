CREATE DATABASE [Project3]

SELECT * FROM [global_freelancers_raw]

CREATE TABLE [gender_type](
FreelancerID VARCHAR(max),
Name VARCHAR(max),
Gender VARCHAR(max)
)

SELECT * FROM [gender_type]

INSERT INTO [gender_type](FreelancerID) 
SELECT freelancer_ID 
FROM [global_freelancers_raw] --Populating table with raw data

UPDATE c
SET c.Name = gfr.name,
c.Gender = gfr.gender
FROM [gender_type] c
left join [global_freelancers_raw] gfr
ON c.FreelancerID = gfr.freelancer_ID --Joining into new table


UPDATE [gender_type]
SET Gender = 'F'
WHERE Gender like 'F%'

UPDATE [gender_type]
SET Gender = 'M'
WHERE Gender like 'M%' -- replacing values in gender column with just F and M


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'global_freelancers_raw'

-- For viewing the datatype of each column of the original data