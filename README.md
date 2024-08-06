# HR Data Analysis using MySQL

## Project Overview

This project involves analyzing HR data. The dataset contains over 22,000 rows. The project includes data cleaning and querying to answer specific HR-related questions.


## Files Description

- `data/Human_Resources.csv`: The raw data file used for analysis.
- `sql/HR_Data_Cleaning.sql`: SQL script for data cleaning.
- `sql/HR_Data_Questions.sql`: SQL script for answering specific HR questions.
- `README.md`: Project documentation.
- `.gitignore`: Git ignore file to exclude unnecessary files from the repository.


**Data Cleaning & Analysis** - MySQL Workbench

## Usage

1. **Data Cleaning**:
   - Run the `HR_Data_Cleaning.sql` script to clean the raw HR data.

2. **Data Analysis**:
   - Run the `HR_Data_Questions.sql` script to answer


## Questions

1. What is the gender breakdown of employees in the company?
2. What is the race/ethnicity breakdown of employees in the company?
3. What is the age distribution of employees in the company?
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across locations by state?
10. How has the company's employee count changed over time based on hire and term dates?
11. What is the tenure distribution for each department?

## Summary of Findings

 - There are more male employees
 - White race is the most dominant while Native Hawaiian and American Indian are the least dominant.
 - The youngest employee is 20 years old and the oldest is 57 years old
 - 5 age groups were created (18-24, 25-34, 35-44, 45-54, 55-64). A large number of employees were between 25-34 followed by 35-44 while the smallest group was 55-64.
 - A large number of employees work at the headquarters versus remotely.
 - The average length of employment for terminated employees is around 7 years.
 - The gender distribution across departments is fairly balanced but there are generally more male than female employees.
 - The Marketing department has the highest turnover rate followed by Training. The least turn over rate are in the Research and development, Support and Legal departments.
 - A large number of employees come from the state of Ohio.
 - The net change in employees has increased over the years.
- The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales and Marketing having the lowest.

## Limitations

- Some records had negative ages. There are 967 records with Age < 0, they have birthdates like '2066-01-07' instead of '1966-01-07'. I Corrected the birthdates by subtracting 100 years and recalculate Age.

- Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used were those less than or equal to the current date.
