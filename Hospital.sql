CREATE DATABASE HospitalDB;
USE HospitalDB;

-- Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    address VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    blood_type VARCHAR(5),
    insurance_provider VARCHAR(50),
    insurance_number VARCHAR(50)
);

-- Doctors table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE,
    license_number VARCHAR(50) UNIQUE,
    hire_date DATE NOT NULL,
    salary DECIMAL(12,2)
);

-- Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL,
    head_doctor_id INT,
    location VARCHAR(50),
    FOREIGN KEY (head_doctor_id) REFERENCES Doctors(doctor_id)
);

-- Staff table (nurses, technicians, etc.)
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL,
    department_id INT,
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Appointments table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    purpose VARCHAR(200),
    status VARCHAR(20) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')),
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Rooms table
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    department_id INT,
    capacity INT,
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Occupied', 'Maintenance')),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Admissions table
CREATE TABLE Admissions (
    admission_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    admitting_doctor_id INT NOT NULL,
    room_id INT,
    admission_date DATETIME NOT NULL,
    discharge_date DATETIME,
    diagnosis VARCHAR(200),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (admitting_doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

-- Treatments table
CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY AUTO_INCREMENT,
    treatment_name VARCHAR(100) NOT NULL,
    description TEXT,
    cost DECIMAL(10,2) NOT NULL
);

-- Patient_Treatments table (junction table)
CREATE TABLE Patient_Treatments (
    patient_treatment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    treatment_id INT NOT NULL,
    doctor_id INT NOT NULL,
    treatment_date DATETIME NOT NULL,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Medications table
CREATE TABLE Medications (
    medication_id INT PRIMARY KEY AUTO_INCREMENT,
    medication_name VARCHAR(100) NOT NULL,
    description TEXT,
    manufacturer VARCHAR(100),
    cost_per_unit DECIMAL(10,2) NOT NULL
);

-- Prescriptions table
CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    medication_id INT NOT NULL,
    prescription_date DATE NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (medication_id) REFERENCES Medications(medication_id)
);

-- Billing table
CREATE TABLE Billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    admission_id INT,
    total_amount DECIMAL(12,2) NOT NULL,
    paid_amount DECIMAL(12,2) DEFAULT 0,
    billing_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Paid', 'Partial', 'Overdue')),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (admission_id) REFERENCES Admissions(admission_id)
);


--Insertion 
-- Insert sample patients
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, phone, email, insurance_provider)
VALUES
('John', 'Doe', '1985-07-15', 'M', '555-1234', 'john.doe@email.com', 'Blue Cross'),
('Jane', 'Smith', '1990-03-22', 'F', '555-5678', 'jane.smith@email.com', 'Aetna'),
('Robert', 'Johnson', '1978-11-05', 'M', '555-9012', 'robert.j@email.com', 'Medicare');

-- Insert sample doctors
INSERT INTO Doctors (first_name, last_name, specialization, phone, email, license_number, hire_date, salary)
VALUES
('Emily', 'Williams', 'Cardiology', '555-3456', 'emily.w@hospital.com', 'MD12345', '2015-06-10', 250000.00),
('Michael', 'Brown', 'Neurology', '555-7890', 'michael.b@hospital.com', 'MD67890', '2018-02-15', 220000.00),
('Sarah', 'Davis', 'Pediatrics', '555-2345', 'sarah.d@hospital.com', 'MD54321', '2019-07-20', 190000.00);

-- Insert departments
INSERT INTO Departments (department_name, head_doctor_id, location)
VALUES
('Cardiology', 1, 'Floor 1, West Wing'),
('Neurology', 2, 'Floor 2, East Wing'),
('Pediatrics', 3, 'Floor 1, East Wing');

-- Insert staff
INSERT INTO Staff (first_name, last_name, role, department_id, phone, hire_date, salary)
VALUES
('Lisa', 'Wilson', 'Head Nurse', 1, '555-1122', '2016-05-12', 85000.00),
('David', 'Miller', 'Lab Technician', 2, '555-3344', '2019-08-10', 65000.00),
('Amy', 'Taylor', 'Nurse', 3, '555-5566', '2020-01-15', 75000.00);

-- Insert rooms
INSERT INTO Rooms (room_number, room_type, department_id, capacity)
VALUES
('101A', 'Patient Room', 1, 2),
('201B', 'Patient Room', 2, 1),
('102C', 'Examination Room', 3, 1);

-- Insert appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, purpose)
VALUES
(1, 1, '2023-06-15 10:00:00', 'Annual heart checkup'),
(2, 2, '2023-06-16 14:30:00', 'Headache consultation'),
(3, 3, '2023-06-17 09:15:00', 'Child vaccination');

-- Insert treatments
INSERT INTO Treatments (treatment_name, description, cost)
VALUES
('Echocardiogram', 'Ultrasound of the heart', 1200.00),
('MRI Scan', 'Magnetic resonance imaging', 2500.00),
('Vaccination', 'Standard immunization', 150.00);

-- Insert medications
INSERT INTO Medications (medication_name, description, manufacturer, cost_per_unit)
VALUES
('Lipitor', 'Cholesterol medication', 'Pfizer', 5.50),
('Neurontin', 'Nerve pain medication', 'Pfizer', 8.75),
('Amoxicillin', 'Antibiotic', 'GSK', 3.20);

-- Insert admissions
INSERT INTO Admissions (patient_id, admitting_doctor_id, room_id, admission_date, diagnosis)
VALUES
(1, 1, 1, '2023-06-10 08:00:00', 'Heart arrhythmia'),
(2, 2, 2, '2023-06-11 10:30:00', 'Severe migraine');

-- Insert patient treatments
INSERT INTO Patient_Treatments (patient_id, treatment_id, doctor_id, treatment_date)
VALUES
(1, 1, 1, '2023-06-10 09:00:00'),
(2, 2, 2, '2023-06-11 11:00:00');

-- Insert prescriptions
INSERT INTO Prescriptions (patient_id, doctor_id, medication_id, prescription_date, dosage, frequency, duration)
VALUES
(1, 1, 1, '2023-06-15', '10mg', 'Once daily', '30 days'),
(2, 2, 2, '2023-06-16', '300mg', 'Twice daily', '14 days');

-- Insert billing records
INSERT INTO Billing (patient_id, admission_id, total_amount, billing_date, due_date)
VALUES
(1, 1, 3500.00, '2023-06-12', '2023-07-12'),
(2, 2, 4200.00, '2023-06-13', '2023-07-13');

--Queries
-- List all patients with their doctors
SELECT p.first_name, p.last_name, d.first_name AS doctor_first, d.last_name AS doctor_last
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

-- Find available rooms
SELECT room_number, room_type 
FROM Rooms 
WHERE status = 'Available';

-- Count patients by gender
SELECT gender, COUNT(*) AS patient_count
FROM Patients
GROUP BY gender;

-- Average treatment cost by department
SELECT d.department_name, AVG(t.cost) AS avg_treatment_cost
FROM Treatments t
JOIN Patient_Treatments pt ON t.treatment_id = pt.treatment_id
JOIN Doctors doc ON pt.doctor_id = doc.doctor_id
JOIN Departments d ON doc.department_id = d.department_id
GROUP BY d.department_name;

-- Patients with their prescribed medications
SELECT p.first_name, p.last_name, m.medication_name, pr.dosage, pr.frequency
FROM Patients p
JOIN Prescriptions pr ON p.patient_id = pr.patient_id
JOIN Medications m ON pr.medication_id = m.medication_id;

-- Doctors and their patient load
SELECT d.first_name, d.last_name, 
       COUNT(DISTINCT a.patient_id) AS num_patients,
       COUNT(DISTINCT ad.admission_id) AS num_admissions
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN Admissions ad ON d.doctor_id = ad.admitting_doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;

-- Current in-patients
SELECT p.first_name, p.last_name, r.room_number, 
       d.first_name AS doctor_first, d.last_name AS doctor_last,
       ad.admission_date, ad.diagnosis
FROM Admissions ad
JOIN Patients p ON ad.patient_id = p.patient_id
JOIN Doctors d ON ad.admitting_doctor_id = d.doctor_id
JOIN Rooms r ON ad.room_id = r.room_id
WHERE ad.discharge_date IS NULL;

-- Pending bills
SELECT p.first_name, p.last_name, b.total_amount, 
       b.paid_amount, (b.total_amount - b.paid_amount) AS balance,
       b.due_date
FROM Billing b
JOIN Patients p ON b.patient_id = p.patient_id
WHERE b.status != 'Paid';
