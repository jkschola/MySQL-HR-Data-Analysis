USE Projects;

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
-- Age distribution
SELECT 
    Age, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY Age
ORDER BY Employees_Count DESC;

-- Youngest and oldest employee ages
SELECT 
    MIN(Age) AS Youngest, MAX(Age) AS Oldest
FROM
    HR
WHERE
    Age > 0;

-- Age distribution grouped by decade
SELECT 
    FLOOR(Age / 10) * 10 AS Age_Group, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY Age_Group
ORDER BY Age_Group ASC;

-- Age distribution in specific age groups
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

-- Age and gender distribution in specific age groups
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
GROUP BY Age_Group, gender
ORDER BY Age_Group, gender;

-- 4. How many employees work at headquarters versus remote locations?

SELECT 
    location, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?

-- Average tenure in years (method 1)
SELECT 
    FLOOR(AVG(DATEDIFF(termdate, hire_date) / 365.25)) AS Avg_Tenure_Years
FROM
    HR
WHERE
    termdate IS NOT NULL
    AND termdate < CURDATE();

-- Average tenure in years (method 2)
SELECT 
    FLOOR(AVG(TIMESTAMPDIFF(YEAR, hire_date, termdate))) AS Avg_Tenure_Years
FROM
    HR
WHERE
    termdate IS NOT NULL
    AND termdate < CURDATE();

-- 6. How does the gender distribution vary across departments and job titles?

-- Gender distribution by department
SELECT 
    department, gender, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY department, gender
ORDER BY department;

-- Gender distribution by job title
SELECT 
    jobtitle, gender, COUNT(*) AS Employees_Count
FROM
    HR
WHERE
    Age > 0
GROUP BY jobtitle, gender
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

-- Count of active employees (current year)
SELECT 
    COUNT(*) AS CY_Employees
FROM
    HR
WHERE
    termdate > CURDATE() OR termdate IS NULL;

-- Termination trends over time (including terminations up to current date)
SELECT 
    YEAR(termdate) AS Termination_Year,
    COUNT(*) AS Termination_Count
FROM
    HR
WHERE
    termdate IS NOT NULL
    AND termdate < CURDATE()
GROUP BY YEAR(termdate)
ORDER BY Termination_Year DESC;

-- Identify current employees (as of today)
SELECT 
    COUNT(*) AS Current_Employees
FROM
    HR
WHERE
    termdate > CURDATE() OR termdate IS NULL;

-- Identify terminations in the latest year
WITH LatestTerminationYear AS (
    SELECT 
        MAX(YEAR(termdate)) AS Latest_Year
    FROM
        HR
    WHERE
        termdate IS NOT NULL
        AND termdate < CURDATE()
)
SELECT 
    YEAR(termdate) AS Termination_Year,
    COUNT(*) AS Termination_Count
FROM
    HR
WHERE
    termdate IS NOT NULL
    AND termdate < CURDATE()
    AND YEAR(termdate) = (SELECT Latest_Year FROM LatestTerminationYear)
GROUP BY YEAR(termdate)
ORDER BY Termination_Year DESC;

-- Previous year
SELECT 
    MAX(YEAR(termdate)) - 1 AS Previous_Year
FROM
    HR
WHERE
    termdate IS NOT NULL
    AND termdate < CURDATE();

-- Count of active employees in the previous year
SELECT 
    COUNT(*) AS PreviousYear_Active_Employees
FROM
    HR
WHERE
    termdate > DATE_SUB(CURDATE(), INTERVAL 1 YEAR) 
    OR termdate IS NULL;

-- Turnover rate by department
SELECT 
    department, 
    COUNT(*) AS total_count, 
    SUM(CASE WHEN termdate < CURDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminated_count, 
    SUM(CASE WHEN termdate IS NULL OR termdate > CURDATE() THEN 1 ELSE 0 END) AS active_count,
    (SUM(CASE WHEN termdate < CURDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS termination_rate
FROM 
    HR
WHERE 
    Age > 0
GROUP BY 
    department
ORDER BY 
    termination_rate DESC;

-- Total employee count
SELECT COUNT(*) AS total_count
FROM HR
WHERE Age > 0;

-- Yearly employee count and termination rate
SELECT 
    YEAR(hire_date) AS hire_year, 
    COUNT(*) AS total_count, 
    SUM(CASE WHEN termdate < CURDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminated_count, 
    SUM(CASE WHEN termdate IS NULL OR termdate > CURDATE() THEN 1 ELSE 0 END) AS active_count,
    (SUM(CASE WHEN termdate < CURDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS termination_rate
FROM 
    HR
WHERE 
    Age > 0
GROUP BY 
    hire_year
ORDER BY 
    hire_year DESC;
