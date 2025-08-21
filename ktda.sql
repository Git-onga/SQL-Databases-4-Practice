CREATE DATABASE IF NOT EXISTS ktda;
USE ktda;

CREATE TABLE customer (
    cust_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    station VARCHAR(50) NOT NULL,
    phone_no VARCHAR(13) NOT NULL,
    yr_of_registration DATE NULL
);

SELECT * FROM employee;

CREATE TABLE employee (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    yr_of_employement DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

CREATE TABLE trucks (
    truck_id INT PRIMARY KEY AUTO_INCREMENT,
    no_plate VARCHAR(50) NOT NULL,
    truck_driver INT NOT NULL,
    service_station VARCHAR(50) NOT NULL,
    yr_of_purchase DATE NOT NULL
);

CREATE TABLE farmer_produce (
    produce_id INT PRIMARY KEY  AUTO_INCREMENT,
    farmer_id INT NOT NULL,
    quantity INT NOT NULL,
    purchase_date DATETIME NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50) NOT NULL,
    cost_KES DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE sales (
    sales_id INT PRIMARY KEY AUTO_INCREMENT,
    produce_id INT NOT NULL,
    quantity INT NOT NULL,
    sale_date DATETIME NOT NULL
);

INSERT INTO employee (first_name, last_name, email, department, yr_of_employement, salary) VALUES 
("Hellan", "Wambui", "wambui42@gmail.com", "Clerk", "2022-10-21", 18000),
("James", "Maina", "JamesM1992@gmail.com", "Product Manager", "2023-03-09", 25000),
("Mark", "Gitonga", "markgee32@gmail.com", "Driver", "2021-02-12", 20000),
("Alex", "Mwaura", "mwauraA30@gmail.com", "Clerk", "2022-10-21", 18000),
("Mercy", "Njeri", "njee32@gmail.com", "Sales Manager", "2021-04-10", 25000),
("Eugene", "Kimani", "eukim32@gmail.com", "Driver", "2021-02-12", 18000),
("Tina", "Wangeshi", "Tin1999@gmail.com", "Driver", "2021-02-12", 18000);
SELECT * FROM employee;

INSERT INTO farmer (first_name, last_name, email, station, phone_no, yr_of_registration) VALUES
("Nancy", "Kimotho", "NancyK32@gmail.com", "A001", "+254712345678", "2021-03-12"),
("Joel", "Kimani", "jkim1990@gmail.com", "A001", "+254723456789", "2021-03-12"),
("Victor", "Njoroge", "njoro902@gmail.com", "A010", "+245734567890", "2021-03-12"),
("Jecinta", "Waweru", "Waweru302@gmail.com", "D002", "+254745678901", "2021-03-27"),
("Samuel", "Wangui", "wnguisamuel1990@gmail.com", "D002", "+254756789012", "2021-03-27"),
("Innocent", "Wambugu", "Innocent321@gmail.com", "D002", "+245767890123", "2021-03-27"),
("William", "Ngure", "willy32@gmail.com", "B008", "+254778901234", "2021-04-09"),
("Samatha", "Muremi", "sammuremi90@gmail.com", "B008", "+254789012345", "2021-04-09"),
("Daniel", "Muchoki", "dmuchoki902@gmail.com", "B008", "+24579012346", "2021-04-09"),
("Cathrine", "Kimotho", "NancyK32#gmail.com", "C024", "+25471234567", "2021-04-17"),
("Monica", "Kimani", "jkim1990@gmail.com", "C024", "+254723456789", "2021-04-17"),
("Rose Mary", "Njoroge", "njoro902@gmail.com", "C024", "+245734567890", "2021-04-17");
SELECT * FROM farmer;


SELECT * FROM  farmer_produce;

INSERT INTO farmer_produce (farmer_id, quantity, purchase_date) VALUES
(1, 20.4, "2025-07-02 10:20:31"),
(3, 17.9, "2025-07-02 10:23:10"),
(4, 11.2, "2025-07-02 10:24:21"),
(5, 7.3, "2025-07-02 13:56:01"),
(9, 12.0, "2025-07-02 16:12:09"),
(2, 31.7, "2025-07-03 10:42:13"),
(7, 10.3, "2025-07-03 13:45:37"),
(8, 27.1, "2025-07-03 13:48:18"),
(10, 29.5, "2025-07-03 16:03:19"),
(12, 9.32, "2025-07-03 16:04:59"),
(1, 19.2, "2025-07-04 10:01:10"),
(2, 3.4, "2025-07-04 10:03:21");


INSERT INTO products (product_name, cost_KES, stock) VALUES
("KTDA Mununga 120g", 70, 700),
("KTDA Mununga 240g", 140, 900),
("KTDA Mununga 500g", 280, 400);

SELECT * FROM products;

INSERT INTO sales (produce_id,quantity,sale_date) VALUES
(1, 13, "2025-07-02 10:20:31"),
(3, 4, "2025-07-02 10:23:10"),
(2, 42, "2025-07-02 10:24:21"),
(3, 7, "2025-07-02 13:56:01"),
(1, 11, "2025-07-02 16:12:09"),
(2, 10, "2025-07-03 10:42:13"),
(3, 8, "2025-07-03 13:45:37"),
(1, 30, "2025-07-03 13:48:18"),
(1, 19., "2025-07-03 16:03:19"),
(1, 32, "2025-07-03 16:04:59"),
(1, 19, "2025-07-04 10:01:10"),
(2, 34, "2025-07-04 10:03:21");

SELECT * FROM sales;

INSERT INTO trucks (no_plate, truck_driver, service_station, yr_of_purchase) VALUES
("KBM 324O", 1, "A001", "2021-04-03"),
("KCF 421M", 4, "B008", "2022-01-10"),
("KDJ 213L", 7, "C024", "2023-10-21"),
("KDS 326H", 8, "D002", "2024-03-12");

--Renaming the customer table to farmer ✅
RENAME TABLE customer TO farmer;

-- Changing the primary key column's name ✅
ALTER TABLE farmer
CHANGE COLUMN cust_id farm_id INT;

SHOW TABLES;

-- Adding a foreign Key in an already made table ✅
ALTER TABLE farmer_produce
ADD CONSTRAINT fk_farmer
FOREIGN KEY (farmer_id)
REFERENCES farmer(farm_id);

-- Remove station in the farmer_produce table✅
ALTER TABLE farmer_produce
DROP COLUMN station;

-- Changing the datatype from INT to DECIMAL ✅
ALTER TABLE farmer_produce
MODIFY COLUMN quantity DECIMAL(10,2) NOT NULL;

SELECT * FROM trucks;

-- Update the station column in id = 3 ✅
UPDATE farmer
SET station = "A001"
WHERE farm_id = 3

-- Updating the salary column to ensure consitency ✅
UPDATE employee
SET salary = 20000
WHERE emp_id = 8;

    -- Querying the Database

-- Retriving a list of all farmers bases on the recent year they joined
SELECT yr_of_registration, farm_id, first_name, last_name, station
FROM farmer
ORDER BY yr_of_registration DESC;

-- Show all the employees with thier department and order their salary
SELECT emp_id,first_name, last_name, department, salary
FROM employee
ORDER BY department, salary DESC;

    -- 2. Aggregation and Analysis Questions

-- Calculate total quantity of produce purchased from each station
SELECT f.station, SUM(fp.quantity) AS total_quantity_per_station
FROM farmer_produce fp
JOIN farmer f ON fp.farmer_id = f.farm_id
GROUP BY f.station
ORDER BY station DESC;

-- Show total sales quantity for each product
SELECT p.product_name, SUM(s.quantity) as total_sold
FROM sales s
JOIN products p ON s.produce_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

    -- Join Operation Questions

-- List all farmers and their total produce quantity
SELECT f.farm_id, f.first_name, f.last_name, f.station,
       COALESCE(SUM(fp.quantity), 0) as total_produce
FROM farmer f
LEFT JOIN farmer_produce fp ON f.farm_id = fp.farmer_id
GROUP BY f.farm_id, f.first_name, f.last_name, f.station
ORDER BY farm_id ASC;

-- Show employees who are also truck drivers
SELECT e.emp_id, e.first_name, e.last_name, e.department,
       t.no_plate, t.service_station
FROM employee e
JOIN trucks t ON e.emp_id = t.truck_driver
ORDER BY e.emp_id;

-- Display purchase details with farmer information
SELECT fp.produce_id, f.first_name, f.last_name, f.station,
       fp.quantity, fp.purchase_date
FROM farmer_produce fp
JOIN farmer f ON fp.farmer_id = f.farm_id
ORDER BY fp.purchase_date DESC;

    -- Date-Based Analysis Questions

--Find farmers registered in 2021 by quarter
SELECT 
    QUARTER(yr_of_registration) as quarter,
    COUNT(*) as farmers_registered
FROM farmer
WHERE YEAR(yr_of_registration) = 2021
GROUP BY QUARTER(yr_of_registration)
ORDER BY quarter;

-- Show monthly produce purchase totals for current year
SELECT 
    MONTH(purchase_date) as month,
    SUM(quantity) as monthly_total
FROM farmer_produce
WHERE YEAR(purchase_date) = YEAR(CURDATE())
GROUP BY MONTH(purchase_date)
ORDER BY month;

-- List employees with their years of service
SELECT 
    first_name, last_name, department,
    yr_of_employement,
    TIMESTAMPDIFF(YEAR, yr_of_employement, CURDATE()) as years_of_service
FROM employee
ORDER BY years_of_service DESC;


    --Advanced Analytical Questions

-- Find the top 5 most productive farmers
SELECT f.farm_id, f.first_name, f.last_name, f.station,
       SUM(fp.quantity) as total_produce,
       COUNT(fp.produce_id) as delivery_count
FROM farmer f
JOIN farmer_produce fp ON f.farm_id = fp.farmer_id
GROUP BY f.farm_id, f.first_name, f.last_name, f.station
ORDER BY total_produce DESC
LIMIT 5;

-- Calculate revenue generated by each product
SELECT p.product_id, p.product_name,
       SUM(s.quantity) as units_sold,
       SUM(s.quantity * p.cost_KES) as total_revenue
FROM sales s
JOIN products p ON s.produce_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

-- Identify stations with below-average produce quantity
SELECT f.station, SUM(fp.quantity) as station_total,
       (SELECT AVG(station_avg) 
        FROM (SELECT SUM(quantity) as station_avg
              FROM farmer_produce fp2
              JOIN farmer f2 ON fp2.farmer_id = f2.farm_id
              GROUP BY f2.station) as avg_table) as overall_average
FROM farmer_produce fp
JOIN farmer f ON fp.farmer_id = f.farm_id
GROUP BY f.station
HAVING station_total < overall_average
ORDER BY station_total;

    -- Data Validation and Quality Questions

-- Find duplicate email addresses in farmer table
SELECT email, COUNT(*) as duplicate_count
FROM farmer
GROUP BY email
HAVING COUNT(*) > 1;

-- Identify farmers with no produce records
SELECT f.farm_id, f.first_name, f.last_name, f.station
FROM farmer f
LEFT JOIN farmer_produce fp ON f.farm_id = fp.farmer_id
WHERE fp.produce_id IS NULL;

-- Check for products with low stock levels
SELECT product_id, product_name, stock, cost_KES
FROM products
WHERE stock < 100
ORDER BY stock ASC;

    -- Complex Reporting Questions

-- Generate a comprehensive station performance report
SELECT 
    f.station,
    COUNT(DISTINCT f.farm_id) as total_farmers,
    COUNT(fp.produce_id) as total_deliveries,
    SUM(fp.quantity) as total_produce,
    AVG(fp.quantity) as avg_delivery_size
FROM farmer f
LEFT JOIN farmer_produce fp ON f.farm_id = fp.farmer_id
GROUP BY f.station
ORDER BY total_produce DESC;

-- Employee productivity report with salary analysis
SELECT 
    department,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    ROUND(MAX(salary), 2) as max_salary,
    ROUND(MIN(salary), 2) as min_salary,
    SUM(salary) as total_payroll
FROM employee
GROUP BY department
ORDER BY total_payroll DESC;

    -- Maintenance and Monitoring Queries

-- Database size and table statistics
SELECT 
    table_name,
    table_rows,
    ROUND((data_length + index_length) / 1024 / 1024, 2) as size_mb
FROM information_schema.tables
WHERE table_schema = 'ktda'
ORDER BY size_mb DESC;

-- Recent database activities
SELECT 
    fp.purchase_date as activity_date,
    'Produce Purchase' as activity_type,
    CONCAT(f.first_name, ' ', f.last_name) as farmer_name,
    fp.quantity
FROM farmer_produce fp
JOIN farmer f ON fp.farmer_id = f.farm_id
WHERE fp.purchase_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY fp.purchase_date DESC
LIMIT 20;


    -- practicing ALTER command

CREATE TABLE practice_alter (
    id INT,
    name VARCHAR(50) NOT NULL,
    no_of_times INT NOT NULL
);

INSERT INTO practice_alter (id,name,no_of_times) VALUES
(1,"SELECT", 3),
(2,"INSERT", 5),
(3,"CREATE", 4),
(4,"UPDATE", 0),
(5,"DELETE", 0),
(6,"TRUNCATE", 1),
(7,"RENAME", 1),
(8,"ALTER", 3),
(9,"DROP", 4);

-- Show the contents of the table
SELECT * FROM practice_alter;

-- Using Altering to add Column
ALTER TABLE practice_alter
ADD COLUMN category VARCHAR(50);

-- Entering values after adding a Column
UPDATE practice_alter
SET 
    category = "DDL"
WHERE
    id = 9;

-- Altering the table to set a Key
ALTER TABLE practice_alter
ADD PRIMARY KEY (id);

-- ⚠️⚠️DELETING all the rows in a column
TRUNCATE TABLE practice_alter;

-- ⚠️⚠️DELETING a single row
DELETE FROM practice_alter
WHERE id = 9

-- ⚠️⚠️DELETING all the rows in a column
DROP TABLE practice_alter;