SHOW databases;

-- Create the database
CREATE DATABASE SupermarketManagement;
USE SupermarketManagement;

-- Table for product categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Table for products/items
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    barcode VARCHAR(50) UNIQUE,
    price DECIMAL(10, 2) NOT NULL,
    cost_price DECIMAL(10, 2) NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    reorder_level INT DEFAULT 10,
    supplier_id INT,
    date_added DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Table for suppliers
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT
);

-- Add foreign key to Products after Suppliers is created
ALTER TABLE Products
ADD FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id);

-- Table for employees
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table for customers (optional, for loyalty programs)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    join_date DATE,
    loyalty_points INT DEFAULT 0
);

-- Table for sales transactions
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_date DATETIME NOT NULL,
    employee_id INT,
    customer_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'Mobile Payment'),
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    tax_amount DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Table for sold items (line items in a sale)
CREATE TABLE SaleItems (
    sale_item_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Table for inventory movements
CREATE TABLE InventoryMovements (
    movement_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    movement_type ENUM('Purchase', 'Sale', 'Adjustment', 'Return', 'Damage'),
    quantity INT NOT NULL,
    movement_date DATETIME NOT NULL,
    reference_id INT, -- could be sale_id or purchase order id
    notes TEXT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Table for employee shifts
CREATE TABLE EmployeeShifts (
    shift_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    shift_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    hours_worked DECIMAL(4, 2),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Table for promotions/discounts
CREATE TABLE Promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    promotion_name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type ENUM('Percentage', 'Fixed Amount'),
    discount_value DECIMAL(10, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table for product promotions
CREATE TABLE ProductPromotions (
    product_promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    promotion_id INT NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (promotion_id) REFERENCES Promotions(promotion_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create indexes for better performance
CREATE INDEX idx_product_name ON Products(product_name);
CREATE INDEX idx_sale_date ON Sales(transaction_date);
CREATE INDEX idx_employee_name ON Employees(last_name, first_name);
CREATE INDEX idx_product_category ON Products(category_id);

    --Simple Data Insertion

-- Insert sample categories
INSERT INTO Categories (category_name, description) VALUES
('Beverages', 'Soft drinks, juices, water, etc.'),
('Dairy', 'Milk, cheese, yogurt, etc.'),
('Bakery', 'Bread, cakes, pastries, etc.'),
('Frozen Foods', 'Frozen vegetables, meals, ice cream, etc.'),
('Meat', 'Beef, chicken, pork, etc.'),
('Produce', 'Fresh fruits and vegetables'),
('Household', 'Cleaning supplies, paper products, etc.');
INSERT INTO Categories (category_name, description) VALUES
("Electronics", 'TVs, Home appliances, Kitchen appliences');

-- Insert sample suppliers
INSERT INTO Suppliers (supplier_name, contact_person, phone, email) VALUES
('Fresh Foods Co.', 'John Smith', '555-1001', 'john@freshfoods.com'),
('Beverage Distributors Inc.', 'Sarah Johnson', '555-1002', 'sarah@bevdist.com'),
('Quality Meats Ltd.', 'Mike Brown', '555-1003', 'mike@qualitymeats.com');
INSERT INTO  Suppliers (supplier_name, contact_person, phone, email) VALUES
("Brookside Dairy Best Co.", "Lawrence Gray", "555-2394", "Lau@brookside.com"),
('Fresha Bakaries and Co.', 'James Muriuki', '555-3212', 'muruiki@fresha.com'),
('GGG Distributors Ltd.', "Nancy Coldwater", "555-3212", "nacy@ggg.com"),
("Tiger Electronics Ltd.", "Gilbert Trent", "555-3211", "tigercontact@gmail.com"),
("Woosh and Co.", "Kill Margert", "555-1004", "margert@kill.com");


-- Insert sample products
INSERT INTO Products (product_name, category_id, barcode, price, cost_price, quantity_in_stock, supplier_id, date_added) VALUES
('Whole Milk 1L', 2, '123456789012', 105.15, 91.80, 50, 1, '2023-01-15'),
('White Bread 400g', 3, '234567890123', 65.00, 50.00, 30, 5, '2023-01-15'),
('Mineral Water 500ml', 1, '345678901234', 40.25, 20.40, 100, 2, '2023-01-20'),
('Chicken Breast 1kg', 5, '456789012345', 400.10, 320.60, 25, 3, '2023-02-01'),
('Apples 1kg', 6, '567890123456', 100.50, 90.00, 40, 1, '2023-02-05');
INSERT INTO Products (product_name, category_id, barcode, price, cost_price, quantity_in_stock, supplier_id, date_added) VALUES
('Delmere 500mL', 2, '678912345012', 150.90, 100.80, 50, 4, '2023-02-07'),
('43-Inch Smart TV', 8, '456789012323', 45000.00, 39000.00, 4, 7, '2023-02-15'),
('Tiger Microwave', 8, '345901267834', 30000.25, 25000.40, 2, 7, '2023-02-15'),
('Omo Detergent Cleaner', 7, '789014562345', 150.10, 99.60, 25, 8, '2023-02-17'),
('Sparkling Bar Soap', 7, '567456890123', 100.50, 90.00, 40, 8, '2023-02-17'),
('Coca Cola 2l', 1, '190234567812', 210.00, 191.80, 50, 6, '2023-02-20'),
('FarmFresh Sousages', 4, '901232345678', 305.00, 289.40, 20, 5, '2023-02-20'),
('Chocolate Finger Cookies', 3, '340156789234', 110.25, 95.40, 14, 2, '2023-03-01'),
('Sub Woofer 300Hz', 8, '567890142345', 1000.10, 9000.60, 4, 3, '2023-03-04'),
('Dreamers Vanilla Ice Cream', 4, '560123457896', 230.50, 189.00, 40, 1, '2023-03-04');


-- Insert sample employees
INSERT INTO Employees (first_name, last_name, position, hire_date, salary, phone, email) VALUES
('David', 'Wilson', 'Store Manager', '2022-05-10', 28000.00, '555-2001', 'david@supermarket.com'),
('Emily', 'Davis', 'Cashier', '2023-01-15', 15000.00, '555-2002', 'emily@supermarket.com'),
('Robert', 'Johnson', 'Stock Clerk', '2023-02-01', 19000.00, '555-2003', 'robert@supermarket.com');
INSERT INTO Employees (first_name, last_name, position, hire_date, salary, phone, email) VALUES
('Samuel', 'Wangui', 'Package', '2022-05-10', 13000.00, '555-2001', 'wnguisamuel1990@gmail.com'),
('Samatha', 'Muremi', 'Cashier', '2023-01-15', 15000.00, '555-2002', 'sam@supermarket.com'),
('Daniel', 'Johnson', 'shelf Manager', '2023-02-01', 13000.00, '555-2003', 'robert@supermarket.com'),
('Victor', 'Muchoki', 'Shelf Manager', '2022-05-10', 13000.00, '555-2001', 'vicktor@supermarket.com'),
('Monica', 'Wangui', 'Cashier', '2023-01-15', 15000.00, '555-2002', 'monica@supermarket.com'),
('Rose Mary', 'Njoroge', 'Package', '2023-02-01', 13000.00, '555-2003', 'rosemary@supermarket.com');


-- Insert sample customers
INSERT INTO Customers (first_name, last_name, phone, email, join_date, loyalty_points) VALUES
('Alice', 'Brown', '555-3001', 'alice@email.com', '2023-01-20', 150),
('Brian', 'Taylor', '555-3002', 'brian@email.com', '2023-02-15', 75);

-- Insert sample sales
INSERT INTO Sales (transaction_date, employee_id, customer_id, total_amount, payment_method) VALUES
('2023-03-01 10:15:32', 5, 1, 1300.90, 'Credit Card'),
('2023-03-01 11:30:45', 2, NULL, 579.95, 'Cash'),
('2023-03-01 14:20:10', 8, NULL, 220.45, 'M-pesa');

INSERT INTO Sales (transaction_date, employee_id, customer_id, total_amount,payment_method) VALUES
('2023-03-02 10:59:02', 2, NULL, 1300.20, 'Cash'),
('2023-03-02 15:32:12', 2, NULL, 45730.20, 'M-pesa'),
('2023-03-03 13:27:42', 8, 1, 400.10, 'Credit Card'),
('2023-03-04 09:37:10', 2, 2, 720.30, 'Credit Card'),
('2023-03-04 13:50:47', 5, NULL, 240.31, 'Cash'),
('2023-03-04 14:02:19', 8, 2, 1320.30, 'Credit Card'),
('2023-03-05 13:49:29', 2, NULL, 12300.90, 'Cash'),
('2023-03-05 15:13:05', 8, NULL, 2900.35, 'M-pesa'),
('2023-03-06 10:03:01', 8, NULL, 3790.50, 'M-pesa');

INSERT INTO Sales (transaction_date, employee_id, customer_id, total_amount,payment_method) VALUES
('2023-03-06 11:37:02', 2, NULL, 550.30, 'Cash'),
('2023-03-06 15:21:12', 5, NULL, 450.43, 'Cash'),
('2023-03-07 10:42:12', 8, 1, 200.32, 'Credit Card'),
('2023-03-07 12:37:10', 5, NULL, 120.30, 'M-pesa'),
('2023-03-08 10:40:23', 8, NULL, 900.31, 'Cash'),
('2023-03-08 14:32:19', 2, 2, 10000, 'Credit Card'),
('2023-03-09 13:59:29', 5, NULL, 675.32, 'Cash'),
('2023-03-09 15:13:05', 2, NULL, 800.42, 'M-pesa'),
('2023-03-10 10:53:01', 8, NULL, 340.32, 'M-pesa');

UPDATE sales
SET payment_method = 'Credit Card'
WHERE sale_id = 102;

SELECT * FROM employees;
UPDATE sales
SET employee_id = 5, total_amount = 1300.20, payment_method = "Credit Card"
WHERE sale_id = 1;

-- Insert sample sale items
INSERT INTO SaleItems (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 2, 105.15, 310.30),
(1, 2, 1, 65.00, 65.00),
(1, 3, 3, 40.25, 120.75),
(1, 5, 1, 100.50, 100.50),
(2, 3, 6, 30.25, 181.50),
(3, 4, 2, 400.50, 801.00),
(3, 18, 1, 30000.25, 30000.25),
(3, 20, 1, 100.50, 100.50);

SELECT * FROM saleitems;
UPDATE saleitems
SET product_id = 20, unit_price = 100.50, subtotal = 100.50
WHERE sale_item_id = 8;

-- Insert sample inventory movements
INSERT INTO InventoryMovements (product_id, movement_type, quantity, movement_date, reference_id) VALUES
(1, 'Sale', -2, '2023-03-01 10:15:32', 1),
(2, 'Sale', -1, '2023-03-01 10:15:32', 1),
(3, 'Sale', -3, '2023-03-01 10:15:32', 1),
(5, 'Sale', -1, '2023-03-01 10:15:32', 1),
(3, 'Sale', -6, '2023-03-01 11:30:45', 2),
(4, 'Sale', -2, '2023-03-01 14:20:10', 3),
(1, 'Sale', -1, '2023-03-01 14:20:10', 3),
(2, 'Sale', -1, '2023-03-01 14:20:10', 3);

--Useful Queries

--Query the databases to retrieve total sales of a particular date
SELECT 
    DATE(transaction_date) AS sale_date,
    COUNT(total_amount) AS total_sales
FROM 
    Sales
WHERE 
    DATE(transaction_date) BETWEEN '2023-03-01' AND '2023-03-06'
GROUP BY 
    DATE(transaction_date)
ORDER BY 
    sale_date;

-- Query the database to sum the customer's sales and group them
SELECT 
    c.customer_id,
    c.first_name,
    COUNT(s.sale_id) AS number_of_purchases,
    SUM(s.total_amount) AS total_spent,
    AVG(s.total_amount) AS average_purchase,
    MAX(s.transaction_date) AS last_purchase_date
FROM 
    Customers c
LEFT JOIN 
    Sales s ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id, c.customer_name
ORDER BY 
    total_spent DESC;

SELECT 
    c.customer_id,
    c.customer_name,
    s.payment_method,
    SUM(s.total_amount) AS total_spent,
    COUNT(s.sale_id) AS transaction_count
FROM 
    Customers c
JOIN 
    Sales s ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id, c.customer_name, s.payment_method
ORDER BY 
    c.customer_name, total_spent DESC;

SELECT 
    c.customer_id,
    c.customer_name,
    DATE_FORMAT(s.transaction_date, '%Y-%m') AS month,
    SUM(s.total_amount) AS monthly_spent
FROM 
    Customers c
JOIN 
    Sales s ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id, c.customer_name, DATE_FORMAT(s.transaction_date, '%Y-%m')
ORDER BY 
    c.customer_name, month;

SELECT 
    c.customer_id,
    c.customer_name,
    SUM(s.total_amount) AS lifetime_value,
    COUNT(s.sale_id) AS total_orders,
    SUM(s.total_amount) / COUNT(s.sale_id) AS avg_order_value
FROM 
    Customers c
JOIN 
    Sales s ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id, c.customer_name
ORDER BY 
    lifetime_value DESC
LIMIT 10;

SELECT 
    c.customer_id,
    c.customer_name,
    SUM(s.total_amount) AS gross_sales,
    SUM(s.discount_amount) AS total_discounts,
    SUM(s.total_amount - s.discount_amount) AS net_sales,
    (SUM(s.discount_amount) / SUM(s.total_amount)) * 100 AS discount_percentage
FROM 
    Customers c
JOIN 
    Sales s ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id, c.customer_name
HAVING 
    SUM(s.total_amount) > 0
ORDER BY 
    net_sales DESC;

-- Query the Database to retrieve information on the least item by quantity
SELECT 
    p.product_id,
    p.product_name,
    SUM(si.quantity) AS total_quantity_sold
FROM 
    Products p
JOIN 
    Sale_Items si ON p.product_id = si.product_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_quantity_sold ASC
LIMIT 1;

-- Top 5
SELECT 
    p.product_id,
    p.product_name,
    SUM(si.quantity) AS total_quantity_sold,
    COUNT(DISTINCT s.sale_id) AS times_ordered
FROM 
    Products p
JOIN 
    Sale_Items si ON p.product_id = si.product_id
JOIN 
    Sales s ON si.sale_id = s.sale_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_quantity_sold ASC
LIMIT 5;

-- Least sold items with zero sales
SELECT 
    p.product_id,
    p.product_name,
    0 AS total_quantity_sold
FROM 
    Products p
LEFT JOIN 
    Sale_Items si ON p.product_id = si.product_id
WHERE 
    si.product_id IS NULL
UNION
SELECT 
    p.product_id,
    p.product_name,
    SUM(si.quantity) AS total_quantity_sold
FROM 
    Products p
JOIN 
    Sale_Items si ON p.product_id = si.product_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_quantity_sold ASC;

-- Least sold items by category
SELECT 
    c.category_name,
    p.product_name,
    SUM(si.quantity) AS total_quantity_sold
FROM 
    Products p
JOIN 
    Categories c ON p.category_id = c.category_id
JOIN 
    Sale_Items si ON p.product_id = si.product_id
GROUP BY 
    c.category_name, p.product_name
ORDER BY 
    c.category_name, total_quantity_sold ASC;

-- Least sold items with time filter
SELECT 
    p.product_id,
    p.product_name,
    SUM(si.quantity) AS total_quantity_sold
FROM 
    Products p
JOIN 
    Sale_Items si ON p.product_id = si.product_id
JOIN 
    Sales s ON si.sale_id = s.sale_id
WHERE 
    s.transaction_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_quantity_sold ASC
LIMIT 10;

-- Query the Database to display the amount of cost price stock is in stores
SELECT 
    p.product_id,
    p.product_name,
    p.quantity_in_stock,
    p.unit_cost,
    p.unit_price,
    (p.unit_price - p.unit_cost) AS unit_profit,
    (p.quantity_in_stock * (p.unit_price - p.unit_cost)) AS total_profit_in_stock
FROM 
    Products p
ORDER BY 
    total_profit_in_stock DESC;

-- Query the Database to display the amount of profit from the stock

-- Query the Database to display the products that were supplies in a certain date
SELECT 
    p.product_id,
    p.product_name,
    s.supplier_name,
    sp.supply_date,
    sp.quantity_supplied,
    sp.unit_cost
FROM 
    Products p
JOIN 
    Supply sp ON p.product_id = sp.product_id
JOIN 
    Suppliers s ON sp.supplier_id = s.supplier_id
WHERE 
    DATE(sp.supply_date) = '2023-11-15'  -- Replace with your target date
ORDER BY 
    sp.supply_date;

SELECT p.product_name, 
       SUM(si.quantity) AS total_quantity,
       SUM(si.subtotal) AS total_revenue
FROM SaleItems si
JOIN Products p ON si.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;


SELECT e.employee_id, 
       CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
       COUNT(s.sale_id) AS transactions_processed,
       SUM(s.total_amount) AS total_sales
FROM Sales s
JOIN Employees e ON s.employee_id = e.employee_id
GROUP BY e.employee_id, employee_name
ORDER BY total_sales DESC;

SELECT product_id, product_name, quantity_in_stock, reorder_level
FROM Products
WHERE quantity_in_stock <= reorder_level
AND is_active = TRUE;

SELECT c.customer_id, 
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(s.sale_id) AS total_visits,
       SUM(s.total_amount) AS total_spent
FROM Customers c
LEFT JOIN Sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC;

SELECT * FROM saleitems;

-- Query the database to retrive the total quantity of items sold and group the by product_id