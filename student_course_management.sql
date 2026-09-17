CREATE DATABASE IF NOT EXISTS student_course_management;
USE student_course_management;

-- ============================================================
-- 1. TABLE CREATION
-- ============================================================

DROP VIEW IF EXISTS vw_student_departments;
DROP VIEW IF EXISTS vw_course_enrollments;
DROP VIEW IF EXISTS vw_student_course_count;
DROP VIEW IF EXISTS vw_course_instructors_departments;
DROP VIEW IF EXISTS vw_student_course_enrollment;

DROP PROCEDURE IF EXISTS sp_students_in_course;
DROP PROCEDURE IF EXISTS sp_courses_by_department;
DROP PROCEDURE IF EXISTS sp_count_students_by_department;
DROP PROCEDURE IF EXISTS sp_course_details;
DROP PROCEDURE IF EXISTS sp_students_enrolled_after_year;

DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_head VARCHAR(100)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    department_id INT,
    registration_date DATE,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY,
    instructor_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT CHECK (credits > 0),
    department_id INT,
    instructor_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enroll_date DATE,
    semester VARCHAR(20),
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- ============================================================
-- 2. SAMPLE DATA
-- ============================================================

INSERT INTO Departments (department_id, department_name, department_head) VALUES
(1, 'IT', 'Dr. Ramesh'),
(2, 'Computer Science', 'Dr. Suresh'),
(3, 'Electronics', 'Dr. Kavitha'),
(4, 'Mechanical', 'Dr. Anand'),
(5, 'Civil', 'Dr. Mahesh');

INSERT INTO Students (student_id, name, email, phone, department_id, registration_date) VALUES
(101, 'Rahul', 'rahul@example.com', '9000000001', 1, '2023-06-15'),
(102, 'Priya', 'priya@example.com', '9000000002', 2, '2024-01-10'),
(103, 'Arjun', 'arjun@example.com', '9000000003', 1, '2023-08-20'),
(104, 'Sneha', 'sneha@example.com', '9000000004', 2, '2024-02-12'),
(105, 'Kiran', 'kiran@example.com', '9000000005', 3, '2022-07-18'),
(106, 'Anjali', 'anjali@example.com', '9000000006', 1, '2024-03-01'),
(107, 'Vikram', 'vikram@example.com', '9000000007', 4, '2023-09-05'),
(108, 'Meena', 'meena@example.com', '9000000008', 5, '2024-01-25'),
(109, 'Ravi', 'ravi@example.com', '9000000009', 2, '2023-11-11'),
(110, 'Pooja', 'pooja@example.com', '9000000010', 1, '2024-04-10');

INSERT INTO Instructors (instructor_id, instructor_name, email, phone, department_id) VALUES
(201, 'Dr. Sharma', 'sharma@example.com', '9100000001', 1),
(202, 'Dr. Mehta', 'mehta@example.com', '9100000002', 2),
(203, 'Dr. Rao', 'rao@example.com', '9100000003', 3),
(204, 'Dr. Lakshmi', 'lakshmi@example.com', '9100000004', 4),
(205, 'Dr. Prakash', 'prakash@example.com', '9100000005', 2);

INSERT INTO Courses (course_id, course_name, credits, department_id, instructor_id) VALUES
(301, 'Python Programming', 4, 1, 201),
(302, 'Database Management', 4, 2, 202),
(303, 'Web Development', 3, 1, 201),
(304, 'Data Structures', 4, 2, 205),
(305, 'Machine Learning', 5, 2, 205),
(306, 'Computer Networks', 3, 2, 202),
(307, 'Digital Electronics', 4, 3, 203),
(308, 'Mechanical Engineering', 5, 4, 204),
(309, 'Civil Engineering', 4, 5, 204),
(310, 'Artificial Intelligence', 5, 2, 205);

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enroll_date, semester, grade) VALUES
(401, 101, 301, '2024-01-15', '2024-S1', 'A'),
(402, 101, 302, '2024-01-16', '2024-S1', 'B'),
(403, 102, 302, '2024-01-17', '2024-S1', 'A'),
(404, 102, 304, '2024-01-18', '2024-S1', 'A'),
(405, 103, 301, '2024-02-01', '2024-S1', 'B'),
(406, 103, 303, '2024-02-02', '2024-S1', 'A'),
(407, 104, 305, '2024-02-10', '2024-S1', 'A'),
(408, 104, 310, '2024-02-11', '2024-S1', 'A'),
(409, 105, 307, '2023-08-01', '2023-S2', 'B'),
(410, 106, 301, '2024-03-10', '2024-S1', 'A'),
(411, 106, 305, '2024-03-11', '2024-S1', 'B'),
(412, 107, 308, '2024-01-20', '2024-S1', 'A'),
(413, 108, 309, '2024-02-20', '2024-S1', 'B'),
(414, 109, 304, '2024-01-21', '2024-S1', 'A'),
(415, 110, 301, '2024-04-15', '2024-S2', 'A');

-- ============================================================
-- 3. BASIC QUERIES
-- ============================================================

-- 1. Display all courses with credits > 3
SELECT * FROM Courses WHERE credits > 3;

-- 2. List students from IT department
SELECT s.*
FROM Students s
JOIN Departments d ON s.department_id = d.department_id
WHERE d.department_name = 'IT';

-- 3. Show instructors teaching programming courses
SELECT DISTINCT i.*
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id
WHERE c.course_name LIKE '%Programming%';

-- 4. Display students registered after 2023
SELECT * FROM Students
WHERE registration_date >= '2024-01-01';

-- ============================================================
-- 4. JOINS
-- ============================================================

-- 1. Student names + enrolled course names
SELECT s.name AS student_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- 2. Course name + instructor name
SELECT c.course_name, i.instructor_name
FROM Courses c
JOIN Instructors i ON c.instructor_id = i.instructor_id;

-- 3. Enrollment date + student name
SELECT e.enroll_date, s.name AS student_name
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id;

-- 4. Courses + department name
SELECT c.course_name, d.department_name
FROM Courses c
JOIN Departments d ON c.department_id = d.department_id;

-- 5. Students + instructor teaching their course
SELECT DISTINCT s.name AS student_name, i.instructor_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Instructors i ON c.instructor_id = i.instructor_id;

-- ============================================================
-- 5. AGGREGATE FUNCTIONS
-- ============================================================

-- 1. Count total students
SELECT COUNT(*) AS total_students FROM Students;

-- 2. Total courses
SELECT COUNT(*) AS total_courses FROM Courses;

-- 3. Average course credits
SELECT AVG(credits) AS average_course_credits FROM Courses;

-- 4. Count students enrolled in each course
SELECT c.course_name, COUNT(e.student_id) AS total_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- 5. Course with highest enrollments
SELECT c.course_name, COUNT(e.student_id) AS total_enrollments
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_enrollments DESC
LIMIT 1;

-- ============================================================
-- 6. SUBQUERIES
-- ============================================================

-- 1. Students not enrolled in any course
SELECT * FROM Students s
WHERE NOT EXISTS (
    SELECT 1 FROM Enrollments e
    WHERE e.student_id = s.student_id
);

-- 2. Courses with no students enrolled
SELECT * FROM Courses c
WHERE NOT EXISTS (
    SELECT 1 FROM Enrollments e
    WHERE e.course_id = c.course_id
);

-- 3. Students enrolled in more than one course
SELECT s.student_id, s.name
FROM Students s
WHERE (
    SELECT COUNT(*) FROM Enrollments e
    WHERE e.student_id = s.student_id
) > 1;

-- 4. Courses with credits above average
SELECT * FROM Courses
WHERE credits > (SELECT AVG(credits) FROM Courses);

-- 5. Instructors teaching more than one course
SELECT i.instructor_id, i.instructor_name
FROM Instructors i
WHERE (
    SELECT COUNT(*) FROM Courses c
    WHERE c.instructor_id = i.instructor_id
) > 1;

-- ============================================================
-- 7. UPDATES
-- Run these individually when you want to demonstrate UPDATE.
-- ============================================================

-- 1. Update course credits
-- UPDATE Courses SET credits = 5 WHERE course_id = 301;

-- 2. Change instructor department
-- UPDATE Instructors SET department_id = 1 WHERE instructor_id = 202;

-- 3. Update student phone
-- UPDATE Students SET phone = '9999999999' WHERE student_id = 101;

-- ============================================================
-- 8. DELETES
-- Run these individually when you want to demonstrate DELETE.
-- ============================================================

-- 4. Delete courses with no enrollments
-- DELETE FROM Courses
-- WHERE NOT EXISTS (
--     SELECT 1 FROM Enrollments e WHERE e.course_id = Courses.course_id
-- );

-- 5. Delete students who dropped all courses
-- DELETE FROM Students
-- WHERE NOT EXISTS (
--     SELECT 1 FROM Enrollments e WHERE e.student_id = Students.student_id
-- );

-- ============================================================
-- 9. VIEWS
-- ============================================================

CREATE VIEW vw_student_course_enrollment AS
SELECT s.name AS student_name, c.course_name, e.enroll_date
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

CREATE VIEW vw_course_instructors_departments AS
SELECT c.course_name, i.instructor_name, d.department_name
FROM Courses c
JOIN Instructors i ON c.instructor_id = i.instructor_id
JOIN Departments d ON c.department_id = d.department_id;

CREATE VIEW vw_student_course_count AS
SELECT s.student_id, s.name,
       COUNT(e.course_id) AS number_of_courses
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name;

CREATE VIEW vw_course_enrollments AS
SELECT c.course_id, c.course_name,
       COUNT(e.student_id) AS total_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

CREATE VIEW vw_student_departments AS
SELECT s.student_id, s.name, d.department_name
FROM Students s
LEFT JOIN Departments d ON s.department_id = d.department_id;

-- View examples
SELECT * FROM vw_student_course_enrollment;
SELECT * FROM vw_course_instructors_departments;
SELECT * FROM vw_student_course_count;
SELECT * FROM vw_course_enrollments;
SELECT * FROM vw_student_departments;

-- ============================================================
-- 10. STORED PROCEDURES
-- ============================================================

DELIMITER //

CREATE PROCEDURE sp_students_in_course(IN p_course_id INT)
BEGIN
    SELECT s.student_id, s.name, s.email
    FROM Students s
    JOIN Enrollments e ON s.student_id = e.student_id
    WHERE e.course_id = p_course_id;
END //

CREATE PROCEDURE sp_courses_by_department(IN p_department_id INT)
BEGIN
    SELECT course_id, course_name, credits, instructor_id
    FROM Courses
    WHERE department_id = p_department_id;
END //

CREATE PROCEDURE sp_count_students_by_department(IN p_department_id INT)
BEGIN
    SELECT d.department_name,
           COUNT(s.student_id) AS total_students
    FROM Departments d
    LEFT JOIN Students s ON d.department_id = s.department_id
    WHERE d.department_id = p_department_id
    GROUP BY d.department_id, d.department_name;
END //

CREATE PROCEDURE sp_course_details(IN p_course_id INT)
BEGIN
    SELECT c.course_id, c.course_name, c.credits,
           d.department_name, i.instructor_name
    FROM Courses c
    LEFT JOIN Departments d ON c.department_id = d.department_id
    LEFT JOIN Instructors i ON c.instructor_id = i.instructor_id
    WHERE c.course_id = p_course_id;
END //

CREATE PROCEDURE sp_students_enrolled_after_year(IN p_year INT)
BEGIN
    SELECT DISTINCT s.student_id, s.name, s.email, e.enroll_date
    FROM Students s
    JOIN Enrollments e ON s.student_id = e.student_id
    WHERE YEAR(e.enroll_date) > p_year
    ORDER BY e.enroll_date;
END //

DELIMITER ;

-- Procedure examples
CALL sp_students_in_course(301);
CALL sp_courses_by_department(2);
CALL sp_count_students_by_department(1);
CALL sp_course_details(301);
CALL sp_students_enrolled_after_year(2023);

-- ============================================================
-- 11. REPORTS / ANALYSIS
-- ============================================================

-- 1. Top 5 most popular courses
SELECT c.course_name, COUNT(e.student_id) AS total_enrollments
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_enrollments DESC, c.course_name
LIMIT 5;

-- 2. Department with most students
SELECT d.department_name, COUNT(s.student_id) AS total_students
FROM Departments d
LEFT JOIN Students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_students DESC
LIMIT 1;

-- 3. Instructor teaching most courses
SELECT i.instructor_name, COUNT(c.course_id) AS total_courses
FROM Instructors i
LEFT JOIN Courses c ON i.instructor_id = c.instructor_id
GROUP BY i.instructor_id, i.instructor_name
ORDER BY total_courses DESC
LIMIT 1;

-- 4. Student enrollment per semester
SELECT semester, COUNT(*) AS total_enrollments
FROM Enrollments
GROUP BY semester
ORDER BY semester;

-- 5. Top 5 courses with highest credits
SELECT course_name, credits
FROM Courses
ORDER BY credits DESC, course_name
LIMIT 5;

-- ============================================================
-- END OF PROJECT
-- ============================================================
