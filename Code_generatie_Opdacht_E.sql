----------------------------------------------------------
/*														*/
/* Gemaakt door: Demi van Kesteren en Simon van Noppen  */
/*														*/
----------------------------------------------------------

USE COURSE
-- Opdracht E
-------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS HIST_grd
DROP TABLE IF EXISTS HIST_emp
DROP TABLE IF EXISTS HIST_srep
DROP TABLE IF EXISTS HIST_memp
DROP TABLE IF EXISTS HIST_term
DROP TABLE IF EXISTS HIST_dept
DROP TABLE IF EXISTS HIST_crs
DROP TABLE IF EXISTS HIST_offr
DROP TABLE IF EXISTS HIST_reg
DROP TABLE IF EXISTS HIST_hist
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE HIST_grd (
	[timestamp] TIMESTAMP NOT NULL,
	grade numeric(4) not null,
	llimit numeric(7) not null,
	ulimit numeric(7) not null,
	bonus numeric(7) not null,
	CONSTRAINT PK_HIST_grd PRIMARY KEY ([timestamp], grade)
);

CREATE TABLE HIST_emp (
	[timestamp] TIMESTAMP NOT NULL,
	empno numeric(4) not null,
	ename varchar(8) not null,
	job varchar(9) not null,
	born date not null,
	hired date not null,
	sgrade numeric(2) not null,
	msal numeric(7) not null,
	username varchar(15) not null,
	deptno numeric(2) not null,
	CONSTRAINT PK_HIST_emp PRIMARY KEY ([timestamp], empno)
);

CREATE TABLE HIST_srep (
	[timestamp] TIMESTAMP NOT NULL,
	empno numeric(4) not null,
	target numeric(6) not null,
	comm numeric(7) not null,
	CONSTRAINT PK_HIST_srep PRIMARY KEY ([timestamp], empno)
);

CREATE TABLE HIST_memp (
	[timestamp] TIMESTAMP NOT NULL,
	empno numeric(4) not null,
	mgr numeric(4) not null,
	CONSTRAINT PK_HIST_memp PRIMARY KEY ([timestamp], empno)
);

CREATE TABLE HIST_term (
	[timestamp] TIMESTAMP NOT NULL,
	empno numeric(4) not null,
	leftcomp date not null,
	comments varchar(60) null, 
	CONSTRAINT PK_HIST_term PRIMARY KEY ([timestamp], empno)
);

CREATE TABLE HIST_dept (
	[timestamp] TIMESTAMP NOT NULL,
	deptno numeric(2) not null,
	dname varchar(12) not null,
	loc varchar(14) not null,
	mgr numeric(4) not null,
	CONSTRAINT PK_HIST_dept PRIMARY KEY ([timestamp], deptno)
);

CREATE TABLE HIST_crs (
	[timestamp] TIMESTAMP NOT NULL,
	code varchar(6) not null,
	descr varchar(40) not null,
	cat varchar(3) not null,
	dur numeric(2) not null
	CONSTRAINT PK_HIST_crs PRIMARY KEY ([timestamp], code)
);

CREATE TABLE HIST_offr (
	[timestamp] TIMESTAMP NOT NULL,
	course varchar(6) not null,
	starts date not null,
	status varchar(4) not null,
	maxcap numeric(2) not null,
	trainer numeric(4) null,
	loc varchar(14) not null
	CONSTRAINT PK_HIST_offr PRIMARY KEY ([timestamp], course, starts)
);

CREATE TABLE HIST_reg (
	[timestamp] TIMESTAMP NOT NULL,
	stud numeric(4) not null,
	starts date not null,
	course varchar(6) not null,
	eval numeric(1) not null
	CONSTRAINT PK_HIST_reg PRIMARY KEY ([timestamp], stud, starts)
);

CREATE TABLE HIST_hist (
	[timestamp] TIMESTAMP NOT NULL,
	empno numeric(4) not null,
	until date not null,
	deptno numeric(2) not null,
	msal numeric(7) not null,
	CONSTRAINT PK_HIST_hist PRIMARY KEY ([timestamp], empno, until)
);
-------------------------------------------------------------------------------------------------------------------------------------------------------------


DROP PROC IF EXISTS usp_GenereerTrigger
GO

CREATE PROC usp_GenereerTrigger
	@table_name VARCHAR(15)
AS
BEGIN
	BEGIN TRY
	SELECT
'GO 
CREATE OR ALTER TRIGGER TR_InsertDataInHist_' + @table_name +
		'
ON ' + @table_name +
		'
AFTER INSERT, UPDATE
AS
BEGIN
	BEGIN TRY
		INSERT INTO HIST_' + @table_name + 
		'
		SELECT NULL, * FROM inserted
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END'
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO


DROP PROC IF EXISTS usp_GenereerTriggerExecCode
GO

CREATE PROC usp_GenereerTriggerExecCode
AS
BEGIN
	BEGIN TRY
		SELECT 'EXEC usp_GenereerTrigger ''' + TABLE_NAME + ''''
		FROM [INFORMATION_SCHEMA].[TABLES]
		WHERE TABLE_NAME <> 'sysdiagrams' AND TABLE_NAME NOT LIKE 'hist_%'
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

EXEC usp_GenereerTriggerExecCode


-- Voor deze test moet de trigger TR_InsertDataInHist_grd bestaan
BEGIN TRAN
	SELECT * FROM grd

	INSERT INTO grd (grade, llimit, ulimit, bonus)
	VALUES (12, 11000.00, 20000.00, 6500.00)

	SELECT * FROM grd WHERE grade = 12
	SELECT * FROM HIST_grd
ROLLBACK TRAN