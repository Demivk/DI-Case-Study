----------------------------------------------------------
/*														*/
/* Gemaakt door: Demi van Kesteren en Simon van Noppen  */
/*														*/
----------------------------------------------------------
--- Constraint 1 ---
--- The president of the company earns more than $10.000 monthly
use course
go

EXEC tSQLt.DropClass 'Constraint1'
GO

EXEC tSQLt.NewTestClass 'Constraint1'
GO

create or alter procedure Constraint1.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'emp'
	drop table if exists expected
	create table  expected
	( empno       numeric(4,0)	null
	, ename       varchar(8)    null
	, job         varchar(9)    null
	, born        date          null
	, hired       date          null
	, sgrade      numeric(2,0)  null
	, msal        numeric(7,2)  null
	, username    varchar(15)   null
	, deptno      numeric(2,0)  null
	)
	insert into emp values
	(1,null,'PRESIDENT',null,null,null,11000,null,null)
	insert into expected values
	(1,null,'PRESIDENT',null,null,null,11000,null,null)
	exec tsqlt.ApplyConstraint 'emp', 'CK_PRESIDENT_SAL'
end
go

-- 1. Insert: Job = PRESIDENT and salary > $10.000
CREATE or alter PROC [Constraint1].[test that employee with job = president and salary > 10000 gets inserted]
AS
BEGIN
	-- Arrange
	insert into expected values
	(2,null,'President',null,null,null,11000,null,null)
	-- Act
	exec tsqlt.ExpectNoException
	insert into emp values
	(2,null,'President',null,null,null,11000,null,null)
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 2. Update: Job = PRESIDENT and salary > $10.000
CREATE or alter PROC [Constraint1].[test that employee with job = president and salary > 10000 gets updated]
AS
BEGIN
	-- Arrange
	update expected
	set msal = 10001
	-- Act
	exec tsqlt.ExpectNoException
	update emp
	set msal = 10001
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 3. Insert: Job != PRESIDENT and salary > $10.000
CREATE or alter PROC [Constraint1].[test that employee with job != president and salary > 10000 gets inserted]
AS
BEGIN
	-- Arrange
	insert into expected values
	(2,null,'TRAINER',null,null,null,11000,null,null)
	-- Act
	exec tsqlt.ExpectNoException
	insert into emp values
	(2,null,'TRAINER',null,null,null,11000,null,null)
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 4. Update: Job != PRESIDENT and salary > $10.000
CREATE or alter PROC [Constraint1].[test that employee with job != president and salary > 10000 gets updated]
AS
BEGIN
	-- Arrange
	update expected
	set job = 'TRAINER'
	-- Act
	exec tsqlt.ExpectNoException
	update emp
	set job = 'TRAINER'
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 5. Insert: Job = PRESIDENT and salary <= $10.000
CREATE or alter PROC [Constraint1].[test that employee with job = president and salary <= 10000 not gets inserted]
AS
BEGIN
	-- Arrange
	-- Act
	exec tsqlt.ExpectException
	insert into emp values
	(2,null,'PRESIDENT',null,null,null,10000,null,null)
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 6. Update: Job = PRESIDENT and salary <= $10.000
CREATE or alter PROC [Constraint1].[test that employee with job = president and salary <= 10000 not gets updated]
AS
BEGIN
	-- Arrange
	-- Act
	exec tsqlt.ExpectException
	update emp
	set msal = 10000
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 7. Insert: Job != PRESIDENT and salary <= $10.000
CREATE or alter PROC [Constraint1].[test that employee with job != president and salary <= 10000 gets inserted]
AS
BEGIN
	-- Arrange
	insert into expected values
	(2,null,'TRAINER',null,null,null,10000,null,null)
	-- Act
	exec tsqlt.ExpectNoException
	insert into emp values
	(2,null,'TRAINER',null,null,null,10000,null,null)
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 8. Update: Job != PRESIDENT and salary <= $10.000
CREATE or alter PROC [Constraint1].[test that employee with job != president and salary <= 10000 gets updated]
AS
BEGIN
	-- Arrange
	update expected
	set job = 'TRAINER', msal = 10000
	-- Act
	exec tsqlt.ExpectNoException
	update emp
	set job = 'TRAINER', msal = 10000
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO
--------------------------------------------------

--------------------------------------------------
---  Constraint 3 ---
--- The company hires adult personnel only
EXEC tSQLt.DropClass 'Constraint3'
GO

EXEC tSQLt.NewTestClass 'Constraint3'
GO

create or alter procedure Constraint3.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'emp'
	drop table if exists expected
	create table  expected
	( empno       numeric(4,0)	null
	, ename       varchar(8)    null
	, job         varchar(9)    null
	, born        date          null
	, hired       date          null
	, sgrade      numeric(2,0)  null
	, msal        numeric(7,2)  null
	, username    varchar(15)   null
	, deptno      numeric(2,0)  null
	)
	insert into emp values
	(1,null,null,'2000-2-20',null,null,null,null,null)
	insert into expected values
	(1,null,null,'2000-2-20',null,null,null,null,null)
	exec tsqlt.ApplyConstraint 'emp', 'CK_PERSONNEL_AGE'
end
go

-- 1. Insert: Employee is older than 18 years old
CREATE or alter PROC [Constraint3].[test that employee with an age older than 18 gets inserted]
AS
BEGIN
	-- Arrange
	insert into expected values
	(2,null,null,'2000-2-20',null,null,null,null,null)
	-- Act
	exec tsqlt.ExpectNoException
	insert into emp values
	(2,null,null,'2000-2-20',null,null,null,null,null)
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 2. Update: Employee is older than 18 years old
CREATE or alter PROC [Constraint3].[test that employee with an age older than 18 gets updated]
AS
BEGIN
	-- Arrange
	update expected
	set born = '1999-2-25'
	-- Act
	exec tsqlt.ExpectNoException
	update emp
	set born = '1999-2-25'
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 3. Insert: Employee is younger than 18 years old
CREATE or alter PROC [Constraint3].[test that employee with an age younger than 18 not gets inserted]
AS
BEGIN
	-- Arrange
	-- Act
	exec tsqlt.ExpectException
	insert into emp values
	(2,null,null,CURRENT_TIMESTAMP,null,null,null,null,null)
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO

-- 4. Update: Employee is younger than 18 years old
CREATE or alter PROC [Constraint3].[test that employee with an age younger than 18 not gets updated]
AS
BEGIN
	-- Arrange
	-- Act
	exec tsqlt.ExpectException
	update emp
	set born = CURRENT_TIMESTAMP
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, emp;
END
GO
--------------------------------------------------

--------------------------------------------------
--- Constraint 5 ---
--- The start date and known trainer uniquely identify course offerings. Note: the use of a filtered index is not allowed.
EXEC tSQLt.DropClass 'Constraint5'
GO

EXEC tSQLt.NewTestClass 'Constraint5'
GO

create or alter procedure Constraint5.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'offr'
	drop table if exists expected
	create table expected
	( course      varchar(6)    null
	, starts      date          null
	, status      varchar(4)    null
	, maxcap      numeric(2,0)  null
	, trainer     numeric(4,0)  
	, loc         varchar(14)   null
	)
	insert into offr values
	(null,'2000-2-20',null,null,1,null),
	(null,'2000-2-20',null,null,2,null)
	insert into expected values
	(null,'2000-2-20',null,null,1,null),
	(null,'2000-2-20',null,null,2,null)
	exec tsqlt.ApplyTrigger 'offr', 'TR_CheckStartAndTrainerUniquelyIdentifyCourseOffr'
end
go

-- 1. Insert: Combination of starts and trainer is unique, trainer is not null
CREATE or alter PROC [Constraint5].[test that course with unique combination of starts and trainer and trainer is not null gets inserted]
AS
BEGIN
	-- Arrange
	insert into expected values
	(null,'2000-2-20',null,null,3,null),
	(null,'2000-2-20',null,null,4,null)
	-- Act
	exec tsqlt.ExpectNoException
	insert into offr values
	(null,'2000-2-20',null,null,3,null),
	(null,'2000-2-20',null,null,4,null)
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO

-- 2. Update: Combination of starts and trainer is unique, trainer is not null
CREATE or alter PROC [Constraint5].[test that course with unique combination of starts and trainer and trainer is not null gets updated]
AS
BEGIN
	-- Arrange
	update expected
	set starts = '1999-2-25'
	-- Act
	exec tsqlt.ExpectNoException
	update offr
	set starts = '1999-2-25'
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO

-- 3. Insert: Combination of starts and trainer is not unique, trainer is not null
CREATE or alter PROC [Constraint5].[test that course with not unique combination of starts and trainer and trainer is not null not gets inserted]
AS
BEGIN
	-- Arrange
	-- Act
	exec tsqlt.ExpectException
	insert into offr values
	(null,'2000-2-20',null,null,3,null),
	(null,'2000-2-20',null,null,3,null)
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO

-- 4. Update: Combination of starts and trainer is not unique, trainer is not null
CREATE or alter PROC [Constraint5].[test that course with not unique combination of starts and trainer and trainer is not null not gets updated]
AS
BEGIN
	-- Arrange
	-- Act
	exec tsqlt.ExpectException
	update offr
	set trainer = 1
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO

-- 5. Insert: Combination of starts and trainer is not unique, trainer is null
CREATE or alter PROC [Constraint5].[test that course with not unique combination of starts and trainer and trainer is null gets inserted]
AS
BEGIN
	-- Arrange
	insert into expected values
	(null,'2000-2-20',null,null,null,null),
	(null,'2000-2-20',null,null,null,null)
	-- Act
	exec tsqlt.ExpectNoException
	insert into offr values
	(null,'2000-2-20',null,null,null,null),
	(null,'2000-2-20',null,null,null,null)
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO

-- 6. Update: Combination of starts and trainer is not unique, trainer is null
CREATE or alter PROC [Constraint5].[test that course with not unique combination of starts and trainer and trainer is null gets updated]
AS
BEGIN
	-- Arrange
	update expected
	set starts = '1999-2-25', trainer = null
	-- Act
	exec tsqlt.ExpectNoException
	update offr
	set starts = '1999-2-25', trainer = null
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO
--------------------------------------------------

--------------------------------------------------
--- Constraint 7 ---
--- An active employee cannot be managed by a terminated employee
EXEC tSQLt.DropClass 'Constraint7'
GO

EXEC tSQLt.NewTestClass 'Constraint7'
GO

create or alter procedure Constraint7.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'memp'
	exec tsqlt.FakeTable 'term'
	drop table if exists expected
	create table  expected
	( empno       numeric(4,0)   null
	, mgr         numeric(4,0)   null
	);
	insert into memp values
	(1,11),
	(2,12),
	(3,13)
	insert into expected values
	(1,11),
	(2,12),
	(3,13)
	insert into term values
	(21,null,null),
	(22,null,null),
	(23,null,null)
end
go

-- 1. Insert: Manager is terminated
CREATE or alter PROC [Constraint7].[test that terminated manager not gets inserted]
AS
BEGIN
	-- Arrange
	-- Act
	exec tsqlt.ExpectException
	exec usp_CheckInsertedManagerIsTerminated 4,21
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, memp;
END
GO

-- 2. Update: Manager is terminated
CREATE or alter PROC [Constraint7].[test that terminated manager not gets updated]
AS
BEGIN
	BEGIN
	-- Arrange
	-- Act
	exec tsqlt.ExpectException
	exec usp_CheckUpdatedManagerIsTerminated 11,21,3
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, memp;
END
END
GO

-- 4. Update: Manager is not terminated and no values are given
CREATE or alter PROC [Constraint7].[test that active manager with no new values given not gets updated]
AS
BEGIN
	-- Arrange
	-- Act
	EXEC tSQLt.ExpectException
	EXEC usp_CheckUpdatedManagerIsTerminated NULL, 11, NULL;
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, memp;
END
GO

-- 5. Update: Manager is not terminated and old manager is given
CREATE or alter PROC [Constraint7].[test that active manager with old manager given gets updated]
AS
BEGIN
	-- Arrange
	update expected
	set mgr = 12
	where mgr = 11
	-- Act
	exec tsqlt.ExpectNoException
	exec usp_CheckUpdatedManagerIsTerminated 11,12,null
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, memp;
END
GO

-- 6. Update: Manager is not terminated and employee is given
CREATE or alter PROC [Constraint7].[test that active manager with employee given gets updated]
AS
BEGIN
	-- Arrange
	update expected
	set mgr = 12
	where empno = 3
	-- Act
	exec tsqlt.ExpectNoException
	exec usp_CheckUpdatedManagerIsTerminated null,12,3
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, memp;
END
GO

-- 7. Insert: Manager is not terminated and employee is not in memp
CREATE or alter PROC [Constraint7].[test that the combination of manager and employee gets inserted]
AS
BEGIN
	-- Arrange
	insert into expected values
	(4,12)
	-- Act
	exec tsqlt.ExpectNoException
	exec usp_CheckInsertedManagerIsTerminated 4,12
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, memp;
END
GO

-- 7. Update: Manager is not terminated and old manager and employee are given
CREATE or alter PROC [Constraint7].[test that the combination of manager and employee gets updated]
AS
BEGIN
	-- Arrange
	update expected
	set mgr = 12
	where empno = 3 and mgr = 13
	-- Act
	exec tsqlt.ExpectNoException
	exec usp_CheckUpdatedManagerIsTerminated 13,12,3
	-- Assert
	EXEC tSQLt.AssertEqualsTable expected, memp;
END
GO
--------------------------------------------------

--------------------------------------------------
--- Constraint 9 ---
--- At least half of the course offerings (measured by duration) taught by a trainer must be ‘home based’. 
--- Note: ‘Home based’ means the course is offered at the same location where the employee is employed.
EXEC tSQLt.DropClass 'Constraint9'
GO

EXEC tSQLt.NewTestClass 'Constraint9'
GO

create or alter procedure Constraint9.[SetUp]
AS
BEGIN
    EXEC tsqlt.FakeTable 'offr'
    EXEC tsqlt.FakeTable 'crs'
    EXEC tsqlt.FakeTable 'emp'
    EXEC tsqlt.FakeTable 'dept'

    drop table if exists expected
    create table expected
    ( course      varchar(6)    null
    , starts      date          null
    , status      varchar(4)    null
    , maxcap      numeric(2,0)  null
    , trainer     numeric(4,0)  
    , loc         varchar(14)   null
    )
    insert into offr values
    ('APEX',null,null,null,1,'ARNHEM'),
    ('WOOP',null,null,null,1,'ARNHEM'),
    ('WOOP',null,null,null,2,'DUIVEN'),
    ('APEX',null,null,null,2,'AMERSFOORT')
    insert into expected values
    ('APEX',null,null,null,1,'ARNHEM'),
    ('WOOP',null,null,null,1,'ARNHEM'),
    ('WOOP',null,null,null,2,'DUIVEN'),
    ('APEX',null,null,null,2,'AMERSFOORT')
    insert into crs values
    ('APEX',null,null,5),
    ('WOOP',null,null,1),
    ('LONG',null,null,30)
    insert into dept values
    (1,null,'ARNHEM',null),
    (2,null,'AMERSFOORT',null)
    insert into emp values
    (1,null,null,null,null,null,null,null,1),
    (2,null,null,null,null,null,null,null,2)
end
go

-- 1. Insert: Half of locations of trainer are home-based
CREATE or alter PROC [Constraint9].[test that offr with trainer having at least half of locations home-based gets inserted]
AS
BEGIN
    -- Arrange
    insert into expected values
    ('WOOP',null,null,null,1,'DUIVEN')
    -- Act
    exec tsqlt.ExpectNoException
    exec usp_CheckInsertedOfferingHalfHomeBased 'WOOP',null,null,null,1,'DUIVEN'
    -- Assert
    EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO

-- 2. Update: Half of locations of trainer are home-based
CREATE or alter PROC [Constraint9].[test that offr with trainer having at least half of locations home-based gets updated]
AS
BEGIN
    -- Arrange
    update expected
    set loc = 'DUIVEN'
    where course = 'WOOP' and trainer = '1' and starts = null
    -- Act
    exec tsqlt.ExpectNoException
    exec usp_CheckUpdatedOfferingHalfHomeBased 'WOOP',null,1,'ARNHEM','DUIVEN'
    -- Assert
    EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO

-- 3. Insert: Half of locations of trainer are not home-based
CREATE or alter PROC [Constraint9].[test that off with trainer having less than half of locations home-based not gets inserted]
AS
BEGIN
    -- Arrange
    -- Act
    exec tsqlt.ExpectException
    exec usp_CheckInsertedOfferingHalfHomeBased 'LONG',null,null,null,1,'DUIVEN'
    -- Assert
    EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO

-- 4. Update: Half of locations of trainer are not home-based
CREATE or alter PROC [Constraint9].[test that off with trainer having less than half of locations home-based not gets updated]
AS
BEGIN
    -- Arrange
    -- Act
    EXEC tSQLt.ExpectException
    EXEC usp_CheckUpdatedOfferingHalfHomeBased 'APEX',null,2,'AMERSFOORT','DUIVEN';
    -- Assert
    EXEC tSQLt.AssertEqualsTable expected, offr;
END
GO

--------------------------------------------------

--------------------------------------------------
--- Constraint 11 ---
---  You are allowed to teach a course only if:
---		- your job type is trainer and
---			- you have been employed for at least one year 
---			- or you have attended the course yourself (as participant)

EXEC tSQLt.DropClass 'Constraint11'
GO

EXEC tSQLt.NewTestClass 'Constraint11'
GO

create or alter procedure Constraint11.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'offr'
	EXEC tsqlt.FakeTable 'emp'
	EXEC tsqlt.FakeTable 'reg'
	drop table if exists expected
	create table expected
	( course      varchar(6)    null
	, starts      date          null
	, status      varchar(4)    null
	, maxcap      numeric(2,0)  null
	, trainer     numeric(4,0)  
	, loc         varchar(14)   null
	)
	insert into offr values
	('APEX',null,null,null,1,null),
	('APEX',null,null,null,1,null)
	insert into expected values
	('APEX',null,null,null,1,null),
	('APEX',null,null,null,1,null)
	insert into emp values
	(1,null,'TRAINER',null,CURRENT_TIMESTAMP,null,null,null,null),
	(2,null,'TRAINER',null,CURRENT_TIMESTAMP,null,null,null,null),
	(3,null,'TRAINER',null,'2000-2-20',null,null,null,null),
	(4,null,'MANAGER',null,'2000-2-20',null,null,null,null)
	insert into reg values
	(1,'APEX',null,null),
	(1,'LONG',null,null),
	(1,'WOOP',null,null),
	(4,'APEX',null,null)
	exec tsqlt.ApplyTrigger 'offr', 'TR_CheckPersonIsAllowedToTeachCourse'
end
go

CREATE or alter PROC [Constraint11].[test inserting trainers where they are allowed to teach cause they are hired for a year]
AS
BEGIN
	-- arrange
	insert into expected values
	('APEX',null,null,null,3,null),
	('WOOP',null,null,null,3,null)
	-- act
	exec tsqlt.ExpectNoException
	insert into offr values
	('APEX',null,null,null,3,null),
	('WOOP',null,null,null,3,null)
	-- assert
	exec tSQLt.AssertEqualsTable expected, offr
END
GO

CREATE or alter PROC [Constraint11].[test updating trainers where they are allowed to teach cause they are hired for a year]
AS
BEGIN
	-- arrange
	update expected
	set trainer = 3
	-- act
	exec tsqlt.ExpectNoException
	update offr
	set trainer = 3
	-- assert
	exec tSQLt.AssertEqualsTable expected, offr
END
GO

CREATE or alter PROC [Constraint11].[test that employee that is not allowed to teach due to their job not gets inserted]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	insert into offr values
	('APEX',null,null,null,3,null),
	('WOOP',null,null,null,4,null)
	-- assert
	exec tSQLt.AssertEqualsTable expected, offr
END
GO

CREATE or alter PROC [Constraint11].[test that employee that is not allowed to teach due to their job not gets updated]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	update offr
	set trainer = 4
	-- assert
	exec tSQLt.AssertEqualsTable expected, offr
END
GO

CREATE or alter PROC [Constraint11].[test inserting trainers that are allowed to teach cause they followed the same course]
AS
BEGIN
	-- arrange
	insert into expected values
	('LONG',null,null,null,1,null),
	('WOOP',null,null,null,1,null)
	-- act
	exec tsqlt.ExpectNoException
	insert into offr values
	('LONG',null,null,null,1,null),
	('WOOP',null,null,null,1,null)
	exec tsqlt.AssertEqualsTable expected, offr
END
GO

CREATE or alter PROC [Constraint11].[test updating trainers that are allowed to teach cause they followed the same course]
AS
BEGIN
	-- arrange
	update expected
	set course = 'WOOP'
	-- act
	exec tsqlt.ExpectNoException
	update offr
	set course = 'WOOP'
	exec tsqlt.AssertEqualsTable expected, offr
END
GO

CREATE or alter PROC [Constraint11].[test not inserting trainers because they haven't been hired for a year and haven't followed a course]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	insert into offr values
	('LONG',null,null,null,2,null),
	('WOOP',null,null,null,2,null)
	exec tsqlt.AssertEqualsTable expected, offr
END
GO

CREATE or alter PROC [Constraint11].[test not updating trainers because they haven't been hired for a year and haven't followed a course]
AS
BEGIN
	-- Arrange
	-- Act
	EXEC tSQLt.ExpectException
	UPDATE offr
	SET trainer = 2
	-- Assert
	EXEC tsqlt.AssertEqualsTable expected, offr
END
GO

-- Test voor constraint 2
Exec tSQLt.NewTestClass 'Constraint2';
go

create or alter procedure Constraint2.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'emp'
	exec tsqlt.FakeTable 'term'
	drop table if exists expected
	create table  expected
	( empno       numeric(4,0)	null
	, ename       varchar(8)    null
	, job         varchar(9)    null
	, born        date          null
	, hired       date          null
	, sgrade      numeric(2,0)  null
	, msal        numeric(7,2)  null
	, username    varchar(15)   null
	, deptno      numeric(2,0)  null
	)
	exec tsqlt.ApplyTrigger 'emp', 'TR_ADMIN_in_dept_where_MANAGER_or_PRESIDENT'
end
go
-- 4 tests totaal 2 voor insert succes en fail, 2 voor update succes en fail
CREATE OR ALTER PROCEDURE Constraint2.[test if 2 people can get inserted]
AS
BEGIN
	-- arrange
	insert into expected values
	(1,null,'MANAGER',null,null,null,null,null,1),
	(2,null,'ADMIN',null,null,null,null,null,1)
	-- act
	exec tsqlt.ExpectNoException
	insert into emp values
	(1,null,'MANAGER',null,null,null,null,null,1),
	(2,null,'ADMIN',null,null,null,null,null,1)
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, emp;
END;
GO

CREATE OR ALTER PROCEDURE Constraint2.[test if 2 people can get deleted]
AS
BEGIN
	-- arrange
	-- act
	insert into emp values
	(1,null,'MANAGER',null,null,null,null,null,1),
	(2,null,'ADMIN',null,null,null,null,null,1)
	exec tsqlt.ExpectNoException
	delete from emp
	where 1=1
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, emp;
END;
GO

create or alter PROCEDURE Constraint2.[test update emp table]
AS
BEGIN
	-- arrange
	insert into expected values
	(1,null,'MANAGER',null,null,null,null,null,1),
	(2,null,'ADMIN',null,null,null,null,null,1)
	-- act
	exec tsqlt.ExpectNoException
	insert into emp values
	(1,null,'TRAINER',null,null,null,null,null,1),
	(2,null,'TRAINER',null,null,null,null,null,1)
	update emp
	set job = 'ADMIN'
	where empno = 2
	update emp
	set job = 'MANAGER'
	where empno = 1
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, emp;
END;
GO

create or alter PROCEDURE Constraint2.[test do not insert cause there is no admin in same department]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	insert into emp values
	(1,null,'MANAGER',null,null,null,null,null,2),
	(2,null,'ADMIN',null,null,null,null,null,1)
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, emp;
END;
GO

create or alter PROCEDURE Constraint2.[test do not delete cause there is no admin in same department]
AS
BEGIN
	-- arrange
	-- act
	insert into emp values
	(1,null,'MANAGER',null,null,null,null,null,1),
	(2,null,'ADMIN',null,null,null,null,null,1),
	(3,null,'ADMIN',null,null,null,null,null,1)
	exec tsqlt.ExpectException
	delete from emp
	where empno > 1
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, emp;
END;
GO

create or alter PROCEDURE Constraint2.[test update fail cause there is no admin]
AS
BEGIN
	-- assert
	insert into expected values
	(1,null,'MANAGER',null,null,null,null,null,1),
	(2,null,'ADMIN',null,null,null,null,null,1)
	-- act
	exec.tSQLt.ExpectNoException
	insert into emp values
	(1,null,'MANAGER',null,null,null,null,null,1),
	(2,null,'ADMIN',null,null,null,null,null,1)
	-- assert
	exec tsqlt.ExpectException
	update emp
	set job = 'MANAGER'
	where empno = 2
    EXEC tSQLt.AssertEqualsTable expected, emp;
END;
GO

-- test voor constraint 4

-- 8 tests 4 voor insert 1 succes 3 fail 4 voor update 1 succes 3 fail

Exec tSQLt.NewTestClass 'Constraint4';
go

create or alter procedure Constraint4.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'grd'
	drop table if exists expected
	create table expected
	( grade       numeric(2,0)   null
	, llimit      numeric(7,2)   null
	, ulimit      numeric(7,2)   null
	, bonus       numeric(7,2)   null
	)
	insert into grd values
	(1,100,200,null),
	(2,200,300,null),
	(3,300,400,null)
	insert into expected values
	(1,100,200,null),
	(2,200,300,null),
	(3,300,400,null)
	exec tsqlt.ApplyTrigger 'grd', 'TR_insert_update_grade_constraints'
end
go

CREATE or alter PROCEDURE Constraint4.[test if new grades can be inserted]
AS
BEGIN
	-- arrange
	insert into expected values
	(4,400,500,null),
	(5,500,600,null),
	(6,600,700,null)
	-- act
	exec tsqlt.ExpectNoException
	insert into grd values
	(4,400,500,null),
	(5,500,600,null),
	(6,600,700,null)
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, grd;
END;
GO

CREATE or alter PROCEDURE Constraint4.[test multiplegrades can be changed]
AS
BEGIN
	-- arrange
    update expected
	set llimit = llimit + 10
	-- act
	exec tsqlt.ExpectNoException
	update grd
	set llimit = llimit + 10
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, grd;
END;
GO

create or alter PROCEDURE Constraint4.[test if multiple overlapping grades fail to insert]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	INSERT INTO grd VALUES
	(4,400,500,null),
	(5,500,600,null),
	(6,500,700,null)
	-- assert
	exec tSQLt.AssertEqualsTable expected, grd;

END;
GO

CREATE or alter PROCEDURE Constraint4.[test if multiple overlapping grades fail to update]
AS
BEGIN
	-- arrange
	-- act
	exec tSQLt.ExpectException
	UPDATE grd
	SET llimit = llimit - 100
	-- assert
	exec tsqlt.AssertEqualsTable expected, grd
END;
GO

CREATE or alter PROCEDURE Constraint4.[test if lower limit lower than the lower limit from the grade under it cannot be inserted]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	INSERT INTO grd VALUES
	(4,400,500,null),
	(5,550,600,null),
	(6,540,700,null)
	-- assert
	exec tsqlt.AssertEqualsTable expected, grd

END;
GO

CREATE or alter PROCEDURE Constraint4.[test if data cannot be updated to a grade having lower limit lower than the lower limit from the grade under]
AS
BEGIN
	-- arrange
	UPDATE grd
	SET llimit = 250
	WHERE grade = 2
	-- act
	exec tSQLt.ExpectException
	UPDATE grd
	SET llimit = 240
	WHERE grade = 3
	-- assert
	exec tsqlt.AssertEqualsTable expected, grd
END;
GO

CREATE or alter PROCEDURE Constraint4.[test if higher limit lower than the higher limit from the grade under it cannot be inserted]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	INSERT INTO grd VALUES
	(4,400,500,null),
	(5,500,650,null),
	(6,600,640,null)
	-- assert
	exec tsqlt.AssertEqualsTable expected, grd

END;
GO

CREATE or alter PROCEDURE Constraint4.[test if data cannot be updated to a grade having higher limit lower than the higher limit from the grade under]
AS
BEGIN
	-- arrange
	UPDATE grd
	SET ulimit = 350
	WHERE grade = 2
	-- act
	exec tSQLt.ExpectException
	UPDATE grd
	SET ulimit = 240
	WHERE grade = 3
	-- assert
	exec tsqlt.AssertEqualsTable expected, grd
END;
GO

-- tests constraint 6

-- 4 tests 2 voor insert 1 succes 1 fail 2 voor update 1 succes 1 fail

Exec tSQLt.NewTestClass 'Constraint6';
go

create or alter procedure Constraint6.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'offr'
	EXEC tsqlt.FakeTable 'crs'
	drop table if exists expected
	create table expected
	( course      varchar(6)    null
	, starts      date          null
	, status      varchar(4)    null
	, maxcap      numeric(2,0)  null
	, trainer     numeric(4,0)  
	, loc         varchar(14)   null
	)
	insert into offr values
	('APEX','2000-2-20',null,null,1,null),
	('WOOP','2000-2-20',null,null,2,null)
	insert into crs values
	('APEX',null,null,5),
	('WOOP',null,null,5)
	insert into expected values
	('APEX','2000-2-20',null,null,1,null),
	('WOOP','2000-2-20',null,null,2,null)
	exec tsqlt.ApplyTrigger 'offr', 'TR_trainer_not_giving_multiple_courses_at_once'
end
go

create or alter PROCEDURE Constraint6.[test insert new courses wich do not overlap]
AS
BEGIN
	-- arrange
	insert into expected values
	('APEX','2000-2-25',null,null,1,null),
	('WOOP','2000-2-25',null,null,2,null)
	-- act
	exec tsqlt.ExpectNoException
	insert into offr values
	('APEX','2000-2-25',null,null,1,null),
	('WOOP','2000-2-25',null,null,2,null)
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, offr;
END;
GO

create or alter PROCEDURE Constraint6.[test update old courses wich do not overlap]
AS
BEGIN
	-- arrange
	update expected
	set starts = '2000-2-25', trainer = 1
	where trainer = 2
	-- act
	exec tsqlt.ExpectNoException
	update offr
	set starts = '2000-2-25', trainer = 1
	where trainer = 2
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, offr;
END;
GO

create or alter PROCEDURE Constraint6.[test insert fail because new courses do overlap with old courses]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	insert into offr values
	('APEX','2000-2-25',null,null,1,null),
	('WOOP','2000-2-23',null,null,2,null)
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, offr;
END;
GO

create or alter PROCEDURE Constraint6.[test update fail because courses overlap]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	update offr
	set trainer = 1
	where trainer = 2
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, offr;
END;
GO

-- constraint 8

/*
=================================================
|	student		| Teacher			|	allowed	|
|	A number	|	same number		|	no		|
|	A number	|	diffrent number	|	yes		|
=================================================
*/

-- 4 tests 2 voor insert 1 succes 1 fail 2 voor update 1 succes 1 fail

Exec tSQLt.NewTestClass 'Constraint8';
go

create or alter procedure Constraint8.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'reg'
	EXEC tsqlt.FakeTable 'offr'
	drop table if exists expected
	create table  expected
	( stud        numeric(4,0)  null
	, course      varchar(6)    null
	, starts      date          null
	, eval        numeric(1,0)  null
	);
	insert into reg values
	('2','APEX','2000-2-20',null),
	('1','WOOP','2000-2-20',null)
	insert into offr values
	('APEX','2000-2-20',null,null,1,null),
	('WOOP','2000-2-20',null,null,2,null)
	insert into expected values
	('2','APEX','2000-2-20',null),
	('1','WOOP','2000-2-20',null)
	exec tsqlt.ApplyTrigger 'reg', 'TR_teacher_cant_be_a_student_of_own_course'
end
go


create or alter PROCEDURE Constraint8.[test insert succes cause student is not teacher]
AS
BEGIN
	-- arrange
    insert into expected values
	(3,'APEX','2000-2-20',null),
	(4,'APEX','2000-2-20',null),
	(5,'APEX','2000-2-20',null),
	(3,'WOOP','2000-2-20',null)
	-- act
	exec tsqlt.ExpectNoException
	insert into reg values
	(3,'APEX','2000-2-20',null),
	(4,'APEX','2000-2-20',null),
	(5,'APEX','2000-2-20',null),
	(3,'WOOP','2000-2-20',null)
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

create or alter PROCEDURE Constraint8.[test update succes cause student is not teacher]
AS
BEGIN
	-- arrange
	update expected
	set stud = stud + 2
	-- act
	update reg
	set stud = stud + 2
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

create or alter PROCEDURE Constraint8.[test insert fail cause student is teacher]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	insert into reg values
	(3,'APEX','2000-2-20',null),
	(1,'APEX','2000-2-20',null)
	--assert
	EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

create or alter PROCEDURE Constraint8.[test update fail cause student is teacher]
AS
BEGIN
	-- arrange
	-- act
	exec tSQLt.ExpectException
	update reg
	set stud = 1
	--assert
	EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

-- constraint 10

/*
=====================================================
|	amount of reg	| status of offr	|	allowed	|
|	>5				|	CONF			|	yes		|
|	<=5				|	CONF			|	yes		|
|	>5				|	ELSE			|	no		|
|	<=5				|	ELSE			|	yes		|
=====================================================
*/

Exec tSQLt.NewTestClass 'Constraint10';
go

create or alter procedure Constraint10.[SetUp]
AS
BEGIN
	EXEC tsqlt.FakeTable 'reg'
	EXEC tsqlt.FakeTable 'offr'
	drop table if exists expected
	create table  expected
	( stud        numeric(4,0)  null
	, course      varchar(6)    null
	, starts      date          null
	, eval        numeric(1,0)  null
	);
	insert into reg values
	('10','APEX','2000-3-20',null),
	('9','APEX','2000-3-20',null),
	('8','APEX','2000-3-20',null),
	('7','APEX','2000-3-20',null),
	('6','WOOP','2000-3-20',null),
	('5','WOOP','2000-3-20',null)
	insert into offr values
	('APEX','2000-2-20','CONF',null,1,null),
	('WOOP','2000-2-20','SCHD',null,2,null),
	('APEX','2000-3-20','CONF',null,3,null),
	('WOOP','2000-3-20','SCHD',null,4,null)
	insert into expected values
	('10','APEX','2000-3-20',null),
	('9','APEX','2000-3-20',null),
	('8','APEX','2000-3-20',null),
	('7','APEX','2000-3-20',null),
	('6','WOOP','2000-3-20',null),
	('5','WOOP','2000-3-20',null)
	exec tsqlt.ApplyTrigger 'reg', 'TR_offer_not_confirmed_yet'
end
go

create or alter PROCEDURE Constraint10.[test insert until 6 succes cause the offr is confirmed]
AS
BEGIN
	-- arrange
    insert into expected values
	(11,'APEX','2000-2-20',null),
	(12,'APEX','2000-2-20',null),
	(13,'APEX','2000-2-20',null),
	(14,'APEX','2000-2-20',null),
	(15,'APEX','2000-2-20',null),
	(16,'APEX','2000-2-20',null)
	-- act
	insert into reg values
	(11,'APEX','2000-2-20',null),
	(12,'APEX','2000-2-20',null),
	(13,'APEX','2000-2-20',null),
	(14,'APEX','2000-2-20',null),
	(15,'APEX','2000-2-20',null),
	(16,'APEX','2000-2-20',null)
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

create or alter PROCEDURE Constraint10.[test update until 6 succes cause the offr is confirmed]
AS
BEGIN
	-- arrange
    update expected
	set course = 'APEX'
	-- act
	exec tsqlt.ExpectNoException
	update reg
	set course = 'APEX'
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

create or alter PROCEDURE Constraint10.[test insert until 5 registrations succes offr not confirmed yet]
AS
BEGIN
	-- arrange
	insert into expected values
	(11,'APEX','2000-2-20',null),
	(12,'APEX','2000-2-20',null),
	(13,'APEX','2000-2-20',null),
	(14,'APEX','2000-2-20',null),
	(15,'APEX','2000-2-20',null)
	-- act
	insert into reg values
	(11,'APEX','2000-2-20',null),
	(12,'APEX','2000-2-20',null),
	(13,'APEX','2000-2-20',null),
	(14,'APEX','2000-2-20',null),
	(15,'APEX','2000-2-20',null)
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

create or alter PROCEDURE Constraint10.[test update until 5 registrations succes offr not confirmed yet]
AS
BEGIN
	-- arrange
    update expected
	set course = 'WOOP'
	where stud <> 9
	-- act
	exec tsqlt.ExpectNoException
	update reg
	set course = 'WOOP'
	where stud <> 9
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

create or alter PROCEDURE Constraint10.[test insert until 6 fail cause the offr is not confirmed]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	insert into reg values
	(11,'WOOP','2000-2-20',null),
	(12,'WOOP','2000-2-20',null),
	(13,'WOOP','2000-2-20',null),
	(14,'WOOP','2000-2-20',null),
	(15,'WOOP','2000-2-20',null),
	(16,'WOOP','2000-2-20',null)
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

create or alter PROCEDURE Constraint10.[test update until 6 fail cause the offr is not confirmed]
AS
BEGIN
	-- arrange
	-- act
	exec tsqlt.ExpectException
	update reg
	set course = 'WOOP'
	-- assert
    EXEC tSQLt.AssertEqualsTable expected, reg;
END;
GO

--------------------------------------------------

--------------------------------------------------
EXEC tSQLt.RunAll
--------------------------------------------------