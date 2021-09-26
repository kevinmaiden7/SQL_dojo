-- https://sqliteonline.com/

create table DEPARTMENTS (  
  deptno        number,  
  name          varchar2(50) not null,  
  location      varchar2(50) not null,  
  constraint pk_departments primary key (deptno)  
);

create table EMPLOYEES (  
  id                number,  
  name              varchar2(50) not null,
  manager           number,
  salary            number(5),
  commission        number(3),
  job               varchar2(50),
  deptno            number,  
  constraint pk_employees primary key (id),  
  constraint fk_employees_deptno foreign key (deptno) 
      references DEPARTMENTS (deptno)  
);

insert into departments (deptno, name, location) values(10, 'Management','Medellin');
insert into departments (deptno, name, location) values(20, 'Sales','Medellin');
insert into departments (deptno, name, location) values(30, 'Systems','Envigado');
insert into departments (deptno, name, location) values(40, 'Logistics','Bello');
insert into departments (deptno, name, location) values(50, 'Storage','La Estrella');

insert into EMPLOYEES (id, name, manager, salary, commission, job, deptno)
    values(12345, 'Pepe Cardenas','98765', 3500, 20, 'Seller', 20);

insert into EMPLOYEES (id, name, manager, salary, commission, job, deptno)
    values(22334, 'Jesus Orozco','98765', 3400, 10, 'Seller', 20);
insert into EMPLOYEES (id, name, manager, salary, job, deptno)
    values(55887, 'Maria Gonzalez','67954', 3700, 'Analyst', 30);
insert into EMPLOYEES (id, name, manager, salary, job, deptno)
    values(98987, 'Pedro Soto','67954', 3800, 'Analyst', 30);
insert into EMPLOYEES (id, name, manager, salary, job, deptno)
    values(57689, 'Teresa Solarte','45597', 2500, 'Secretary', 10);
insert into EMPLOYEES (id, name, manager, salary, commission, job, deptno)
    values(44554, 'Fabio Perez','98765', 3400, 15, 'Seller', 20);
insert into EMPLOYEES (id, name, salary, job, deptno)
    values(45597, 'Carlos Martinez', 4800, 'Manager', 10);
insert into EMPLOYEES (id, name, manager, salary, job, deptno)
    values(22774, 'Hernan Mejia','67954', 4600, 'Analyst', 30);
insert into EMPLOYEES (id, name, manager, salary, commission, job, deptno)
    values(98765, 'Jesus Rico','45597', 3400, 10, 'Head', 20);
insert into EMPLOYEES (id, name, manager, salary, job, deptno)
    values(67954, 'Diana Botero','45597', 4900, 'Head', 30);
insert into EMPLOYEES (id, name, manager, salary, job, deptno)
    values(34760, 'Amalia Perez','98765', 2400, 'Secretary', 20);
insert into EMPLOYEES (id, name, manager, salary, job, deptno)
    values(34908, 'Juan Ruiz','45597', 1500, 'Postman', 10);
insert into EMPLOYEES (id, name, manager, salary, job, deptno)
    values(80451, 'Jesus Gallego','98765', 1500, 'Postman', 20);
insert into EMPLOYEES (id, name, manager, salary, job, deptno)
    values(76854, 'Camila Hernandez','67954', 2500, 'Secretary', 30);

SELECT * FROM EMPLOYEES;
SELECT id, name, job FROM EMPLOYEES;

-- Remove duplicates
SELECT job, deptno FROM EMPLOYEES;
SELECT DISTINCT job, deptno FROM EMPLOYEES;

-- Rename Columns
SELECT id AS Identification, name AS Person, job as ROLE FROM EMPLOYEES;

-- Use of WHERE
SELECT id, name, job, salary FROM EMPLOYEES WHERE job = 'Manager';

SELECT id, name, job, salary FROM EMPLOYEES WHERE salary > 3000;
SELECT id, name, job, salary, deptno FROM EMPLOYEES WHERE salary > 3000 AND deptno = 20;

SELECT id, name, job, deptno FROM EMPLOYEES WHERE deptno != 20; -- we can also use <>

SELECT id, name, job, commission FROM EMPLOYEES WHERE commission BETWEEN 10 AND 15

SELECT id, name, job FROM EMPLOYEES WHERE job IN ("Analyst", "Head")
SELECT id, name, job FROM EMPLOYEES WHERE job NOT IN ("Analyst", "Head")

-- ORDER BY
SELECT name, salary FROM EMPLOYEES WHERE deptno = 10 ORDER BY salary; -- By default sort in ascending order
SELECT name, salary, deptno FROM EMPLOYEES ORDER BY deptno ASC, salary DESC;

-- Operations on Columns
SELECT name, salary * 0.10 FROM EMPLOYEES;
SELECT name, salary * 0.10 AS discount FROM EMPLOYEES;

SELECT name, salary * comision/100 FROM EMPLOYEES;

-- INNER JOIN
SELECT id, E.name, D.name AS departament FROM EMPLOYEES E JOIN DEPARTMENTS D ON E.deptno = D.deptno; -- NO DIFFERENCE WITH INNER JOIN

    -- Self-Join
SELECT E.name AS employee, B.name AS head FROM EMPLOYEES E JOIN EMPLOYEES B ON E.manager = B.id;

-- Aggregation Functions
SELECT COUNT(*) FROM EMPLOYEES;

SELECT COUNT(commission) FROM EMPLOYEES; -- Amount of employees with commission (discards NULL values

SELECT COUNT(DISTINCT job) FROM EMPLOYEES; -- Amount of different roles

-- GROUP BY
SELECT deptno, SUM(salary) FROM EMPLOYEES GROUP BY deptno; -- Salary paid by department
SELECT deptno, SUM(salary) AS total FROM EMPLOYEES GROUP BY deptno ORDER BY 2 DESC;

SELECT deptno, SUM(salary) AS total 
FROM EMPLOYEES 
WHERE job <> 'Head'
GROUP BY deptno 
ORDER BY 2 DESC;

    -- HAVING: it is a condition for the group, not for each tuple
SELECT deptno, SUM(salary) AS total 
FROM EMPLOYEES 
WHERE job <> 'Head'
GROUP BY deptno
HAVING SUM(salary) > 10000
ORDER BY 2 DESC;

-- Sub-queries

SELECT name, salary FROM EMPLOYEES -- Employees with a higher salary than the avarage for department 20
WHERE salary > (
    SELECT AVG(salary) -- This returns a scalar value
    FROM EMPLOYEES
    WHERE deptno = 20
);

SELECT name, salary, job, deptno FROM EMPLOYEES -- Employees with the same role and department than employee with id 44554
WHERE (job, deptno) = ( -- This returns a tuple (a row)
    SELECT job, deptno
    FROM EMPLOYEES
    WHERE id = 44554
) AND id <> 44554;

-- EXISTS
SELECT name FROM DEPARTMENTS D -- Departments with at least one employee
WHERE EXISTS (
    SELECT * FROM EMPLOYEES E WHERE D.deptno = E.deptno
); -- EXISTS returns True if the sub-query is not null

SELECT name FROM DEPARTMENTS D -- Departments with no employees
WHERE NOT EXISTS (
    SELECT * FROM EMPLOYEES E WHERE D.deptno = E.deptno
);

-- UPDATE Rows
UPDATE DEPARTMENTS SET location = 'Medellin' WHERE deptno = 50;

-- DELETE Rows
DELETE FROM DEPARTMENTS WHERE deptno > 30;

-- DROP Tables
DROP TABLE DEPARTMENTS;
DROP TABLE EMPLOYEES;
