# MySQL Assignment 1 – DDL Commands & Constraints

A hands-on exercise covering MySQL **Data Definition Language (DDL)** commands and **table constraints**, built around a simple Employee database.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Database Schema](#database-schema)
- [Part 1: DDL Commands](#part-1-ddl-commands)
- [Part 2: Constraints](#part-2-constraints)
- [How to Run](#how-to-run)
- [Concepts Covered](#concepts-covered)
- [Notes](#notes)

---

## Overview

The assignment has two parts:

1. **DDL Commands** – `CREATE`, `ALTER`, `RENAME`, `TRUNCATE` and `DROP` on a database named `employee`.
2. **Constraints** – recreate the database with `PRIMARY KEY`, `UNIQUE`, `NOT NULL`, `AUTO_INCREMENT`, `CHECK`, `DEFAULT` and `FOREIGN KEY` rules applied.

## Prerequisites

- MySQL **8.0.19 or later** (needed for `CHECK` enforcement, expression defaults and `RENAME COLUMN`)
- A MySQL client such as MySQL Workbench, DBeaver or the `mysql` CLI

## Database Schema

| Table | Column | Data Type | Key |
|---|---|---|---|
| **departments** | department_id | INT | PK |
| | department_name | VARCHAR(100) | |
| **location** | location_id | INT | PK |
| | location | VARCHAR(30) | |
| **employees** | employee_id | INT | PK |
| | employee_name | VARCHAR(50) | |
| | gender | ENUM('M','F') | |
| | age | INT | |
| | hire_date | DATE | |
| | designation | VARCHAR(100) | |
| | department_id | INT | FK → departments |
| | location_id | INT | FK → location |
| | salary | DECIMAL(10,2) | |

**Relationships:** one department has many employees, and one location has many employees (1 : N).

---

## Part 1: DDL Commands

### 1. Table Creation (CREATE)

```sql
CREATE DATABASE employee;
USE employee;

CREATE TABLE departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE location (
    location_id INT PRIMARY KEY,
    location    VARCHAR(30)
);

CREATE TABLE employees (
    employee_id   INT PRIMARY KEY,
    employee_name VARCHAR(50),
    gender        ENUM('M','F'),
    age           INT,
    hire_date     DATE,
    designation   VARCHAR(100),
    department_id INT,
    location_id   INT,
    salary        DECIMAL(10,2)
);
```

### 2. Table Alteration (ALTER)

```sql
-- Add an email column
ALTER TABLE employees ADD COLUMN email VARCHAR(100);

-- Widen the designation column
ALTER TABLE employees MODIFY COLUMN designation VARCHAR(255);

-- Drop the age column
ALTER TABLE employees DROP COLUMN age;

-- Rename hire_date to date_of_joining
ALTER TABLE employees RENAME COLUMN hire_date TO date_of_joining;
-- For MySQL 5.7 and earlier:
-- ALTER TABLE employees CHANGE hire_date date_of_joining DATE;
```

### 3. Table Renaming (RENAME)

```sql
RENAME TABLE departments TO departments_info;
RENAME TABLE location    TO locations;
```

### 4. Table Truncation (TRUNCATE)

```sql
TRUNCATE TABLE employees;
```

### 5. Database & Table Dropping (DROP)

```sql
DROP TABLE employees;
DROP DATABASE employee;
```

---

## Part 2: Constraints

### 1. Database Recreation

```sql
DROP DATABASE IF EXISTS employee;
CREATE DATABASE employee;
USE employee;
```

### 2. Departments Table

- `department_id` uniquely identifies each department (**PRIMARY KEY**).
- `department_name` cannot be null or duplicated (**NOT NULL** + **UNIQUE**).

```sql
CREATE TABLE departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);
```

### 3. Location Table

- `location_id` is generated automatically and increments sequentially (**AUTO_INCREMENT**).
- `location` cannot be null or duplicated (**NOT NULL** + **UNIQUE**).

```sql
CREATE TABLE location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location    VARCHAR(30) NOT NULL UNIQUE
);
```

### 4. Employees Table

| Requirement | Constraint used |
|---|---|
| Distinct employee identifier | `PRIMARY KEY` |
| Name always provided | `NOT NULL` |
| Gender only 'M' or 'F' | `ENUM('M','F')` |
| Age 18 or above | `CHECK (age >= 18)` |
| Default hire date is today | `DEFAULT (CURRENT_DATE)` |
| Link to departments and location | `FOREIGN KEY` |

```sql
CREATE TABLE employees (
    employee_id   INT PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    gender        ENUM('M','F'),
    age           INT,
    hire_date     DATE DEFAULT (CURRENT_DATE),
    designation   VARCHAR(100),
    department_id INT,
    location_id   INT,
    salary        DECIMAL(10,2),

    CONSTRAINT chk_employee_age CHECK (age >= 18),
    CONSTRAINT fk_emp_department FOREIGN KEY (department_id)
        REFERENCES departments (department_id),
    CONSTRAINT fk_emp_location FOREIGN KEY (location_id)
        REFERENCES location (location_id)
);
```

---

## How to Run

1. Open your MySQL client and connect to your server.
2. Run the **Part 1** scripts in order (they create, alter, rename, truncate and finally drop the database).
3. Run the **Part 2** scripts in order to build the final constrained schema.
4. Optionally verify the result:

```sql
SHOW TABLES;
DESCRIBE employees;
SHOW CREATE TABLE employees;
```

### Optional: quick constraint tests

```sql
INSERT INTO departments VALUES (1, 'Finance');
INSERT INTO location (location) VALUES ('Dubai');

-- Valid row (hire_date defaults to today)
INSERT INTO employees (employee_id, employee_name, gender, age, designation, department_id, location_id, salary)
VALUES (101, 'Asha', 'F', 28, 'Analyst', 1, 1, 5500.00);

-- Each of these should fail:
INSERT INTO departments VALUES (2, 'Finance');                 -- duplicate department_name
INSERT INTO employees (employee_id, employee_name, gender, age) VALUES (102, 'Ravi', 'M', 17);   -- age < 18
INSERT INTO employees (employee_id, employee_name, gender, age) VALUES (103, 'Sam', 'X', 25);    -- invalid gender
INSERT INTO employees (employee_id, employee_name, department_id) VALUES (104, 'Lee', 99);       -- FK violation
```

## Concepts Covered

- `CREATE`, `ALTER`, `RENAME`, `TRUNCATE`, `DROP`
- `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`
- `AUTO_INCREMENT`, `DEFAULT`, `CHECK`, `ENUM`

## Notes

- `TRUNCATE` removes all rows and resets auto-increment counters, and it cannot be rolled back. `DELETE` is the row-by-row alternative.
- In Part 1 the `age` column is dropped, but it is restored in Part 2 because the constraints section recreates the schema from scratch.
- `DROP TABLE employees` must come before dropping the referenced tables once foreign keys exist, since child tables depend on their parents.
- On MySQL versions before 8.0.16, `CHECK` constraints are parsed but ignored; on versions before 8.0.13, `DEFAULT (CURRENT_DATE)` is not supported (use a `TIMESTAMP` column or a trigger instead).
