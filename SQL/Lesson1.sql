--  Create Tables 

CREATE TABLE employees (
  emp_id INT PRIMARY KEY, name VARCHAR(50), department VARCHAR(30),
  salary NUMERIC(10,2), hire_date DATE, city VARCHAR(30)
);
INSERT INTO employees VALUES
(1,'Asha','Engineering',85000,'2019-03-15','Bangalore'),
(2,'Ben','Engineering',95000,'2018-07-01','Melbourne'),
(3,'Chitra','Analytics',70000,'2021-01-10','Bangalore'),
(4,'Dev','Analytics',72000,'2020-06-20','Bangalore'),
(5,'Elena','Analytics',88000,'2017-11-05','Melbourne'),
(6,'Farid','Sales',60000,'2022-02-14','Melbourne'),
(7,'Gita','Sales',65000,'2021-09-30','Bangalore'),
(8,'Hugo','HR',55000,'2023-04-01','Melbourne'),
(9,'Ines','Engineering',105000,'2016-05-12','Melbourne'),
(10,'Jon','Sales',NULL,'2024-01-08','Bangalore');

CREATE TABLE orders (
  order_id INT PRIMARY KEY, customer VARCHAR(30), product VARCHAR(30),
  category VARCHAR(30), quantity INT, unit_price NUMERIC(10,2),
  order_date DATE, region VARCHAR(20)
);
INSERT INTO orders VALUES
(1,'Acme','Laptop','Electronics',2,1200.00,'2026-01-05','North'),
(2,'Acme','Mouse','Electronics',10,25.00,'2026-01-05','North'),
(3,'Birch','Desk','Furniture',1,300.00,'2026-01-18','South'),
(4,'Birch','Chair','Furniture',4,150.00,'2026-02-02','South'),
(5,'Cobalt','Laptop','Electronics',1,1200.00,'2026-02-10','East'),
(6,'Cobalt','Monitor','Electronics',3,220.00,'2026-02-11','East'),
(7,'Delta','Notebook','Stationery',50,2.50,'2026-03-01','North'),
(8,'Delta','Pen','Stationery',200,0.80,'2026-03-01','North'),
(9,'Acme','Chair','Furniture',6,150.00,'2026-03-15','North'),
(10,'Birch','Monitor','Electronics',2,220.00,'2026-03-20','South'),
(11,'Echo','Desk','Furniture',2,300.00,'2026-04-04','East'),
(12,'Echo','Pen','Stationery',100,0.80,'2026-04-05','East');


-- Exercises 
--1. COUNT. From employees, return the total number of rows and the number of employees with a recorded salary, as two columns. Explain why the numbers differ. (This is the COUNT(*) vs COUNT(column) trap.)
SELECT COUNT(*) AS NumbOfRows , COUNT(Salary) AS NumOfSalariedEmployees FROM Employees;
--2. SUM and AVG. Return the total and average salary across all employees, with the average rounded to 2 decimals. Predict whether the NULL salary affects the average before you run it.
SELECT SUM(Salary) AS TotalSalary, ROUND(AVG(Salary), 2) AS AvgSalary FROM Employees;
--3. MIN and MAX. In one query, return the earliest and latest hire date, plus the lowest and highest salary.
SELECT MIN(HireDate) AS EarliestHire, MAX(HireDate) AS LatestHire, MIN(Salary) AS MinSalary, MAX(Salary) AS MaxSalary FROM Employees;
--4. GROUP BY. For each department, return the headcount and average salary, sorted by average salary, highest first.
SELECT Department, COUNT(*) AS Headcount, ROUND(AVG(Salary), 2) AS AvgSalary
FROM Employees
GROUP BY Department
ORDER BY AvgSalary DESC;
--5. GROUP BY on a computed value. From orders, return total revenue (quantity * unit_price) per category, sorted from highest to lowest.
SELECT category, SUM(quantity * unit_price) AS TotalRevenue
FROM orders
GROUP BY category
ORDER BY TotalRevenue DESC;
--6. HAVING. Return only departments whose average salary is above 75,000, along with their headcount.
SELECT Department, COUNT(*) AS Headcount, ROUND(AVG(Salary), 2) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 75000;
--7. WHERE and HAVING together. Using only orders placed from January to March 2026, return each region’s order count and total revenue. Keep only regions with at least 3 orders. Decide which condition belongs in WHERE and which in HAVING, and be able to say why.
SELECT region, COUNT(*) AS OrderCount, SUM(quantity * unit_price) AS TotalRevenue
FROM orders
WHERE order_date BETWEEN '2026-01-01' AND '2026-03-31'
GROUP BY region
HAVING COUNT(order_id) >= 3;
--8. Multi-condition HAVING. For each customer, return the number of distinct categories ordered and total revenue. Keep only customers with at least 2 distinct categories and revenue above 1,000. (Check your answer: you should get exactly two customers.)
SELECT customer, COUNT(DISTINCT category) AS NumCategories, SUM(quantity * unit_price) AS TotalRevenue
FROM orders
GROUP BY customer
HAVING COUNT(DISTINCT category) >= 2 AND SUM(quantity * unit_price) > 1000;
