Question 1.

    (c). Find the first name, last name and team name of employees who are members of teams, where their team has a charge cost greater than 80. 
    
--q1
    --a
SELECT 
    first_name,
    last_name,
    t."name" AS team_name
FROM employees AS e
 INNER JOIN teams AS t
 ON e.team_id = t.id;

    --b
SELECT 
    first_name,
    last_name,
    t."name" AS team_name,
    pension_enrol 
FROM employees AS e
 INNER JOIN teams AS t
 ON e.team_id = t.id
WHERE e.pension_enrol IS TRUE;

    --c
SELECT 
    first_name,
    last_name,
    t."name" AS team_name,
    t.charge_cost AS cost_charge
FROM employees AS e
 INNER JOIN teams AS t
 ON e.team_id = t.id
WHERE CAST(charge_cost AS int) > 80;


--  q2
    --a 
SELECT *
FROM employees AS e
INNER JOIN pay_details AS pd
ON e.pay_detail_id = pd.id;
    --b
--(b). Amend your query above to also return the name of the team that each employee belongs to. 
SELECT 
 first_name,
 last_name,
 pd.local_account_no,
 pd.local_sort_code,
 t."name" AS team_name
FROM employees AS e
INNER JOIN pay_details AS pd
ON e.pay_detail_id = pd.id
INNER JOIN teams AS t
ON e.team_id = t.id;
  
--q3
    --a
SELECT 
 e.id AS employee_id,
 t."name" AS team_name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id;
    
    --b
SELECT
 t."name" AS team_name,
 count(e.id)
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY team_name;  

    --c
SELECT
 t."name" AS team_name,
 count(*) AS members
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY team_name
ORDER BY members ASC;
 
--q4
    --a
SELECT
 t.id AS team_id,
 t."name" AS team_name,
 count(*) AS members
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id, team_name
ORDER BY members ASC;

--b
SELECT
 t.id AS team_id,
 t."name" AS team_name,
 count(e.id) AS members,
 count(e.id) * CAST(t.charge_cost AS int) AS total_day_charge
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id, team_name
ORDER BY members ASC;

--c
SELECT
 t.id AS team_id,
 t."name" AS team_name,
 count(e.id) AS members,
 count(e.id) * CAST(t.charge_cost AS int) AS total_day_charge
FROM employees AS e
 INNER JOIN teams AS t
 ON e.team_id = t.id
GROUP BY t.id, team_name
HAVING (count(e.id) * CAST(t.charge_cost AS int)) > 5000
ORDER BY total_day_charge ASC;


--extension
--q5
SELECT *
FROM employees_committees;

SELECT 
    employee_id,
    count(employee_id) AS total
FROM employees_committees
GROUP BY employee_id
HAVING count(employee_id) > 1;

SELECT 
    employee_id,
    count(committee_id)
FROM employees_committees
GROUP BY employee_id;

--q5 ans
SELECT 
  COUNT(DISTINCT(employee_id)) AS num_employees_on_committees
FROM employees_committees

--q6
SELECT count(e.id) AS member_who_dont_serve
FROM employees AS e
left JOIN employees_committees AS ec
ON e.id = ec.employee_id
WHERE ec.committee_id IS NULL;