----------------------------------------------------------
/*														*/
/* Gemaakt door: Demi van Kesteren en Simon van Noppen  */
/*														*/
----------------------------------------------------------

USE COURSE
drop user if exists Employee1
drop user if exists Reporter
drop role if exists Employee
drop login CourseLogin


CREATE LOGIN CourseLogin WITH PASSWORD = 'course'
GO

CREATE ROLE Employee
CREATE USER Employee1 without Login
ALTER ROLE Employee add member Employee1
CREATE USER Reporter without login

GRANT SELECT ON dbo.emp TO Employee
GRANT SELECT ON dbo.offr TO Employee
GRANT INSERT, UPDATE, DELETE, SELECT ON dbo.reg TO Employee

GRANT SELECT ON SCHEMA::dbo TO Reporter



-- Reporter tests
exec as user = 'Reporter'

-- Selects werken
select * from hist 

-- Insert werkt niet
insert into reg values
(1001,'APEX','2001-10-11',4)

-- drop table werkt niet
drop table hist

-- delete werkt niet
delete from emp

-- update werkt niet
update emp
set empno = 1

revert



-- Employee tests
exec as user = 'Employee1'

-- select op offr werkt 
select * from offr

-- select op emp werkt
select * from emp

-- crud operations op reg werken
insert into reg values
(1001,'APEX','2001-10-11',4)

update reg
set eval = '3'
where stud = 1001 and starts = '2001-10-11'

delete from reg
where stud = 1001 and starts = '2001-10-11'

select * from reg 

-- delete/update/insert op offr werkt niet
delete from offr
update offr
set course = 'APEX'
insert into offr values
('APEX',current_timestamp,'CONF',6,1017,'SAN FRANCISCO') 

-- delete/update/insert op emp werkt niet
delete from emp
update emp
set job = 'ADMIN'
insert into emp values
(1040,'SIMI','CO-PRESIDENT','1999-2-25',CURRENT_TIMESTAMP,'11',15500.00,'SIMI',10)


-- crud andere tabellen dan emp,reg,offr werkt niet
select * from dept
delete from dept
update dept
set mgr = 1003
insert into deptno values
(16,'LAZY PEOPLE','ARNHEM',1017)

revert