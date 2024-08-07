-- Creating Database named Projects
DROP DATABASE IF EXISTS Projects;
CREATE DATABASE Projects;

-- Use the Projects database
USE Projects;

-- Assuming you have imported HR data from a CSV file into a table named HR using Table Data Import wizard

-- Display all data from HR table
SELECT * FROM HR;

-- Rename ï»¿id column to emp_id
ALTER TABLE HR
CHANGE COLUMN ï»¿id emp_id VARCHAR(20);

-- Check data types of all columns
DESCRIBE HR;

-- Change & format date values
/*
In this dataset, we have 3 columns containing date values:
  - birthdate: Formatted as MM-DD-YYYY or MM/DD/YYYY
  - hire_date: Formatted as MM-DD-YYYY or MM/DD/YYYY
  - termdate: Formatted as YYYY-MM-DD HH:MM:SS UTC

We will use CASE statements with STR_TO_DATE() to convert date text values to the MySQL standard date format (YYYY-MM-DD).
*/

-- birthdate
UPDATE HR 
SET 
    birthdate = CASE
        WHEN birthdate LIKE '%/%' THEN STR_TO_DATE(birthdate, '%m/%d/%Y')
        WHEN birthdate LIKE '%-%' THEN STR_TO_DATE(birthdate, '%m-%d-%Y')
        ELSE NULL
    END;

-- hire_date
UPDATE HR 
SET 
    hire_date = CASE
        WHEN hire_date LIKE '%/%' THEN STR_TO_DATE(hire_date, '%m/%d/%Y')
        WHEN hire_date LIKE '%-%' THEN STR_TO_DATE(hire_date, '%m-%d-%Y')
        ELSE NULL
    END;

SELECT * FROM HR;

-- termdate
UPDATE HR 
SET 
    termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE
    termdate IS NOT NULL AND termdate != '';

SELECT @@autocommit; -- Check the state of autocommit ('0' = OFF; '1' = ON)

-- Convert date values (text) to DATE data type
ALTER TABLE HR
MODIFY COLUMN birthdate DATE;

ALTER TABLE HR
MODIFY COLUMN hire_date DATE;

ALTER TABLE HR
MODIFY COLUMN termdate DATE; 
-- To resolve the error: (Incorrect date value: '' for column 'termdate'), update empty strings to 'NULL'
UPDATE HR 
SET 
    termdate = NULL
WHERE
    termdate = '';

ALTER TABLE HR
MODIFY COLUMN termdate DATE;

SELECT * FROM HR;

-- Add Age column
ALTER TABLE HR
ADD COLUMN Age INT;

-- Update the Age column with the calculated ages
UPDATE HR 
SET 
    Age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

SELECT emp_id, first_name, last_name, birthdate, Age
FROM HR
WHERE Age < 0;

-- Correct negative ages
/*
There are 967 records with Age < 0.
After investigating the dataset, rows with Age < 0 have birthdates like '2066-01-07' instead of '1966-01-07'.

Based on the information provided by the Business Domain Experts, we can either:
1. Exclude those negative values.
2. Impute data: Replace negative ages with NULL or a default value.
3. Correct the birthdates by subtracting 100 years and recalculate Age.
*/

-- Option 3: Correct the birthdates and recalculate Age

UPDATE HR 
SET 
    birthdate = DATE_ADD(birthdate, INTERVAL -100 YEAR)
WHERE
    Age < 0;

UPDATE HR 
SET 
    Age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

-- Summary statistics for Age
SELECT 
    MIN(Age) AS Youngest, MAX(Age) AS Oldest
FROM HR
WHERE Age > 0;

SELECT 
    COUNT(*)
FROM HR
WHERE Age > 0 AND Age < 18;

-- Check for termdates in the future
SELECT 
    *
FROM HR
WHERE termdate > CURDATE();

/*
There are 1533 records with termdate > CURDATE.
These could indicate future terminations or data entry errors.
*/

-- Identify current employees (those with no termination date or a future termination date)
SELECT 
    *
FROM HR
WHERE termdate > CURDATE() OR termdate IS NULL;

-- Termination trends over time (including future terminations)
SELECT 
    YEAR(termdate) AS Termination_Year,
    COUNT(*) AS Termination_Count
FROM HR
WHERE termdate IS NOT NULL
GROUP BY YEAR(termdate)
ORDER BY Termination_Year;

-- Termination trends over time (future terminations)
SELECT 
    YEAR(termdate) AS Termination_Year,
    COUNT(*) AS Termination_Count
FROM HR
WHERE termdate > CURDATE()
GROUP BY YEAR(termdate)
ORDER BY Termination_Year;

-- Retention analysis (tenure in years, rounded to integer)
SELECT 
    emp_id,
    ROUND(DATEDIFF(IFNULL(termdate, CURDATE()), hire_date) / 365) AS Tenure_Years
FROM HR;

-- Average tenure in years
SELECT 
    ROUND(AVG(DATEDIFF(IFNULL(termdate, CURDATE()), hire_date) / 365)) AS Average_Tenure_Years
FROM HR;

-- Hiring trends over time
SELECT 
    YEAR(hire_date) AS Hire_Year, COUNT(*) AS Hires_Count
FROM HR
GROUP BY Hire_Year
ORDER BY Hire_Year;

-- Most common hiring months
SELECT 
    MONTHNAME(hire_date) AS Hire_Month, COUNT(*) AS Hires_Count
FROM HR
GROUP BY Hire_Month
ORDER BY Hires_Count DESC;

-- List all departments
SELECT DISTINCT
    department
FROM HR;
