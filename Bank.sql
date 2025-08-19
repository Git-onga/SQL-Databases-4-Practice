-- Create Database
CREATE DATABASE BankingSystem;
USE BankingSystem;

-- 1. Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE NOT NULL,
    ssn VARCHAR(11) UNIQUE NOT NULL,
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') DEFAULT 'ACTIVE'
);

-- 2. Accounts Table
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    account_type ENUM('CHECKING', 'SAVINGS', 'BUSINESS', 'LOAN', 'CREDIT_CARD') NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    interest_rate DECIMAL(5, 4) DEFAULT 0.0,
    opening_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVE', 'CLOSED', 'FROZEN', 'DORMANT') DEFAULT 'ACTIVE',
    overdraft_limit DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- 3. Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    transaction_type ENUM('DEPOSIT', 'WITHDRAWAL', 'TRANSFER', 'PAYMENT', 'FEE') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    description VARCHAR(255),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    balance_after DECIMAL(15, 2) NOT NULL,
    status ENUM('COMPLETED', 'PENDING', 'FAILED', 'CANCELLED') DEFAULT 'COMPLETED',
    related_account_id INT NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id) ON DELETE CASCADE,
    FOREIGN KEY (related_account_id) REFERENCES Accounts(account_id) ON DELETE SET NULL
);

-- 4. Employees Table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'TERMINATED') DEFAULT 'ACTIVE'
);

-- 5. Loans Table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    account_id INT NOT NULL,
    loan_type ENUM('PERSONAL', 'MORTGAGE', 'AUTO', 'BUSINESS') NOT NULL,
    loan_amount DECIMAL(15, 2) NOT NULL,
    interest_rate DECIMAL(5, 4) NOT NULL,
    term_months INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    monthly_payment DECIMAL(10, 2) NOT NULL,
    remaining_balance DECIMAL(15, 2) NOT NULL,
    status ENUM('ACTIVE', 'PAID_OFF', 'DEFAULTED', 'IN_GRACE_PERIOD') DEFAULT 'ACTIVE',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id) ON DELETE CASCADE
);

-- 6. CreditCards Table
CREATE TABLE CreditCards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    account_id INT NOT NULL,
    card_number VARCHAR(20) UNIQUE NOT NULL,
    expiration_date DATE NOT NULL,
    cvv VARCHAR(4) NOT NULL,
    credit_limit DECIMAL(10, 2) NOT NULL,
    available_credit DECIMAL(10, 2) NOT NULL,
    annual_fee DECIMAL(6, 2) DEFAULT 0.00,
    status ENUM('ACTIVE', 'INACTIVE', 'LOST', 'STOLEN', 'EXPIRED') DEFAULT 'ACTIVE',
    issue_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id) ON DELETE CASCADE
);

-- 7. Branches Table
CREATE TABLE Branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    phone VARCHAR(20),
    manager_id INT,
    opening_date DATE NOT NULL,
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id) ON DELETE SET NULL
);

-- 8. CustomerSupport Table
CREATE TABLE CustomerSupport (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    employee_id INT,
    issue_type VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') DEFAULT 'OPEN',
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_date TIMESTAMP NULL,
    resolution_notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) ON DELETE SET NULL
);

-- 9. AuditLog Table
CREATE TABLE AuditLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_values JSON,
    new_values JSON,
    changed_by VARCHAR(100),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Indexes for better performance
CREATE INDEX idx_customers_email ON Customers(email);
CREATE INDEX idx_accounts_customer ON Accounts(customer_id);
CREATE INDEX idx_accounts_number ON Accounts(account_number);
CREATE INDEX idx_transactions_account ON Transactions(account_id);
CREATE INDEX idx_transactions_date ON Transactions(transaction_date);
CREATE INDEX idx_loans_customer ON Loans(customer_id);
CREATE INDEX idx_credit_cards_customer ON CreditCards(customer_id);

-- Insert Sample Data
INSERT INTO Customers (first_name, last_name, email, phone, date_of_birth, ssn, address, city, state, zip_code) VALUES
('John', 'Doe', 'john.doe@email.com', '555-0101', '1985-03-15', '123-45-6789', '123 Main St', 'New York', 'NY', '10001'),
('Jane', 'Smith', 'jane.smith@email.com', '555-0102', '1990-07-22', '987-65-4321', '456 Oak Ave', 'Los Angeles', 'CA', '90001'),
('Mike', 'Johnson', 'mike.johnson@email.com', '555-0103', '1988-12-05', '456-78-9123', '789 Pine Rd', 'Chicago', 'IL', '60601');

INSERT INTO Accounts (customer_id, account_number, account_type, balance, interest_rate) VALUES
(1, 'CHK10001', 'CHECKING', 2500.00, 0.01),
(1, 'SAV10001', 'SAVINGS', 15000.00, 0.025),
(2, 'CHK20001', 'CHECKING', 3500.00, 0.01),
(2, 'SAV20001', 'SAVINGS', 25000.00, 0.025),
(3, 'CHK30001', 'CHECKING', 5000.00, 0.01);

INSERT INTO Transactions (account_id, transaction_type, amount, description, balance_after) VALUES
(1, 'DEPOSIT', 1000.00, 'Initial deposit', 1000.00),
(1, 'DEPOSIT', 1500.00, 'Paycheck deposit', 2500.00),
(2, 'DEPOSIT', 15000.00, 'Savings transfer', 15000.00),
(3, 'DEPOSIT', 3500.00, 'Account opening', 3500.00);

INSERT INTO Employees (first_name, last_name, email, phone, position, department, salary, hire_date) VALUES
('Sarah', 'Wilson', 'sarah.wilson@bank.com', '555-0201', 'Branch Manager', 'Management', 75000.00, '2020-01-15'),
('David', 'Brown', 'david.brown@bank.com', '555-0202', 'Loan Officer', 'Lending', 60000.00, '2021-03-10'),
('Emily', 'Davis', 'emily.davis@bank.com', '555-0203', 'Teller', 'Operations', 45000.00, '2022-06-01');

INSERT INTO Branches (branch_name, address, city, state, zip_code, phone, manager_id, opening_date) VALUES
('Main Street Branch', '123 Main St', 'New York', 'NY', '10001', '555-0301', 1, '2010-05-15'),
('Downtown Branch', '456 Downtown Ave', 'Los Angeles', 'CA', '90001', '555-0302', NULL, '2015-08-20');

-- Useful Views
CREATE VIEW CustomerAccountSummary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(a.account_id) as total_accounts,
    SUM(a.balance) as total_balance,
    MAX(a.opening_date) as latest_account_date
FROM Customers c
LEFT JOIN Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

CREATE VIEW MonthlyTransactionSummary AS
SELECT
    a.account_id,
    a.account_number,
    c.first_name,
    c.last_name,
    YEAR(t.transaction_date) as year,
    MONTH(t.transaction_date) as month,
    COUNT(t.transaction_id) as transaction_count,
    SUM(CASE WHEN t.transaction_type = 'DEPOSIT' THEN t.amount ELSE 0 END) as total_deposits,
    SUM(CASE WHEN t.transaction_type = 'WITHDRAWAL' THEN t.amount ELSE 0 END) as total_withdrawals
FROM Accounts a
JOIN Customers c ON a.customer_id = c.customer_id
LEFT JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_number, c.first_name, c.last_name, YEAR(t.transaction_date), MONTH(t.transaction_date);

-- Stored Procedures
DELIMITER //

CREATE PROCEDURE TransferFunds(
    IN from_account INT,
    IN to_account INT,
    IN transfer_amount DECIMAL(15, 2),
    IN description VARCHAR(255)
)
BEGIN
    DECLARE from_balance DECIMAL(15, 2);
    DECLARE to_balance DECIMAL(15, 2);
    
    START TRANSACTION;
    
    -- Get current balances
    SELECT balance INTO from_balance FROM Accounts WHERE account_id = from_account FOR UPDATE;
    SELECT balance INTO to_balance FROM Accounts WHERE account_id = to_account FOR UPDATE;
    
    -- Check if sufficient funds
    IF from_balance >= transfer_amount THEN
        -- Update from account
        UPDATE Accounts SET balance = balance - transfer_amount WHERE account_id = from_account;
        
        -- Record withdrawal transaction
        INSERT INTO Transactions (account_id, transaction_type, amount, description, balance_after)
        VALUES (from_account, 'WITHDRAWAL', transfer_amount, description, from_balance - transfer_amount);
        
        -- Update to account
        UPDATE Accounts SET balance = balance + transfer_amount WHERE account_id = to_account;
        
        -- Record deposit transaction
        INSERT INTO Transactions (account_id, transaction_type, amount, description, balance_after, related_account_id)
        VALUES (to_account, 'DEPOSIT', transfer_amount, description, to_balance + transfer_amount, from_account);
        
        COMMIT;
        SELECT 'SUCCESS' as result;
    ELSE
        ROLLBACK;
        SELECT 'INSUFFICIENT_FUNDS' as result;
    END IF;
END //

CREATE PROCEDURE GetCustomerTransactions(IN cust_id INT, IN days_back INT)
BEGIN
    SELECT 
        t.transaction_id,
        t.transaction_type,
        t.amount,
        t.description,
        t.transaction_date,
        t.balance_after,
        a.account_number,
        a.account_type
    FROM Transactions t
    JOIN Accounts a ON t.account_id = a.account_id
    WHERE a.customer_id = cust_id
    AND t.transaction_date >= DATE_SUB(NOW(), INTERVAL days_back DAY)
    ORDER BY t.transaction_date DESC;
END //

DELIMITER ;
