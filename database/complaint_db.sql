-- =============================================
-- Complaint Tracking System - Database Schema
-- =============================================

CREATE DATABASE IF NOT EXISTS complaint_db;
USE complaint_db;

-- 1. Users Table (Students / Citizens / Employees)
CREATE TABLE IF NOT EXISTS users (
    user_id    INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    password   VARCHAR(255) NOT NULL,
    phone      VARCHAR(15),
    role       ENUM('user','admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Departments Table
CREATE TABLE IF NOT EXISTS departments (
    dept_id   INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    dept_head VARCHAR(100)
);

-- 3. Complaints Table
CREATE TABLE IF NOT EXISTS complaints (
    complaint_id  INT PRIMARY KEY AUTO_INCREMENT,
    user_id       INT NOT NULL,
    dept_id       INT,
    title         VARCHAR(200) NOT NULL,
    description   TEXT NOT NULL,
    category      ENUM('Infrastructure','Academic','Administration','Technical','Other') NOT NULL,
    priority      ENUM('Low','Medium','High','Critical') DEFAULT 'Medium',
    status        ENUM('Open','In Progress','Resolved','Closed','Rejected') DEFAULT 'Open',
    assigned_to   VARCHAR(100),
    admin_remarks TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at   TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 4. Complaint Timeline Table (tracks every status change)
CREATE TABLE IF NOT EXISTS complaint_timeline (
    timeline_id  INT PRIMARY KEY AUTO_INCREMENT,
    complaint_id INT NOT NULL,
    changed_by   VARCHAR(100),
    old_status   VARCHAR(50),
    new_status   VARCHAR(50),
    remarks      TEXT,
    changed_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id)
);

-- =============================================
-- Sample Data
-- =============================================

-- Admin user (password: admin123)
INSERT INTO users (name, email, password, phone, role) VALUES
('Admin User',    'admin@complaint.com', 'admin123',  '9000000001', 'admin'),
('Rahul Sharma',  'rahul@email.com',     'user123',   '9876543210', 'user'),
('Priya Patel',   'priya@email.com',     'user123',   '9123456780', 'user'),
('Amit Desai',    'amit@email.com',      'user123',   '9988776655', 'user');

INSERT INTO departments (dept_name, dept_head) VALUES
('Infrastructure', 'Mr. Patil'),
('Academic Affairs', 'Dr. Mehta'),
('Administration', 'Mrs. Joshi'),
('IT Department', 'Mr. Kulkarni'),
('General', 'Mr. Singh');

INSERT INTO complaints (user_id, dept_id, title, description, category, priority, status, assigned_to) VALUES
(2, 1, 'Broken lights in corridor', 'The lights in Block B corridor have been broken for 2 weeks.', 'Infrastructure', 'High',   'Open',        NULL),
(3, 4, 'Internet not working in lab', 'WiFi is down in Computer Lab 3 since Monday morning.', 'Technical',      'Critical','In Progress', 'Mr. Kulkarni'),
(4, 2, 'Exam schedule not published', 'Semester exam schedule has not been uploaded on portal.', 'Academic',       'Medium',  'Resolved',    'Dr. Mehta');
