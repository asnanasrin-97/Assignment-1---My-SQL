create database Employee;
use Employee;
create table departments(
department_id int primary key,
department_name varchar(100));
create table location(
location_id int primary key,
location Varchar(30));
create table employees(
employee_id int primary key,
employee_name varchar(50),
gender enum("M","F"),
age int,
hire_date Date,
designation Varchar(100),
department_id int,
location_id int,
salary decimal(10,2),
foreign key (department_id) references departments(department_id),
foreign key (location_id) references location(location_id));
alter table employees add column email varchar(100);
alter table employees modify column designation varchar(255);
alter table employees drop column age;
alter table employees rename column hire_date to date_of_joining;
rename table departments to departments_info;
rename table location to locations;
truncate table employees;
drop table employees;
drop database Employee;
create database Employee;
use Employee;
create table departments(
department_id int primary key ,
department_name varchar(100) not null);
create table location(
location_id int auto_increment primary key,
location varchar(30) not null unique);
create table employees(
employee_id int primary key,
employee_name varchar(50) not null,
gender enum("M","F"),
age int check(age>=18) ,
hire_date date default (current_date),
designation Varchar(100),
department_id int,
location_id int,
salary decimal(10,2),
foreign key (department_id) references departments(department_id),
foreign key (location_id) references location(location_id)
);


