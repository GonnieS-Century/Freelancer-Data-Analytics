SELECT * FROM [global_freelancers_raw]

CREATE TABLE [Satisfaction](
FreelancerID VARCHAR(max),
Hourly_Rate_USD VARCHAR(max),
Rating DECIMAL (5,2),
Active BIT, 
Client_Satisfaction VARCHAR(max)
)

SELECT * FROM Satisfaction

INSERT INTO [Satisfaction](FreelancerID) 
SELECT freelancer_ID 
FROM [global_freelancers_raw] --Populating table with raw data

UPDATE c
SET c.Hourly_Rate_USD = gfr.hourly_rate_USD,
c.Rating = gfr.rating,
c.Active = gfr.is_active,
c.Client_Satisfaction = gfr.client_satisfaction
FROM [Satisfaction] c
left join [global_freelancers_raw] gfr
ON c.FreelancerID = gfr.freelancer_ID --Joining into new table



UPDATE Satisfaction
SET Hourly_Rate_USD = REPLACE(REPLACE(REPLACE(Hourly_Rate_USD, 'USD', ''), '$', ''), ' ', ''); 


UPDATE Satisfaction
SET client_Satisfaction = REPLACE(client_Satisfaction, '%', '')

-- removing the USD and $ characters in order to turn the hourly rate and client satisfaction columns into an integer

UPDATE Satisfaction
SET active = 'N'
WHERE Active = '0'

UPDATE Satisfaction
SET active = 'Y'
WHERE Active = '1' -- replacing the boolian values with Y and N for better reading comprehension

ALTER TABLE Satisfaction
ALTER COLUMN Active VARCHAR(max)

ALTER TABLE Satisfaction
ALTER COLUMN Hourly_Rate_USD int

ALTER TABLE Satisfaction
ALTER COLUMN Client_Satisfaction int --Altering column types to more appropriate values



UPDATE Satisfaction
SET hourly_Rate_USD = '00'
WHERE hourly_Rate_USD is null

UPDATE Satisfaction
SET Rating = '9.99'
WHERE Rating is null

UPDATE Satisfaction
SET Active = 'NA'
WHERE Active is null

UPDATE Satisfaction
SET Client_Satisfaction = '00'
WHERE Client_Satisfaction is null

-- replacing the null values with the proper template values, to fill in the future once more data is collected

