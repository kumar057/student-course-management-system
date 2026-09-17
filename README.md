# Student Course Management System

A complete MySQL database project for managing departments, students, instructors, courses, and enrollments.

## Project Contents

The main SQL file is:

- `student_course_management.sql`

It contains:

1. Database and table creation
2. Sample data for all tables
3. Basic SELECT queries
4. INNER/LEFT JOIN examples
5. Aggregate functions
6. Subqueries
7. UPDATE and DELETE examples
8. Five database views
9. Five stored procedures
10. Reports and analysis

## Database Tables

- `Departments`
- `Students`
- `Instructors`
- `Courses`
- `Enrollments`

## Requirements

- MySQL 8.0 or later
- MySQL Shell, MySQL Workbench, or another MySQL client

## How to Run

1. Open MySQL.
2. Open `student_course_management.sql`.
3. Run the complete script.
4. The script creates the `student_course_management` database automatically.
5. Use:

```sql
USE student_course_management;
SHOW TABLES;
```

6. You can then run the individual examples in the SQL file.

## Stored Procedure Examples

```sql
CALL sp_students_in_course(301);
CALL sp_courses_by_department(2);
CALL sp_count_students_by_department(1);
CALL sp_course_details(301);
CALL sp_students_enrolled_after_year(2023);
```

## Main Reports

The project includes reports for:

- Top 5 most popular courses
- Department with the most students
- Instructor teaching the most courses
- Student enrollment per semester
- Top 5 courses by credits

## Notes

The UPDATE and DELETE statements are commented out intentionally so that running the complete script does not unexpectedly change or remove the sample data. They can be uncommented individually when demonstrating UPDATE and DELETE operations.

## Author

Praveen Kumar
