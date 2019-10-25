----------------------------------------------------------
/*														*/
/* Gemaakt door: Demi van Kesteren en Simon van Noppen  */
/*														*/
-------------------------------------------------------------------
/*	Gemaakte constraint van opdracht A en B zijn hierin verwerkt */
-------------------------------------------------------------------

-- ===================================================================
-- SQL Server DDL script:   am4dp_create.sql
--                    Creates the COURSE schema
--Based on example database AM4DP
--described in Applied Mathematics for Database Professionals (published by Apress, 2007) 
--written by Toon Koppelaars and Lex de Haan   

use COURSE; 

-- Een salarisschaal specificeert salarisinterval van minimaal 500 euro.
-- De ondergrens waarde van een salarisschaal (llimit) identificeert de schaal in kwestie. 
-- Oefeningen studenten eind week 1
 
 -- attribute constraints:
alter table grd add constraint  grd_chk_grad  check (grade  > 0);
alter table grd add constraint  grd_chk_llim  check (llimit > 0);
alter table grd add constraint  grd_chk_ulim  check (ulimit > 0);
alter table grd add constraint  grd_chk_bon1  check (bonus  > 0);

 -- tuple constraints:
 
alter table grd add constraint  grd_chk_bon2  check (bonus < llimit);
  --table constraints:
alter table grd add constraint  grd_pk        primary key (grade);
alter table grd add constraint  grd_unq2      unique (ulimit);
  -- attribute constraints: -- 
alter table emp add constraint  emp_chk_empno check (empno > 999);
alter table emp add constraint  emp_chk_job   check (job in ('PRESIDENT'
                                         ,'MANAGER'
                                         ,'SALESREP'
                                         ,'TRAINER'
                                         ,'ADMIN'  ));
alter table emp add constraint  emp_chk_brn    check (cast(born as date) = born);
alter table emp add constraint  emp_chk_hrd   check (cast(hired as date) = hired);
alter table emp add constraint  emp_chk_msal   check (msal > 0);
alter table emp add constraint  emp_chk_usrnm  check(upper(username) = username);
  -- tuple constraints:
  -- table constraints:
alter table emp add constraint  emp_pk        primary key (empno);
alter table emp add constraint  emp_unq1      unique (username);
  -- attribute constraints:
alter table srep add constraint  srp_chk_empno check (empno > 999);
alter table srep add constraint  srp_chk_targ  check (target > 9999);
alter table srep add constraint  srp_chk_comm  check (comm > 0);
  -- table constraints:
alter table srep add constraint  srp_pk        primary key (empno);
  -- attribute constraints:
alter table memp add constraint  mmp_chk_empno check (empno > 999);
alter table memp add constraint  mmp_chk_mgr   check (mgr > 999);
  -- tuple constraints:
alter table memp add constraint  mmp_chk_cycl  check (empno <> mgr); 
  -- table constraints:
alter table memp add constraint  mmp_pk        primary key (empno);
  -- attribute constraints:
alter table term add constraint  trm_chk_empno check (empno > 999);
alter table term add constraint  trm_chk_lft   check (cast(leftcomp as date) = leftcomp);
  -- tuple constraints:
  -- table constraints:
alter table term add constraint  trm_pk        primary key (empno);
  -- attribute constraints:
alter table dept add constraint  dep_chk_dno   check (deptno > 0);
alter table dept add constraint  dep_chk_dnm   check (upper(dname) = dname);
alter table dept add constraint  dep_chk_loc   check (upper(loc) = loc);
alter table dept add constraint  dep_chk_mgr   check (mgr > 999);
  -- tuple constraints:
  -- table constraints:
alter table dept add constraint  dep_pk        primary key (deptno);
alter table dept add constraint  dep_unq1      unique (dname,loc);
  -- attribute constraints:
alter table crs add constraint  reg_chk_code  check (code = upper(code));
alter table crs add constraint  reg_chk_cat   check (cat in ('GEN','BLD','DSG'));
alter table crs add constraint  reg_chk_dur1  check (dur between 1 and 15);
  -- tuple constraints:
alter table crs add constraint  reg_chk_dur2  check (cat <> 'BLD' OR dur <= 5);
  -- table constraints:
alter table crs add constraint  crs_pk        primary key (code);


-- Een cursus uitvoering (tabel OFFR) heeft altijd een trainer tenzij de status waarde 
-- aangeeft dat de cursus afgeblazen (status ‘CANC’) is of dat de cursus gepland is (status ‘SCHD’).  
-- Oefening studenten eind week 1

  -- attribute constraints:
alter table offr add constraint  ofr_chk_crse  check (course = upper(course));
alter table offr add constraint  ofr_chk_strs  check (cast(starts as date) = starts);
alter table offr add constraint  ofr_chk_stat  check (status in ('SCHD','CONF','CANC'));
alter table offr add constraint  ofr_chk_mxcp  check (maxcap between 6 and 99);
  -- tuple constraints:

  -- table constraints:
alter table offr add constraint  ofr_pk        primary key (course,starts);
alter table offr add constraint  ofr_unq       unique (starts,trainer);
  -- attribute constraints:
alter table reg add constraint  reg_chk_stud  check (stud > 999);
alter table reg add constraint  reg_chk_crse  check (course = upper(course));
alter table reg add constraint  reg_chk_strs  check (cast(starts as date) = starts);
alter table reg add constraint  reg_chk_eval  check (eval between -1 and 5);
  -- tuple constraints:
  -- table constraints:
alter table reg add constraint  reg_pk        primary key (stud,starts);
  -- attribute constraints:
alter table hist add constraint  hst_chk_eno   check (empno > 999);
alter table hist add constraint  hst_chk_unt   check (cast(until as date) = until);
alter table hist add constraint  hst_chk_dno   check (deptno > 0);
alter table hist add constraint  hst_chk_msal  check (msal > 0);
  -- tuple constraints:
  -- table constraints:
alter table hist add constraint  hst_pk        primary key (empno,until);
 -- database constraints:
alter table emp add constraint  emp_fk_grd    foreign key (sgrade)
                            references grd(grade) on update cascade;
alter table emp add constraint  emp_fk_dep foreign key (deptno)
										   references dept(deptno);
 -- database constraints:
alter table srep add constraint  srp_fk_emp    foreign key (empno)
                            references emp(empno) on delete cascade;
 -- database constraints:
alter table memp add constraint  mmp_fk1_emp   foreign key (empno)
                            references emp(empno);
alter table memp add constraint  mmp_fk2_emp   foreign key (mgr)
                            references emp(empno);
 -- database constraints:
alter table term add constraint  trm_fk_emp    foreign key (empno)
                            references emp(empno) on delete cascade;
alter table dept add constraint  dep_fk_emp    foreign key (mgr)
                            references emp(empno); 

 -- database constraints:
alter table offr add constraint  ofr_fk_crs    foreign key (course)
                            references crs(code) on update cascade;
alter table offr add  constraint  ofr_fk_emp    foreign key (trainer)
                            references emp(empno) on delete no action;
 -- database constraints:
alter table reg add constraint  reg_fk_emp    foreign key (stud)
                            references emp(empno) on delete cascade;
alter table reg add constraint  reg_fk_ofr    foreign key (course,starts)
                            references offr(course,starts);
 -- database constraints:
alter table hist add constraint  hst_fk_emp    foreign key (empno)
                            references emp(empno) on delete cascade;
alter table hist add constraint  hst_fk_dep    foreign key (deptno)
                            references dept(deptno);

use course
go

-- 1.	The president of the company earns more than $10.000 monthly.
ALTER TABLE emp
ADD CONSTRAINT CK_PRESIDENT_SAL CHECK (NOT(job = 'PRESIDENT' AND msal <= 10000))

-- 2.	A department that employs the president or a manager should also employ at least one administrator.

GO
create or alter TRIGGER TR_ADMIN_in_dept_where_MANAGER_or_PRESIDENT
ON emp
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	if @@ROWCOUNT >0
	BEGIN
	BEGIN TRY
		IF (select count(distinct deptno)
			from emp
			where (job = 'PRESIDENT' or job = 'MANAGER')
			and empno not in (select empno from term)
			and (deptno in (select deptno from inserted) or deptno in (select deptno from deleted)))
			<>
			(select count(distinct deptno)
			from emp
			where job = 'ADMIN'
			and empno not in (select empno from term)
			and deptno in (select distinct deptno
							from emp
							where (job = 'PRESIDENT' or job = 'MANAGER')
							and empno not in (select empno from term)
							and (deptno in (select deptno from inserted) or deptno in (select deptno from deleted))))
			RAISERROR('There must be an admin in the same department as a manager or the president',16,1)
			
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
	END
END
go
-- 3.	The company hires adult personnel only.

ALTER TABLE emp
ADD CONSTRAINT CK_PERSONNEL_AGE CHECK (born <= DATEADD(YY, -18, CURRENT_TIMESTAMP))


-- 4.	A salary grade overlaps with at most one lower salary grade. The llimit of a salary grade must be higher than the llimit of the next lower salary grade.
--		The ulimit of the salary grade must be higher than the ulimit of the next lower salary grade.
/*
	Er moet hier gekeken alleen naar de grade tabel en daar moet kijken of de waardes van 1 rij niet overlappen met meer dan 1 grade lager dan zijn eigen.
	Je hoeft niet naar boven te kijken want de grades boven zich kijken al of zij overlappen met hem.
	Verder moet hier ook gekeken worden of het laagste limiet van een grade wel hoger is dan het laagste limiet van de grade onder zich.
	Het zelfde telt voor de bovenste limiet.
*/

GO
CREATE or alter TRIGGER TR_insert_update_grade_constraints
ON grd
AFTER INSERT,UPDATE
AS
BEGIN
	if @@ROWCOUNT >0
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT *
				FROM inserted i
				WHERE exists(SELECT COUNT(*)
						FROM grd g
						WHERE i.llimit <= g.ulimit AND i.grade > g.grade
						having count(*)>1)
				or exists (SELECT COUNT(*)
							FROM grd g
							WHERE i.ulimit >= g.llimit and i.grade < g.grade
							having count(*) > 1))																						-- Hier wordt gekeken of een grade niet overlapt met meerdere andere grades onderzich er mag 1 grade overlap zijn.
			RAISERROR('Grade overlaps with multiple other grades',16,1)
		IF exists (select 1 from inserted i where exists (select 1 from grd g where i.llimit < g.llimit and i.grade > g.grade))	-- hier wordt gekeken of het lower limit van een grade wel groter is dan de lower limit van de grade onderzich.
			raiserror('lower limit of new grades is lower than lower limit of the grade 1 lower',16,1)
		IF exists (select 1 from inserted i where exists (select 1 from grd g where i.ulimit < g.ulimit and i.grade > g.grade))	-- hier wordt gekeken of het upper limit van een grade wel groter is dan de upper limit van de grade onderzich.
			raiserror('upper limit of new grades is lower than upper limit of the grade 1 lower',16,1)
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
	END
END

-- 5.	The start date and known trainer uniquely identify course offerings. Note: the use of a filtered index is not allowed.

GO
CREATE or alter TRIGGER TR_CheckStartAndTrainerUniquelyIdentifyCourseOffr
ON offr
AFTER INSERT, UPDATE
AS
BEGIN
	if @@ROWCOUNT >0
	BEGIN
	BEGIN TRY
		IF EXISTS(SELECT 1 
				FROM inserted I 
				WHERE EXISTS(SELECT 1 
							FROM offr O 
							WHERE I.starts = O.starts 
							AND I.trainer = O.trainer
							AND I.trainer IS NOT NULL
							AND O.trainer IS NOT NULL 
							HAVING COUNT(*) > 1))
			RAISERROR('The combination of start and trainer does already exists!', 16, 1)
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
	END
END
GO


-- 6.	Trainers cannot teach different courses simultaneously.
/*
Het is hier de bedoeling dat de leraar  niet meerdere courses tegelijk kan geven.
Er moet dus gekeken worden naar de start tijd van de nieuwe course en de eind tijd van de nieuwe course
en kijken of 1 van die 2 waardes tussen een andere course ziet die de leraar geeft.
*/

go
create or alter trigger TR_trainer_not_giving_multiple_courses_at_once
ON offr
AFTER INSERT,UPDATE
AS
BEGIN
	if @@ROWCOUNT >0
	BEGIN
	begin try
	if exists (select * from inserted i inner join crs c on c.code=i.course
				where exists (select 1
								from offr o inner join crs c1 on c1.code=o.course
								where ((i.starts >= o.starts and i.starts <= DATEADD(DD,c1.dur-1,o.starts))
								or (DATEADD(DD,c.dur-1,i.starts) >= o.starts and DATEADD(DD,c.dur-1,i.starts) <= DATEADD(DD,c1.dur-1,o.starts))
								or (o.starts >= i.starts and o.starts <= DATEADD(DD,c.dur-1,i.starts))
								or (DATEADD(DD,c1.dur-1,o.starts) >= i.starts and DATEADD(DD,c1.dur-1,o.starts) <= DATEADD(DD,c.dur-1,i.starts)))
								and i.trainer = o.trainer
								and not (i.course = o.course and i.starts = o.starts)))
		raiserror('A Trainer is giving 2 courses at the same time',16,1)
	end try
	begin catch
		throw
	end catch
	END
END

-- 7.	An active employee cannot be managed by a terminated employee. 
-- insert proc

GO
CREATE or alter PROC usp_CheckInsertedManagerIsTerminated
	@empno	NUMERIC(4),
	@mgr	NUMERIC(4)
AS
BEGIN
	declare @tr_name varchar(10) = 'none'
	BEGIN TRY
		if @@trancount > 0
			begin
				set @tr_name = 'yep'
				save tran @tr_name
			end 
		else 
			begin
				begin tran
			end

		-- START SQL CODE
		IF @mgr IN (SELECT empno FROM term)
			RAISERROR('Cannot insert manager, since he/she is terminated', 16, 1)
		INSERT INTO memp (empno, mgr) VALUES (@empno, @mgr)
		-- END SQL CODE

		if @tr_name = 'none' 
			COMMIT TRAN
	END TRY
	BEGIN CATCH
		if @tr_name = 'none'
			ROLLBACK TRAN
		else
			rollback tran @tr_name
			;throw
	END CATCH
END
GO

-- update proc
GO
CREATE or alter PROC usp_CheckUpdatedManagerIsTerminated
	@oldmgr	NUMERIC(4),
	@newmgr	NUMERIC(4),
	@empno	NUMERIC(4)
AS
BEGIN
	declare @tr_name varchar(10) = 'none'
	BEGIN TRY
		if @@trancount > 0
			begin
				set @tr_name = 'yep'
				save tran @tr_name
			end 
		else 
			begin
				begin tran
			end

		-- START SQL CODE
		IF @newmgr IN (SELECT empno FROM term)
					RAISERROR('Cannot update manager, since he/she is terminated', 16, 1)
				ELSE 
					IF @oldmgr IS NULL AND @empno IS NULL
						RAISERROR('Cannot update, since there are no values to update', 16, 1)
					ELSE IF @oldmgr IS NULL AND @empno IS NOT NULL		
						UPDATE memp			
						SET mgr = @newmgr
						WHERE empno = @empno
					ELSE IF @oldmgr IS NOT NULL AND @empno IS NULL	
						UPDATE memp
						SET mgr = @newmgr
						WHERE mgr = @oldmgr
					ELSE IF @oldmgr IS NOT NULL AND @empno IS NOT NULL
						UPDATE memp
						SET mgr = @newmgr
						WHERE mgr = @oldmgr AND empno = @empno
		-- END SQL CODE

		if @tr_name = 'none' 
			COMMIT TRAN
	END TRY
	BEGIN CATCH
		if @tr_name = 'none'
			ROLLBACK TRAN
		else
			rollback tran @tr_name
			;throw
	END CATCH
END
GO


-- 8.	A trainer cannot register for a course offering taught by him- or herself.
-- AANAMEN Deze is slecht beschreven dus wij hebben aangenomen dat een student van de course niet de leraar van precies die course op dat moment mag zijn.
/*
=================================================
|	student		| Teacher			|	allowed	|
|	A number	|	same number		|	no		|
|	A number	|	diffrent number	|	yes		|
=================================================
*/
create or alter trigger TR_teacher_cant_be_a_student_of_own_course
on reg
AFTER INSERT,UPDATE
AS
BEGIN
	if @@ROWCOUNT >0
	BEGIN
	begin try
		if exists (select *																-- kijkt of de leraar zijn eigen course wilt volgen zo ja error.
					from inserted r
					where exists (select 1
								from offr o
								where stud = trainer									-- kijkt of de student ook de leraar is.
								and (r.course = o.course and o.starts=r.starts)))		-- zorgt ervoor dat die de tabellen aan elkaar verbindt met de primary key.
			raiserror('Leraar probeert zijn eigen course te doen',16,1)
	end try
	begin catch
		throw
	end catch
	END
end

-- 9.	At least half of the course offerings (measured by duration) taught by a trainer must be ‘home based’. Note: ‘Home based’ means the course is offered at the 
--      same location where the employee is employed.
-- insert
GO
CREATE or alter PROC usp_CheckInsertedOfferingHalfHomeBased
	@course		VARCHAR(6),
	@starts		DATE,
	@status		VARCHAR(4),
	@maxcap		NUMERIC(2),
	@trainer	NUMERIC(4),
	@loc		VARCHAR(14)
AS
BEGIN
	declare @tr_name varchar(10) = 'none'
	BEGIN TRY
		if @@trancount > 0
			begin
				set @tr_name = 'yep'
				save tran @tr_name
			end 
		else 
			begin
				begin tran
			end
	-- START SQL CODE
	DECLARE @total_duration_all_locations NUMERIC(2) = (
				SELECT SUM(C.dur)
				FROM offr O INNER JOIN crs C ON O.course = C.code
				WHERE O.trainer = @trainer
			)
			DECLARE @total_duration_home_based NUMERIC(2) = (
				SELECT SUM(C.dur)
				FROM offr O INNER JOIN crs C ON O.course = C.code
				INNER JOIN emp E ON O.trainer = E.empno
				INNER JOIN dept D ON E.deptno = D.deptno
				WHERE O.trainer = @trainer AND D.loc = O.loc
			)
			DECLARE @dur_course NUMERIC(2) = (
				SELECT dur FROM crs WHERE code = @course
			)
			DECLARE @new_total_duration_all_locations NUMERIC(2) = (
				@total_duration_all_locations + @dur_course
			)
			DECLARE @new_total_duration_home_based NUMERIC(2)
			IF @loc = (SELECT DISTINCT D.loc 
						FROM dept D INNER JOIN emp E ON D.deptno = E.deptno
						INNER JOIN offr O ON O.trainer = E.empno
						WHERE O.trainer = @trainer)
				SET @new_total_duration_home_based = (
					@total_duration_home_based + @dur_course)
			ELSE
				SET @new_total_duration_home_based = @total_duration_home_based
			IF @new_total_duration_home_based >= @new_total_duration_all_locations/2
				INSERT INTO offr (course, starts, [status], maxcap, trainer, loc)
				VALUES (@course, @starts, @status, @maxcap, @trainer, @loc)
			ELSE
				RAISERROR('By adding this offer, half of the total duration is no longer home-based', 16, 1)
	-- END SQL CODE

		if @tr_name = 'none' 
			COMMIT TRAN
	END TRY
	BEGIN CATCH
		if @tr_name = 'none'
			ROLLBACK TRAN
		else
			rollback tran @tr_name
			;throw
	END CATCH
END
GO

-- update
GO
CREATE or alter PROC usp_CheckUpdatedOfferingHalfHomeBased
	@course		VARCHAR(6),
	@starts		DATE,
	@trainer	NUMERIC(4),
	@old_loc	VARCHAR(14),
	@new_loc	VARCHAR(14)
AS
BEGIN
	declare @tr_name varchar(10) = 'none'
	BEGIN TRY
		if @@trancount > 0
			begin
				set @tr_name = 'yep'
				save tran @tr_name
			end 
		else 
			begin
				begin tran
			end

	-- START SQL CODE
	DECLARE @total_duration_all_locations NUMERIC(2) = (																	-- Declare set variable containing sum of course durations of all locations
				SELECT SUM(C.dur)
				FROM offr O INNER JOIN crs C ON O.course = C.code
				WHERE O.trainer = @trainer
			)

			DECLARE @total_duration_home_based NUMERIC(2) = (																		-- Declare and set variable containing sum of course durations of home-based locations
				SELECT SUM(C.dur)
				FROM offr O INNER JOIN crs C ON O.course = C.code
							INNER JOIN emp E ON O.trainer = E.empno
							INNER JOIN dept D ON E.deptno = D.deptno
				WHERE O.trainer = @trainer AND D.loc = O.loc
			)

			DECLARE @dur_course NUMERIC(2) = (																						-- Declare and set variable containing the duration of the course
				SELECT dur FROM crs WHERE code = @course
			)

			DECLARE @new_total_duration_all_locations NUMERIC(2) = (																-- Declare and set variable containing sum of course durations of all locations + course duration
				@total_duration_all_locations + @dur_course
			)

			DECLARE @new_total_duration_home_based NUMERIC(2)																		-- Declare variable

			IF @new_loc = (SELECT DISTINCT D.loc																					-- If new location is home-based
					   FROM dept D INNER JOIN emp E ON D.deptno = E.deptno
								   INNER JOIN offr O ON O.trainer = E.empno
					   WHERE O.trainer = @trainer)
				SET @new_total_duration_home_based = (																				-- Set variable containing sum of course duration of home-based locations + course duration
					@total_duration_home_based + @dur_course
				)
			ELSE																													-- Else if location is not home-based
				SET @new_total_duration_home_based = @total_duration_home_based														-- Set variable containing sum of course duration of home-based locations

			IF @new_total_duration_home_based >= @new_total_duration_all_locations / 2												-- If half is home-based
				UPDATE offr																											-- Update loc
				SET loc = @new_loc
				WHERE course = @course 
				  AND starts = @starts
				  AND trainer = @trainer 
				  AND loc = @old_loc
			ELSE																													-- Else if half is not home-based
				RAISERROR('By updating the location of this offer, half of the total duration will no longer be home-based', 16, 1)
	-- END SQL CODE

		if @tr_name = 'none' 
			COMMIT TRAN
	END TRY
	BEGIN CATCH
		if @tr_name = 'none'
			ROLLBACK TRAN
		else
			rollback tran @tr_name
			;throw
	END CATCH
END
GO


-- 10.	Offerings with 6 or more registrations must have status confirmed.
/*
=====================================================
|	amount of reg	| status of offr	|	allowed	|
|	>5				|	CONF			|	yes		|
|	<=5				|	CONF			|	yes		|
|	>5				|	ELSE			|	no		|
|	<=5				|	ELSE			|	yes		|
=====================================================
*/

create or alter trigger TR_offer_not_confirmed_yet
on reg
after insert,update
as
begin
	if @@ROWCOUNT >0
	BEGIN
	begin try
		if exists (select 1																						-- kijkt of er al meer dan 5 registraties zijn zo ja error.
					from offr o join inserted i on o.course=i.course and o.starts=i.starts
					where exists (select count(*)
									from reg r																	-- zorgt ervoor dat die alleen de nieuwe courses pakt.
									where r.starts = o.starts and r.course = o.course							-- zorgt ervoor dat die verbindt met de offr tabel
									having count(*) > 5)														-- kijkt of er niet al meer dan 5 registraties zijn.
					and status not in ('CONF'))
			raiserror('The offer is not yet confirmed so there can not be more than 5 registrations',16,1)
	end try
	begin catch
		throw
	end catch
	end
end

-- 11.	You are allowed to teach a course only if:
--      your job type is trainer and
--      -      you have been employed for at least one year 
--      -	   or you have attended the course yourself (as participant) 

GO
CREATE OR ALTER TRIGGER TR_CheckPersonIsAllowedToTeachCourse
ON offr
AFTER INSERT, UPDATE
AS
BEGIN
	if @@ROWCOUNT >0
	BEGIN
    BEGIN TRY
        IF (EXISTS(SELECT 1 FROM inserted I WHERE EXISTS(SELECT 1 FROM emp E WHERE I.trainer = E.empno AND E.job <> 'TRAINER'))
            OR
            (EXISTS(SELECT 1 FROM inserted I WHERE EXISTS(SELECT 1 FROM emp E WHERE I.trainer = E.empno AND E.job = 'TRAINER')
             AND
             EXISTS(SELECT 1 FROM inserted I WHERE EXISTS(SELECT 1 FROM emp E WHERE I.trainer = E.empno AND hired > DATEADD(YY, -1, CURRENT_TIMESTAMP))
             AND 
             NOT EXISTS(SELECT 1 FROM reg R WHERE I.trainer = R.stud AND R.course = I.course)))))
            RAISERROR('This employee does not meet the requirements to become a trainer', 16, 1)
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
	END
END
GO

-- Constraint 2
GO
create or alter TRIGGER TR_ADMIN_in_dept_where_MANAGER_or_PRESIDENT
ON emp
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	if @@ROWCOUNT >0
	BEGIN
	BEGIN TRY
		IF (select count(distinct deptno)
			from emp
			where (job = 'PRESIDENT' or job = 'MANAGER')
			and empno not in (select empno from term)
			and (deptno in (select deptno from inserted) or deptno in (select deptno from deleted)))
			<>
			(select count(distinct deptno)
			from emp
			where job = 'ADMIN'
			and empno not in (select empno from term)
			and deptno in (select distinct deptno
							from emp
							where (job = 'PRESIDENT' or job = 'MANAGER')
							and empno not in (select empno from term)
							and (deptno in (select deptno from inserted) or deptno in (select deptno from deleted))))
			RAISERROR('There must be an admin in the same department as a manager or the president',16,1)
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
	END
END
go