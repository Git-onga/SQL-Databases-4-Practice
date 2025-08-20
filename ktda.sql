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

ALTER TABLE farmer_produce
DROP COLUMN station;

ALTER TABLE farmer_produce
MODIFY COLUMN quantity DECIMAL(10,2) NOT NULL;



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