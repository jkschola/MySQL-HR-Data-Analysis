USE projects; 


# QUESTIONS
-- 1. What is the gender breakdown of employees in the company?

SELECT 
    gender, COUNT(*) AS Employees_Count
FROM
    HR
GROUP BY gender
ORDER BY Employees_Count DESC;

-- 2. What is the race/ethnicity breakdown of employees in the company?

SELECT 
    race, COUNT(*) AS Employees_Count
FROM
    HR
GROUP BY race
ORDER BY Employees_Count DESC;

-- 3. What is the age distribution of employees in the company?

SELECT 
    Age, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY Age
ORDER BY Employees_Count DESC;

SELECT 
    MIN(Age) AS Youngest, MAX(Age) AS Oldest
FROM
    HR
WHERE
    Age > 0;

SELECT 
    FLOOR(Age / 10) * 10 AS Age_Group, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY Age_Group
ORDER BY Age_Group ASC;

SELECT 
    CASE
        WHEN Age < 25 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS Age_Group,
    COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY Age_Group
ORDER BY Age_Group ASC;    
    
SELECT 
    CASE
        WHEN Age < 25 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS Age_Group,
    gender,
    COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY Age_Group , gender
ORDER BY Age_Group , gender;     

-- 4. How many employees work at headquarters versus remote locations?

SELECT 
    location, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY location;


-- 5. What is the average length of employment for employees who have been terminated?

SELECT 
    FLOOR(AVG(DATEDIFF(termdate, hire_date) / 365.25)) AS Avg_Tenure_Years
FROM
    HR
WHERE
    termdate IS NOT NULL
        AND termdate < CURDATE();
        
SELECT 
    FLOOR(AVG(TIMESTAMPDIFF(YEAR, hire_date, termdate))) AS Avg_Tenure_Years
FROM
    HR
WHERE
    termdate IS NOT NULL
        AND termdate < CURDATE();


-- 6. How does the gender distribution vary across departments and job titles?

SELECT 
    department, gender, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY department , gender
ORDER BY department;


SELECT 
    jobtitle, gender, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY jobtitle , gender
ORDER BY jobtitle;

-- 7. What is the distribution of job titles across the company?

SELECT 
    jobtitle, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY jobtitle
ORDER BY Employees_Count DESC;

-- 8. Which department has the highest turnover rate?

-- Identify CY Active Employees (19816)
SELECT 
    COUNT(*) AS CY_Employees
FROM
    HR
WHERE
    termdate > CURDATE() OR termdate IS NULL;
    
-- Identify LY Employees
SELECT 
    COUNT(*) AS Current_Employees
FROM
    HR
WHERE
    termdate > CURDATE() OR termdate IS NULL;

-- Identify Terminations Trends Over Time
SELECT 
    YEAR(termdate) AS Termination_Year,
    COUNT(*) AS Termination_Count
FROM
    HR
WHERE
    termdate IS NOT NULL AND termdate < CURDATE()
GROUP BY YEAR(termdate)
ORDER BY Termination_Year DESC;



-- Identify Current Employees (19816)
SELECT 
    COUNT(*) AS Current_Employees
FROM
    HR
WHERE
    YEAR(termdate) > YEAR(CURDATE()) OR termdate IS NULL;

    
-- Identify Current Employees (19816)
SELECT 
    COUNT(*) AS Current_Employees
FROM
    HR
WHERE
    YEAR(termdate) > YEAR(CURDATE()) OR termdate IS NULL;

-- Identify Terminations in the Latest Year

# Latest Year (2023)
SELECT 
    MAX(YEAR(termdate)) AS Latest_Year
FROM
    HR
WHERE
    termdate IS NOT NULL
        AND termdate < CURDATE();

WITH LatestTerminationYear AS (
	SELECT 
		MAX(YEAR(termdate)) AS Latest_Year
	FROM
		HR
	WHERE
		termdate IS NOT NULL
			AND termdate < CURDATE())

SELECT 
    YEAR(termdate) AS Termination_Year,
    COUNT(*) AS Termination_Count
FROM
    HR
WHERE
    termdate IS NOT NULL AND termdate < CURDATE()
    AND YEAR(termdate) = ( SELECT Latest_Year FROM LatestTerminationYear)
GROUP BY YEAR(termdate)
ORDER BY Termination_Year DESC;




# Previous Year
SELECT 
    MAX(YEAR(termdate)) -1 AS Previous_Year
FROM
    HR
WHERE
    termdate IS NOT NULL
        AND termdate < CURDATE();

SELECT DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
FROM dual;

-- Count of Active Employees in the Previous Year
SELECT 
    COUNT(*) AS PreviousYear_Active_Employees
FROM
    HR
WHERE
    termdate > DATE_SUB(CURDATE(), INTERVAL 1 YEAR) 
    OR termdate IS NULL ;

SELECT * FROM HR WHERE termdate IS NULL;



SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate < CURDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate IS NULL OR termdate > CURDATE() THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate < CURDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100 as termination_rate
FROM HR
WHERE age > 0
GROUP BY department
ORDER BY termination_rate DESC;


SELECT COUNT(*) as total_count
FROM HR
WHERE age > 0;

SELECT Year(hire_date), COUNT(*) as total_count, 
    SUM(CASE WHEN termdate < CURDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate IS NULL OR termdate > CURDATE() THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate < CURDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100 as termination_rate
FROM HR
WHERE age > 0
GROUP BY Year(hire_date)
ORDER BY Year(hire_date) DESC;




