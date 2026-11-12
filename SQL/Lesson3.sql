
-- Lesson 3: Aggregation and Subqueries/CTEs in SQL

CREATE TABLE employees (
    emp_id INT,
    name VARCHAR(50),
    dept VARCHAR(50),
    salary INT
);

INSERT INTO employees (emp_id, name, dept, salary) VALUES
(1, 'Asha', 'Eng', 90),
(2, 'Ben', 'Eng', 70),
(3, 'Chen', 'Sales', 60),
(4, 'Dia', 'Sales', 50),
(5, 'Eli', 'HR', 40);


--Total salary per department. (GROUP BY)
SELECT dept, SUM(salary) AS total_salary 
FROM employees 
GROUP BY dept ;

--Departments with total salary over 100. (HAVING)
SELECT dept, SUM(salary) AS total_salary 
FROM employees 
GROUP BY dept 
HAVING SUM(salary) >100 ;

--Employees earning less than the company average. (scalar subquery)
SELECT name , salary 
FROM employees 
WHERE salary < (SELECT AVG(salary) FROM employees );

--The highest-paid employee in each department, with their name. (think about which approach works. The grain is a trap.)
WITH max_salary_perdept AS (
    SELECT dept, MAX(salary) AS max_salary
    FROM employees
    GROUP BY dept
)
SELECT e.name, e.dept, e.salary
FROM employees e
JOIN max_salary_perdept m
  ON e.dept = m.dept
 AND e.salary = m.max_salary;

--Departments whose average salary is above the company average. (CTE or subquery, your pick, and explain why)
SELECT dept , AVG(salary) AS avg_salary
FROM employees 
GROUP BY dept 
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);