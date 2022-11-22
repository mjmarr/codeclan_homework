/* MVP */
/* Q1 */
SELECT *
FROM employees 
WHERE department = 'Human Resources'

/* Q2 */
SELECT first_name, last_name, county
FROM employees
WHERE department = 'Legal'

--Question 3.
--Count the number of employees based in Portugal.
/* Q3 */
SELECT COUNT(*) AS total_employees
FROM employees 
WHERE country = 'Portugal'

/* Q4 */
SELECT COUNT(*) AS total_employees
FROM employees 
WHERE country = 'Portugal' OR  country = 'Spain';

--Question 5.
--Count the number of pay_details records lacking a local_account_no.
/* Q5 */
SELECT COUNT(*) AS pay_details_lacking
FROM pay_details  
WHERE local_account_no IS NULL;

/* Q6 */
SELECT *
FROM pay_details  
WHERE local_account_no IS NULL AND iban IS NULL;

/* Q7 */
SELECT 
    first_name,
    last_name 
FROM employees 
ORDER BY last_name ASC NULLS LAST;

/* Q8 */
SELECT 
    first_name,
    last_name,
    country 
FROM employees 
ORDER BY country, last_name ASC NULLS LAST;

/* Q9 */
SELECT *
FROM employees
WHERE salary IS NOT NULL
ORDER BY salary DESC
LIMIT 10;

/* Q10 */
SELECT 
    first_name,
    last_name,
    salary, country
FROM employees
WHERE country = 'Hungary'
ORDER BY salary ASC;

/* Q11 */
SELECT COUNT(*) AS beginning_with_f
FROM employees  
WHERE first_name ~* '^F';

/* Q12 */
SELECT *
FROM employees
WHERE email LIKE '%yahoo%';

/* Q13 */
SELECT COUNT(*) AS pension_enrolled
FROM employees  
WHERE pension_enrol AND country NOT IN ('france','Germany');

/* Q14 */
SELECT *
FROM employees
WHERE department = 'Engineering' AND fte_hours >= 1.0
ORDER BY salary DESC
LIMIT 1;

/* Q15 */
SELECT 
    first_name,
    last_name,
    fte_hours,
    salary,
    concat(fte_hours * salary) AS effective_yearly_salary
FROM employees;

/* EXTENSION*/
/* Q16 */
SELECT 
    concat(first_name, ' ', last_name, '  - ', department) AS badge_label
FROM employees
WHERE COALESCE (first_name, last_name , department) IS NOT NULL;

/* Q17 */
SELECT 
    concat(first_name, ' ', last_name, '  - ', department, 
            ' (joined ', to_char(start_date, 'FMMonth'), ' ', 
            EXTRACT(YEAR FROM start_date),')') AS badge_label
FROM employees
WHERE COALESCE (first_name, last_name , department) IS NOT NULL;


/* Q18 */
SELECT 
    first_name,
    last_name,
    salary,
    CASE
      WHEN (salary < 40000) THEN 'low'
      WHEN (salary >= 40000) THEN 'high'
   END AS salary_class
FROM employees;