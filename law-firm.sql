-- Create the database
CREATE DATABASE law_firm_db;
USE law_firm_db;

-- Table for storing law firm information
CREATE TABLE firm (
    firm_id INT PRIMARY KEY AUTO_INCREMENT,
    firm_name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    established_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for employees (lawyers and staff)
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    hire_date DATE NOT NULL,
    position ENUM('Partner', 'Associate', 'Paralegal', 'Legal Assistant', 'Administrative', 'IT', 'HR') NOT NULL,
    specialization VARCHAR(255),
    hourly_rate DECIMAL(10,2),
    status ENUM('Active', 'Inactive', 'Leave') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for clients
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    company_name VARCHAR(255),
    client_type ENUM('Individual', 'Corporate') DEFAULT 'Individual',
    status ENUM('Active', 'Inactive', 'Prospective') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for cases/matters
CREATE TABLE cases (
    case_id INT PRIMARY KEY AUTO_INCREMENT,
    case_number VARCHAR(50) UNIQUE NOT NULL,
    case_name VARCHAR(255) NOT NULL,
    description TEXT,
    case_type ENUM('Criminal', 'Civil', 'Family', 'Corporate', 'Real Estate', 'Intellectual Property', 'Other') NOT NULL,
    status ENUM('Open', 'Closed', 'Pending', 'Settled', 'Trial') DEFAULT 'Open',
    opening_date DATE NOT NULL,
    closing_date DATE NULL,
    client_id INT NOT NULL,
    assigned_lawyer_id INT NOT NULL,
    billing_method ENUM('Hourly', 'Flat Fee', 'Contingency', 'Retainer') DEFAULT 'Hourly',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_lawyer_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- Table for time entries (tracking billable hours)
CREATE TABLE time_entries (
    time_entry_id INT PRIMARY KEY AUTO_INCREMENT,
    case_id INT NOT NULL,
    employee_id INT NOT NULL,
    date_worked DATE NOT NULL,
    hours_worked DECIMAL(5,2) NOT NULL,
    description TEXT NOT NULL,
    billing_rate DECIMAL(10,2) NOT NULL,
    billed_amount DECIMAL(10,2) GENERATED ALWAYS AS (hours_worked * billing_rate) STORED,
    billed_status ENUM('Unbilled', 'Billed', 'Paid') DEFAULT 'Unbilled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- Table for expenses
CREATE TABLE expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    case_id INT NOT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    expense_date DATE NOT NULL,
    category ENUM('Filing Fees', 'Travel', 'Research', 'Copying', 'Expert Witness', 'Other') DEFAULT 'Other',
    status ENUM('Unbilled', 'Billed', 'Paid') DEFAULT 'Unbilled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
);

-- Table for invoices
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    case_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('Draft', 'Sent', 'Partial', 'Paid', 'Overdue') DEFAULT 'Draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
);

-- Table for invoice items (linking time entries and expenses to invoices)
CREATE TABLE invoice_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT NOT NULL,
    time_entry_id INT NULL,
    expense_id INT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE CASCADE,
    FOREIGN KEY (time_entry_id) REFERENCES time_entries(time_entry_id) ON DELETE SET NULL,
    FOREIGN KEY (expense_id) REFERENCES expenses(expense_id) ON DELETE SET NULL
);

-- Table for documents
CREATE TABLE documents (
    document_id INT PRIMARY KEY AUTO_INCREMENT,
    case_id INT NOT NULL,
    document_name VARCHAR(255) NOT NULL,
    document_type ENUM('Pleading', 'Motion', 'Brief', 'Contract', 'Evidence', 'Correspondence', 'Other') NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    upload_date DATE NOT NULL,
    uploaded_by INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- Table for court information
CREATE TABLE courts (
    court_id INT PRIMARY KEY AUTO_INCREMENT,
    court_name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    jurisdiction VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for case events (hearings, deadlines, etc.)
CREATE TABLE case_events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    case_id INT NOT NULL,
    event_type ENUM('Hearing', 'Deposition', 'Meeting', 'Deadline', 'Trial', 'Other') NOT NULL,
    event_date DATETIME NOT NULL,
    description TEXT,
    location VARCHAR(255),
    court_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE,
    FOREIGN KEY (court_id) REFERENCES courts(court_id) ON DELETE SET NULL
);

-- Table for case participants (opposing counsel, witnesses, etc.)
CREATE TABLE case_participants (
    participant_id INT PRIMARY KEY AUTO_INCREMENT,
    case_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role ENUM('Opposing Counsel', 'Witness', 'Expert', 'Judge', 'Other') NOT NULL,
    contact_info TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO firm (firm_name, address, phone, email, established_date) VALUES
('Smith & Associates Law Firm', '123 Legal Avenue, New York, NY 10001', '(212) 555-0123', 'info@smithlaw.com', '2005-06-15');

INSERT INTO employees (first_name, last_name, email, phone, position, specialization, hourly_rate, hire_date) VALUES
('John', 'Smith', 'john.smith@smithlaw.com', '(212) 555-0101', 'Partner', 'Corporate Law', 350.00, '2005-06-15'),
('Sarah', 'Johnson', 'sarah.johnson@smithlaw.com', '(212) 555-0102', 'Associate', 'Intellectual Property', 250.00, '2010-03-10'),
('Michael', 'Chen', 'michael.chen@smithlaw.com', '(212) 555-0103', 'Associate', 'Criminal Defense', 200.00, '2012-08-22'),
('Emily', 'Davis', 'emily.davis@smithlaw.com', '(212) 555-0104', 'Paralegal', NULL, 85.00, '2015-01-15'),
('David', 'Wilson', 'david.wilson@smithlaw.com', '(212) 555-0105', 'Legal Assistant', NULL, 65.00, '2018-05-01');

INSERT INTO clients (first_name, last_name, email, phone, company_name, client_type) VALUES
('Robert', 'Williams', 'robert@williamsco.com', '(212) 555-0201', 'Williams Corporation', 'Corporate'),
('Jennifer', 'Brown', 'jennifer.brown@email.com', '(212) 555-0202', NULL, 'Individual'),
('Tech', 'Innovations', 'legal@techinnovations.com', '(212) 555-0203', 'Tech Innovations Inc.', 'Corporate');

INSERT INTO cases (case_number, case_name, description, case_type, opening_date, client_id, assigned_lawyer_id, billing_method) VALUES
('2024-CIV-001', 'Williams Corp vs. Competitor', 'Trademark infringement case', 'Intellectual Property', '2024-01-15', 1, 2, 'Hourly'),
('2024-CRIM-001', 'State vs. Jennifer Brown', 'Criminal defense case - theft allegations', 'Criminal', '2024-02-01', 2, 3, 'Flat Fee'),
('2024-CORP-001', 'Tech Innovations Merger', 'Corporate merger advisory services', 'Corporate', '2024-01-20', 3, 1, 'Retainer');

-- Create indexes for better performance
CREATE INDEX idx_cases_client ON cases(client_id);
CREATE INDEX idx_cases_lawyer ON cases(assigned_lawyer_id);
CREATE INDEX idx_time_entries_case ON time_entries(case_id);
CREATE INDEX idx_time_entries_employee ON time_entries(employee_id);
CREATE INDEX idx_invoices_case ON invoices(case_id);
CREATE INDEX idx_documents_case ON documents(case_id);
CREATE INDEX idx_events_case ON case_events(case_id);

-- Create views for common queries
CREATE VIEW active_cases_view AS
SELECT c.case_id, c.case_number, c.case_name, c.case_type, c.status,
       cl.client_id, CONCAT(cl.first_name, ' ', cl.last_name) as client_name,
       e.employee_id, CONCAT(e.first_name, ' ', e.last_name) as assigned_lawyer
FROM cases c
JOIN clients cl ON c.client_id = cl.client_id
JOIN employees e ON c.assigned_lawyer_id = e.employee_id
WHERE c.status = 'Open';

CREATE VIEW unbilled_time_view AS
SELECT te.time_entry_id, c.case_number, c.case_name,
       CONCAT(e.first_name, ' ', e.last_name) as employee,
       te.date_worked, te.hours_worked, te.billed_amount
FROM time_entries te
JOIN cases c ON te.case_id = c.case_id
JOIN employees e ON te.employee_id = e.employee_id
WHERE te.billed_status = 'Unbilled';


-- Get all active cases with client and lawyer information
SELECT * FROM active_cases_view;

-- Calculate total unbilled hours and amount by case
SELECT c.case_number, c.case_name,
       SUM(te.hours_worked) as total_hours,
       SUM(te.billed_amount) as total_amount
FROM time_entries te
JOIN cases c ON te.case_id = c.case_id
WHERE te.billed_status = 'Unbilled'
GROUP BY c.case_id;

-- Get case timeline with events
SELECT c.case_number, ce.event_type, ce.event_date, ce.description
FROM case_events ce
JOIN cases c ON ce.case_id = c.case_id
WHERE c.case_id = 1
ORDER BY ce.event_date;

-- Monthly billing report by lawyer
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) as lawyer,
       MONTH(te.date_worked) as month,
       YEAR(te.date_worked) as year,
       SUM(te.hours_worked) as total_hours,
       SUM(te.billed_amount) as total_amount
FROM time_entries te
JOIN employees e ON te.employee_id = e.employee_id
WHERE te.billed_status = 'Paid'
GROUP BY e.employee_id, YEAR(te.date_worked), MONTH(te.date_worked);
