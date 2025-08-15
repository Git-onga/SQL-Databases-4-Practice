-- Create the database
CREATE DATABASE OrganizationDB;
USE OrganizationDB;

-- Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    budget DECIMAL(12,2),
    established_date DATE
);

-- Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(50),
    salary DECIMAL(10,2),
    department_id INT,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);

-- Projects table
CREATE TABLE Projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Employee Projects (junction table for many-to-many relationship)
CREATE TABLE Employee_Projects (
    employee_id INT,
    project_id INT,
    hours_worked DECIMAL(6,2) DEFAULT 0,
    role VARCHAR(50),
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

-- Skills table
CREATE TABLE Skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Employee Skills (junction table)
CREATE TABLE Employee_Skills (
    employee_id INT,
    skill_id INT,
    proficiency_level VARCHAR(20),
    PRIMARY KEY (employee_id, skill_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (skill_id) REFERENCES Skills(skill_id)
);

-- Offices table
CREATE TABLE Offices (
    office_id INT PRIMARY KEY AUTO_INCREMENT,
    office_name VARCHAR(50) NOT NULL,
    address VARCHAR(200),
    city VARCHAR(50),
    country VARCHAR(50),
    capacity INT
);

-- Department Offices (junction table)
CREATE TABLE Department_Offices (
    department_id INT,
    office_id INT,
    floor_number INT,
    PRIMARY KEY (department_id, office_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (office_id) REFERENCES Offices(office_id)
);

--Data Insertion
-- Insert sample departments
INSERT INTO Departments (department_name, location, budget, established_date)
VALUES 
('Engineering', 'Floor 3', 1000000.00, '2018-01-15'),
('Marketing', 'Floor 2', 750000.00, '2018-03-10'),
('Human Resources', 'Floor 1', 500000.00, '2018-02-01');

-- Insert sample employees
INSERT INTO Employees (first_name, last_name, email, phone, hire_date, job_title, salary, department_id)
VALUES
('John', 'Smith', 'john.smith@company.com', '555-0101', '2019-05-10', 'Senior Engineer', 95000.00, 1),
('Sarah', 'Johnson', 'sarah.johnson@company.com', '555-0102', '2020-02-15', 'Marketing Specialist', 65000.00, 2),
('Michael', 'Williams', 'michael.williams@company.com', '555-0103', '2018-06-20', 'HR Manager', 85000.00, 3);

-- Update manager relationships
UPDATE Employees SET manager_id = 3 WHERE employee_id = 1;
UPDATE Employees SET manager_id = 3 WHERE employee_id = 2;

-- Insert sample projects
INSERT INTO Projects (project_name, description, start_date, end_date, budget, department_id)
VALUES
('Website Redesign', 'Complete overhaul of company website', '2023-01-10', '2023-06-30', 50000.00, 1),
('Product Launch', 'Marketing campaign for new product', '2023-02-01', '2023-05-15', 75000.00, 2);

-- Assign employees to projects
INSERT INTO Employee_Projects (employee_id, project_id, hours_worked, role)
VALUES
(1, 1, 120.5, 'Lead Developer'),
(2, 2, 80.0, 'Campaign Manager');

-- Insert skills
INSERT INTO Skills (skill_name, description)
VALUES
('Java', 'Java programming language'),
('Digital Marketing', 'Online marketing techniques'),
('Recruiting', 'Talent acquisition skills');

-- Assign skills to employees
INSERT INTO Employee_Skills (employee_id, skill_id, proficiency_level)
VALUES
(1, 1, 'Expert'),
(2, 2, 'Advanced'),
(3, 3, 'Expert');

--Basic Queries
-- List all employees with their departments
SELECT e.first_name, e.last_name, d.department_name
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id;

-- Find projects with budgets over $50,000
SELECT project_name, budget
FROM Projects
WHERE budget > 50000;
