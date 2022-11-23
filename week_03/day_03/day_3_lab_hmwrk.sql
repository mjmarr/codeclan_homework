-- MVP

--q1
SELECT count(*)
FROM employees
WHERE grade IS NULL AND salary IS NULL;


--q2
SELECT 
    first_name,
    last_name,
    department
FROM employees 
ORDER BY department, first_name;


--q3
SELECT
    first_name,
    last_name,
    salary
FROM employees 
WHERE last_name ILIKE '%a'
ORDER BY salary DESC
LIMIT 10;

--q4
SELECT department, count(*)
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;


--q5
SELECT
    department, 
    fte_hours,
    count(*) AS number_of_employees
FROM employees
GROUP BY department, fte_hours
ORDER BY department, fte_hours;

--q6
SELECT 
    pension_enrol,
    count(*),
    case 
        when pension_enrol = TRUE then 'enrolled'
        when pension_enrol = FALSE then 'not-enrolled'
        else 'unknown'
    end as status
FROM employees
GROUP BY pension_enrol;
    

--q7
SELECT *
FROM employees
WHERE department = 'Accounting' 
    AND pension_enrol IS FALSE 
    AND salary IS NOT null
ORDER BY salary DESC
LIMIT 1;

--q8
SELECT 
    country,
    count(*) AS num_of_employees,
    avg(salary)
FROM employees 
GROUP BY country
HAVING count(*) > 30
ORDER BY avg(salary) DESC;

--q9
SELECT 
    first_name,
    last_name,
    fte_hours,
    salary,
    fte_hours * salary AS effective_yearly_salary
FROM employees
WHERE (fte_hours * salary) > 30000;

--q10
SELECT *
FROM teams;

SELECT *
FROM employees
WHERE team_id IN (7,8);

--q11
SELECT 
    e.first_name,
    e.last_name
FROM employees AS e
INNER JOIN pay_details AS pd
ON e.pay_detail_id = pd.id 
WHERE local_tax_code IS NULL;

--q12
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    e.department,
    t."name",
    ((48 * 35) * CAST(t.charge_cost AS int) - e.salary * e.fte_hours) AS expected_profit
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id;


--q13
WITH least_common_fte AS (
    SELECT
        fte_hours,
        count(*)
    FROM employees
    GROUP BY fte_hours
    ORDER BY count(*) ASC
    LIMIT 1
)
SELECT *
FROM employees
WHERE country = 'Japan' AND fte_hours = (SELECT fte_hours FROM least_common_fte)
ORDER BY salary
LIMIT 1;

--q14
SELECT 
    department,
    count(*)
FROM employees 
WHERE first_name IS NULL
GROUP BY department
HAVING count(*) > 2
ORDER BY department;

--q15
SELECT 
    first_name,
    count(id)
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name
ORDER BY count(id) DESC, first_name ASC;

--q16

SELECT 
    department,    
    grade,
    count(*)
FROM employees
GROUP BY department, grade;

WITH t16 AS 
 (SELECT 
    department, 
    grade, 
    count(*) AS n 
  FROM employees
  GROUP BY department, grade)
SELECT 
    department, 
    grade, 
    n, 
       (0.0+n)/(COUNT(*) OVER (PARTITION BY department)) AS proportion -- no integer divide!
FROM t16;

--Extension

--q1
WITH CTE AS
(
    SELECT 
        department, 
        count(*) AS num_employ,
        avg(salary) AS avg_sal,
        avg(fte_hours) AS avg_hours
    FROM employees
    GROUP BY department
    ORDER BY num_employ DESC
    LIMIT 1
)
SELECT 
    e.id, 
    e.first_name, 
    e.last_name, 
    e.department, 
    e.salary,
    e.fte_hours,
    100 * (cte.avg_sal - e.salary ) / e.salary AS salary_proportion,
    100 * (cte.avg_hours - e.fte_hours) / e.fte_hours AS fte_proportion
FROM employees AS e
CROSS JOIN CTE AS cte
GROUP BY e.id, cte.avg_sal, avg_hours;


--q2
SELECT 
    case 
        when pension_enrol = TRUE then 'enrolled'
        when pension_enrol = FALSE then 'not-enrolled'
        else 'unknown'
    end as status,
        count(*)
FROM employees
GROUP BY pension_enrol;

--q3
 SELECT 
    e.first_name, 
    e.last_name, 
    e.email, 
    e.start_date
FROM employees AS e
INNER JOIN employees_committees AS ec
ON e.id = ec.employee_id
WHERE ec.committee_id = 3 --Equality and Diversity
ORDER BY start_date;

--q4
SELECT 
    case 
        when (e.salary < 40000) then 'low'
        when (e.salary >= 40000) then 'high'
        else 'none'
    end as salary_class,
    count(*)
FROM employees AS e
INNER JOIN employees_committees AS ec
ON e.id = ec.employee_id
GROUP BY salary_class;
