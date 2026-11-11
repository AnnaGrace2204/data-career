CREATE TABLE departments (
  dept_id INT PRIMARY KEY, dept_name VARCHAR(30), city VARCHAR(30)
);
INSERT INTO departments VALUES
(1,'Engineering','Bangalore'),
(2,'Analytics','Melbourne'),
(3,'Sales','Bangalore'),
(4,'HR','Melbourne'),
(5,'Legal','Sydney');

CREATE TABLE employees (
  emp_id INT PRIMARY KEY, name VARCHAR(50), dept_id INT,
  manager_id INT, salary NUMERIC(10,2)
);
INSERT INTO employees VALUES
(1,'Asha',1,NULL,105000),
(2,'Ben',1,1,85000),
(3,'Chitra',2,5,70000),
(4,'Dev',2,5,72000),
(5,'Elena',2,1,88000),
(6,'Farid',3,7,60000),
(7,'Gita',3,1,65000),
(8,'Hugo',4,1,55000),
(9,'Ines',NULL,1,50000);

CREATE TABLE projects (
  project_id INT PRIMARY KEY, project_name VARCHAR(40), dept_id INT
);
INSERT INTO projects VALUES
(1,'Data Lake',2),
(2,'Mobile App',1),
(3,'CRM Revamp',3),
(4,'Hiring Portal',4),
(5,'Archive Migration',1);

CREATE TABLE assignments (
  emp_id INT, project_id INT, hours INT
);
INSERT INTO assignments VALUES
(1,2,120),(2,2,200),(3,1,150),(4,1,180),(5,1,90),
(2,1,40),(6,3,100),(7,3,60),(8,4,80),(5,3,30);


--INNER JOIN. Return each employee’s name, department name and department city. Check: 8 rows. Be able to say who is missing and why.
Select E.name , D.dept_name , D.city from
employees AS E Join departments AS D 
ON E.dept_id = D.dept_id ;

--LEFT JOIN. Return all employees with their department name, showing 'Unassigned' where there is no department.Check: 9 rows. Use COALESCE
Select E.name , COALESCE(D.dept_name,'Unassigned') as dept_name from
employees AS E Left Join departments AS D 
ON E.dept_id = D.dept_id ;

--Anti-join. Return departments that have no employees. Check: exactly one row (Legal). Write it with LEFT JOIN ... IS NULL, then think about which column you test for NULL and why that choice matters.
Select D.dept_name from
departments AS D Left Join employees AS E
ON D.dept_id = E.dept_id
WHERE E.emp_id IS NULL;

--oin plus aggregate. For every department, including empty ones, return the headcount and total salary. Check: Legal appears with headcount 0. Trap: COUNT(*) gives Legal a 1, so use COUNT(e.emp_id)
Select D.dept_name, COUNT(E.emp_id) as headcount, COALESCE(SUM(E.salary),0) as total_salary
from departments AS D Left Join employees AS E
ON D.dept_id = E.dept_id
GROUP BY D.dept_name;

--Self join. Return each employee’s name next to their manager’s name, showing 'None' for Asha. Check: 9 rows.
Select E.name as employee_name, COALESCE(M.name,'None') as manager_name
from employees AS E Left Join employees AS M
ON E.manager_id = M.emp_id;

--Three-table join. Return employee name, project name and hours for every assignment, sorted by project name, then hours descending. Check: 10 rows.
Select E.name as employee_name, P.project_name, A.hours
from assignments AS A
Join employees AS E
ON A.emp_id = E.emp_id
Join projects AS P
ON A.project_id = P.project_id
Order by A.hours DESC;

--LEFT JOIN with aggregation across a chain. Return every project with its total hours and the number of distinct employees assigned, including projects nobody works on. Check: Data Lake 460 hours, Mobile App 320, CRM Revamp 190, Hiring Portal 80, Archive Migration 0.
Select P.project_name, COALESCE(SUM(A.hours),0) as total_hours, COUNT(DISTINCT A.emp_id) as num_employees
from projects AS P Left Join assignments AS A
ON P.project_id = A.project_id
GROUP BY P.project_name;

--Join with a cross-table comparison. Find assignments where the employee’s department differs from the department that owns the project. Return employee name, their department, project name and the project’s department. Check: exactly two rows (Ben on Data Lake, Elena on CRM Revamp). Hint: you need employees, assignments, projects, and departments twice.
Select E.name as employee_name, ED.dept_name as employee_dept, P.project_name, PD.dept_name as project_dept
from assignments AS A
Join employees AS E
ON A.emp_id = E.emp_id
Join departments AS ED
ON E.dept_id = ED.dept_id
Join projects AS P
ON A.project_id = P.project_id
Join departments AS PD
ON P.dept_id = PD.dept_id
WHERE ED.dept_id != PD.dept_id;

