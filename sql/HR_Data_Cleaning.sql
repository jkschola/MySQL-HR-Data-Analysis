# Creating Database named Projects 
DROP  DATABASE IF EXISTS Projects ;

CREATE DATABASE Projects; 

# Import HR data from a CSV file using Table Data Import wizard
/* 	- Expand "Projects" DB
	- Right clic on "Tables" then select "Table Data Import Wizard"
	- Browser the File Path
    - Renamed Table to "HR"
*/

USE Projects; 

SELECT * FROM HR;

# Rename ï»¿id column to emp_id

ALTER TABLE HR
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) ;

# Check data types of all columns

DESCRIBE HR;

# CHANGE & FORMAT dates values

/* In this dataset we have 3 columns containing dates values : 
	- birthdate		Formated as 06-29-1984 (%m-%d-%Y) and 6/29/1984 (%m/%d/%Y)
    - hire_date		Formated as birthdate
    - termdate		Formated as 2018-07-01 03:10:13 UTC (%Y-%m-%d %h:%i:%s UTC) : date time
We will use CASE statement with :
	STR_TO_DATE() to convert dates text (string) values to date data type formated as MySQL standard date format (%Y-%m-%d)
You can use :
	DATE_FORMAT() to change date format from MySQL standard date format (%Y-%m-%d) to your specific format (eg : %d-%m-%Y)
*/
/*
# Testing formats before UPDATING
SELECT STR_TO_DATE('21, 07, 2023', '%d, %m, %Y') AS New_form;							-- Output : '2023-07-21'
SELECT STR_TO_DATE('6/29/1984', '%m/%d/%Y') AS New_form;								-- Output : '1984-06-29'
SELECT STR_TO_DATE('06-29-1984', '%m-%d-%Y') AS New_form; 								-- Output : '1984-06-29'
SELECT STR_TO_DATE('06-29-84', '%m-%d-%Y') AS New_form;									-- Output : '1984-06-29'
SELECT STR_TO_DATE('2018-07-01 15:10:13 UTC', '%Y-%m-%d %H:%i:%s UTC') AS New_form ;	-- Output : '2018-07-01 15:10:13'
SELECT STR_TO_DATE('2018-07-01 15:10:13 UTC', '%Y-%m-%d %H:%i:%s') AS New_form ;		-- Output : '2018-07-01 15:10:13'
SELECT STR_TO_DATE('2018-07-01 15:10:13 UTC', '%Y-%m-%d') AS New_form ;					-- Output : '2018-07-01'
SELECT STR_TO_DATE('', '%Y-%m-%d') AS New_form ;										-- Output : NULL
*/

# birthdate 

UPDATE HR 
SET 
    birthdate = CASE
        WHEN birthdate LIKE '%/%' THEN STR_TO_DATE(birthdate, '%m/%d/%Y')
        WHEN birthdate LIKE '%-%' THEN STR_TO_DATE(birthdate, '%m-%d-%Y')
        ELSE NULL
    END;

# hire_date

UPDATE HR 
SET 
    hire_date = CASE
        WHEN hire_date LIKE '%/%' THEN STR_TO_DATE(hire_date, '%m/%d/%Y')
        WHEN hire_date LIKE '%-%' THEN STR_TO_DATE(hire_date, '%m-%d-%Y')
        ELSE NULL
    END;

SELECT * FROM HR; 

# termdate

UPDATE HR 
SET 
    termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE
    termdate IS NOT NULL AND termdate != '';

SELECT @@autocommit ; -- check the state of autocommit '0' = OFF; '1' = ON : ROLLBACK can't work iff ON


# CONVERT dates values (text) to DATE data type

ALTER TABLE HR
MODIFY COLUMN birthdate DATE ;

ALTER TABLE HR
MODIFY COLUMN hire_date DATE ;

ALTER TABLE HR
MODIFY COLUMN termdate DATE ; 
/* With this query, I faced this Error : (Incorrect date value: '' for column 'termdate')
To resolve this, update empty string to 'NULL' then ALTER Table again
*/
UPDATE HR 
SET 
    termdate = NULL
WHERE
    termdate = '';

ALTER TABLE HR
MODIFY COLUMN termdate DATE ;

SELECT * FROM HR;  

# ADD Age Column

-- Add a new column named "Age" to the "HR" table
ALTER TABLE HR
ADD COLUMN Age INT;

-- Update the "Age" column with the calculated ages
UPDATE HR 
SET 
    Age = TIMESTAMPDIFF(YEAR,
        birthdate,
        CURDATE());

SELECT emp_id, first_name, last_name, birthdate, Age
FROM HR
WHERE Age < 0;

/* 
There are 967 records with Age < 0.
After investigating the dataset, rows with Age < 0, have birthdate like '2066-01-07' maybe instead of '1966-01-07'
Based on the information provided by the Business Domain Experts, We can either :

	-- EXCLUDE those negative values :
		CREATE TABLE HR_Positive_Age AS SELECT * FROM
			HR
		WHERE
			AGE >= 0;
            
    -- Data IMPUTATION : Replace negative ages by NULL or default value :
		UPDATE HR 
		SET 
			Age = CASE
				WHEN Age >= 0 THEN Age
				ELSE NULL
			END;
            
	-- Update birthdate where Age < 0  from '2066-01-07' to '1966-01-07':
	UPDATE HR 
	SET 
		birthdate = DATE_ADD(birthdate, INTERVAL - 100 YEAR)
	WHERE
		Age < 0;

	-- Then Recalculate Age :
	UPDATE HR 
	SET 
		Age = TIMESTAMPDIFF(YEAR,
			birthdate,
			CURDATE());
*/

SELECT 
    MIN(Age) AS Youngest, MAX(Age) AS Oldest
FROM
    HR
WHERE
    Age > 0;
    
SELECT 
    COUNT(*)
FROM
    HR
WHERE
    Age > 0 AND Age < 18;


SELECT 
    *
FROM
    HR
WHERE
    termdate > CURDATE();

/* 
There are 1533 records with termdate > CURDATE(),
Maybe their contract will end in the future or there is some error in data entry


*/

-- Identify Current Employees (19818)
SELECT 
    *
FROM
    HR
WHERE
    termdate > CURDATE() OR termdate IS NULL;


-- Termination Trends Over Time (Including Future Terminations)
SELECT 
    YEAR(termdate) AS Termination_Year,
    COUNT(*) AS Termination_Count
FROM
    HR
WHERE
    termdate IS NOT NULL
GROUP BY YEAR(termdate)
ORDER BY Termination_Year;

-- Termination Trends Over Time (Future Terminations)
SELECT 
    YEAR(termdate) AS Termination_Year,
    COUNT(*) AS Termination_Count
FROM
    HR
WHERE
    (termdate > CURDATE())
GROUP BY YEAR(termdate)
ORDER BY Termination_Year;

-- Retention Analysis (Tenure in Years, Rounded to Integer)
SELECT 
    emp_id,
    ROUND(DATEDIFF(IFNULL(termdate, CURDATE()), hire_date) / 365) AS Tenure_Years
FROM
    HR;

-- Average Tenure in Years
SELECT 
    ROUND(AVG((DATEDIFF(IFNULL(termdate, CURDATE()), hire_date) / 365))) AS Average_Tenure_Years
FROM
    HR;



/*
-- Employee Turnover Rate:
SELECT 
    (COUNT(*) / (SELECT 
            COUNT(*)
        FROM
            HR)) * 100 AS Turnover_Rate
FROM
    HR
WHERE
    termdate IS NOT NULL OR termdate IS NULL;
*/


-- Number of Current Employees Over Years
-- Number of Current Employees Over Previous Years
-- Number of Current Employees Over Years
-- Count of Employees for a Specific Year
-- Count of Employees Over Multiple Years

-- Hiring Trends Over Time:
SELECT 
    YEAR(hire_date) AS Hire_Year, COUNT(*) AS Hires_Count
FROM
    HR
GROUP BY Hire_Year
ORDER BY Hire_Year;

-- Most Common Hiring Months:
SELECT 
    MONTHNAME(hire_date) AS Hire_Month, COUNT(*) AS Hires_Count
FROM
    HR
GROUP BY Hire_Month
ORDER BY Hires_Count DESC;

SELECT DISTINCT
    department
FROM
    HR;


