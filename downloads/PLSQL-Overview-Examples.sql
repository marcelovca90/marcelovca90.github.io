------------
-- TABLES --
------------

CREATE TABLE EVALUATIONS (
  EVALUATION_ID    NUMBER(8,0), 
  EMPLOYEE_ID      NUMBER(6,0), 
  EVALUATION_DATE  DATE, 
  JOB_ID           VARCHAR2(10), 
  MANAGER_ID       NUMBER(6,0), 
  DEPARTMENT_ID    NUMBER(4,0),
  TOTAL_SCORE      NUMBER(3,0)
);

CREATE TABLE SCORES (
  EVALUATION_ID   NUMBER(8,0), 
  PERFORMANCE_ID  VARCHAR2(2), 
  SCORE           NUMBER(1,0)
);

CREATE TABLE PERFORMANCE_PARTS 
(	
  PERFORMANCE_ID VARCHAR2(2), 
  NAME VARCHAR2(20), 
  WEIGHT NUMBER
)

-----------------
-- CONSTRAINTS --
-----------------

ALTER TABLE EVALUATIONS
ADD CONSTRAINT EVAL_EVAL_ID_PK PRIMARY KEY (EVALUATION_ID);

ALTER TABLE EVALUATIONS
ADD CONSTRAINT EVAL_EMP_ID_FK FOREIGN KEY (EMPLOYEE_ID)
REFERENCES EMPLOYEES (EMPLOYEE_ID);

ALTER TABLE PERFORMANCE_PARTS
ADD CONSTRAINT PERF_PERF_ID_PK PRIMARY KEY (PERFORMANCE_ID);

-------------
-- INDEXES --
-------------

CREATE INDEX EVAL_JOB_IX
ON EVALUATIONS (JOB_ID ASC) NOPARALLEL;

DROP INDEX EVAL_JOB_ID;

---------------
-- SEQUENCES --
---------------

CREATE SEQUENCE evaluations_sequence
INCREMENT BY 1
START WITH 1 ORDER;

----------------
-- PROCEDURES --
----------------

CREATE OR REPLACE PROCEDURE ADD_EVALUATION
(
  EVALUATION_ID IN NUMBER
, EMPLOYEE_ID IN NUMBER
, EVALUATION_DATE IN DATE
, JOB_ID IN VARCHAR2
, MANAGER_ID IN NUMBER
, DEPARTMENT_ID IN NUMBER
, TOTAL_SCORE IN NUMBER
) AS
BEGIN
  INSERT INTO EVALUATIONS
  (
	evaluation_id,
	employee_id,
	evaluation_date,
	job_id,
	manager_id,
	department_id,
	total_score 
  )
  VALUES 
  (
	ADD_EVALUATION.evaluation_id,
	ADD_EVALUATION.employee_id,
	ADD_EVALUATION.evaluation_date,
	ADD_EVALUATION.job_id,
	ADD_EVALUATION.manager_id,
	ADD_EVALUATION.department_id,
	ADD_EVALUATION.total_score
  );
END ADD_EVALUATION;

---------------
-- FUNCTIONS --
--------------- 

CREATE OR REPLACE FUNCTION CALCULATE_SCORE
(
  CAT IN VARCHAR2
, SCORE IN NUMBER
, WEIGHT IN NUMBER
) RETURN NUMBER AS
BEGIN
  RETURN score * weight;
END CALCULATE_SCORE;

---------------------------
-- PACKAGE SPECIFICATION --
---------------------------

CREATE OR REPLACE PACKAGE emp_eval AS
 
  PROCEDURE eval_department ( dept_id IN NUMBER );
  
  FUNCTION calculate_score ( evaluation_id IN NUMBER
                           , performance_id IN NUMBER)
                           RETURN NUMBER;
   
END emp_eval;

------------------
-- PACKAGE BODY --
------------------

CREATE OR REPLACE
PACKAGE BODY EMP_EVAL AS
 
  PROCEDURE eval_department ( dept_id IN NUMBER ) AS
  BEGIN
    -- TODO implementation required for PROCEDURE EMP_EVAL.eval_department
    NULL;
  END eval_department;
 
  FUNCTION calculate_score ( evaluation_id IN NUMBER
                           , performance_id IN NUMBER)
                           RETURN NUMBER AS
  BEGIN
    -- TODO implementation required for FUNCTION EMP_EVAL.calculate_score
    RETURN NULL;
  END calculate_score;
END EMP_EVAL;

-----------------------------
-- VARIABLES AND CONSTANTS --
-----------------------------

CREATE OR REPLACE PACKAGE emp_eval AS
 
  PROCEDURE eval_department ( dept_id IN NUMBER );
  
  FUNCTION calculate_score(evaluation_id IN scores.evaluation_id%TYPE
                          , performance_id IN scores.performance_id%TYPE)
                           RETURN NUMBER;
   
END emp_eval;

CREATE OR REPLACE PACKAGE BODY EMP_EVAL AS
 
  PROCEDURE eval_department ( dept_id IN NUMBER ) AS
  BEGIN
    -- TODO implementation required for PROCEDURE EMP_EVAL.eval_department
    NULL;
  END eval_department;
 
  FUNCTION calculate_score ( evaluation_id IN SCORES.EVALUATION_ID%TYPE
                            , performance_id IN SCORES.PERFORMANCE_ID%TYPE)
                            RETURN NUMBER AS
  n_score       SCORES.SCORE%TYPE;
  n_weight      PERFORMANCE_PARTS.WEIGHT%TYPE;
  max_score     CONSTANT SCORES.SCORE%TYPE := 9;
  max_weight    CONSTANT PERFORMANCE_PARTS.WEIGHT%TYPE := 1;
  BEGIN
    -- TODO implementation required for FUNCTION EMP_EVAL.calculate_score
    RETURN NULL;
  END calculate_score;
END EMP_EVAL;

------------------------------------------------------------------
-- ASSIGNING VALUES TO VARIABLES WITH THE SELECT INTO STATEMENT --
------------------------------------------------------------------

CREATE OR REPLACE FUNCTION calculate_score ( evaluation_id IN scores.evaluation_id%TYPE
                         , performance_id IN scores.performance_id%TYPE )
                         RETURN NUMBER AS
  n_score       scores.score%TYPE;
  n_weight      performance_parts.weight%TYPE;
  running_total NUMBER := 0;
  max_score     CONSTANT scores.score%TYPE := 9;
  max_weight    CONSTANT performance_parts.weight%TYPE:= 1;
BEGIN
  SELECT s.score INTO n_score
  FROM SCORES s
  WHERE evaluation_id = s.evaluation_id 
  AND performance_id = s.performance_id;
  SELECT p.weight INTO n_weight
    FROM PERFORMANCE_PARTS p
    WHERE performance_id = p.performance_id;
	
  running_total := n_score * n_weight;
  RETURN running_total;
END calculate_score;

----------------------------------------------------------
-- INSERTING A TABLE ROW WITH VALUES FROM ANOTHER TABLE --
----------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_eval ( employee_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
                   , today IN DATE )
AS
  job_id         EMPLOYEES.JOB_ID%TYPE;
  manager_id     EMPLOYEES.MANAGER_ID%TYPE;
  department_id  EMPLOYEES.DEPARTMENT_ID%TYPE;
BEGIN
  INSERT INTO EVALUATIONS (
    evaluation_id,
    employee_id,
    evaluation_date,
    job_id,
    manager_id,
    department_id,
    total_score
  )
  SELECT
    evaluations_sequence.NEXTVAL,   -- evaluation_id
    add_eval.employee_id,      -- employee_id
    add_eval.today,            -- evaluation_date
    e.job_id,                  -- job_id
    e.manager_id,              -- manager_id
    e.department_id,           -- department_id
    0                          -- total_score
  FROM employees e;
  IF SQL%ROWCOUNT = 0 THEN
    RAISE NO_DATA_FOUND;
  END IF;
END add_eval;

----------------------------
-- FLOW CONTROL - IF/ELSE --
----------------------------

CREATE OR REPLACE FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date     EMPLOYEES.HIRE_DATE%TYPE;
  today      EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq  PLS_INTEGER;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE INTO h_date
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = eval_frequency.emp_id;
  IF ((h_date + (INTERVAL '120' MONTH)) < today) THEN
    eval_freq := 1;
  ELSE
    eval_freq := 2;
  END IF;
  RETURN eval_freq;
END eval_frequency;

-------------------------
-- FLOW CONTROL - CASE --
-------------------------

CREATE OR REPLACE FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date     EMPLOYEES.HIRE_DATE%TYPE;
  today      EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq  PLS_INTEGER;
  j_id       EMPLOYEES.JOB_ID%TYPE;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE, JOB_ID INTO h_date, j_id
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = eval_frequency.emp_id;
  IF ((h_date + (INTERVAL '12' MONTH)) < today) THEN
    eval_freq := 1;
    CASE j_id
       WHEN 'PU_CLERK' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 8% salary increase for employee # ' || emp_id);
       WHEN 'SH_CLERK' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 7% salary increase for employee # ' || emp_id);
       WHEN 'ST_CLERK' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 6% salary increase for employee # ' || emp_id);
       WHEN 'HR_REP' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 5% salary increase for employee # ' || emp_id);
       WHEN 'PR_REP' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 5% salary increase for employee # ' || emp_id);
       WHEN 'MK_REP' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 4% salary increase for employee # ' || emp_id);
       ELSE DBMS_OUTPUT.PUT_LINE(
         'Nothing to do for employee #' || emp_id);
    END CASE;
  ELSE
    eval_freq := 2;
  END IF;
 
  RETURN eval_freq;
END eval_frequency;
  
-----------------------------
-- FLOW CONTROL - FOR LOOP --
-----------------------------

CREATE OR REPLACE FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date      EMPLOYEES.HIRE_DATE%TYPE;
  today       EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq   PLS_INTEGER;
  j_id        EMPLOYEES.JOB_ID%TYPE;
  sal         EMPLOYEES.SALARY%TYPE;
  sal_raise   NUMBER(3,3) := 0;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE, JOB_ID, SALARY INTO h_date, j_id, sal
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = eval_frequency.emp_id;
  IF ((h_date + (INTERVAL '12' MONTH)) < today) THEN
    eval_freq := 1;
    CASE j_id
      WHEN 'PU_CLERK' THEN sal_raise := 0.08;
      WHEN 'SH_CLERK' THEN sal_raise := 0.07;
      WHEN 'ST_CLERK' THEN sal_raise := 0.06;
      WHEN 'HR_REP'   THEN sal_raise := 0.05;
      WHEN 'PR_REP'   THEN sal_raise := 0.05;
      WHEN 'MK_REP'   THEN sal_raise := 0.04;
      ELSE NULL;
    END CASE;
    IF (sal_raise != 0) THEN
      BEGIN
        DBMS_OUTPUT.PUT_LINE('If salary ' || sal || ' increases by ' ||
          ROUND((sal_raise * 100),0) ||
          '% each year for 5 years, it will be:');
        FOR i IN 1..5 LOOP
          sal := sal * (1 + sal_raise);
          DBMS_OUTPUT.PUT_LINE(ROUND(sal, 2) || ' after ' || i || ' year(s)');
        END LOOP;
      END;
    END IF;
  ELSE
    eval_freq := 2;
  END IF;
  RETURN eval_freq;
END eval_frequency;

-------------------------------
-- FLOW CONTROL - WHILE LOOP --
-------------------------------

CREATE OR REPLACE FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date      EMPLOYEES.HIRE_DATE%TYPE;
  today       EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq   PLS_INTEGER;
  j_id        EMPLOYEES.JOB_ID%TYPE;
  sal         EMPLOYEES.SALARY%TYPE;
  sal_raise   NUMBER(3,3) := 0;
  sal_max     JOBS.MAX_SALARY%TYPE;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE, j.JOB_ID, SALARY, MAX_SALARY INTO h_date, j_id, sal, sal_max
  FROM EMPLOYEES e, JOBS j
  WHERE EMPLOYEE_ID = eval_frequency.emp_id AND JOB_ID = eval_frequency.j_id;
  IF ((h_date + (INTERVAL '12' MONTH)) < today) THEN
    eval_freq := 1;
    CASE j_id
      WHEN 'PU_CLERK' THEN sal_raise := 0.08;
      WHEN 'SH_CLERK' THEN sal_raise := 0.07;
      WHEN 'ST_CLERK' THEN sal_raise := 0.06;
      WHEN 'HR_REP'   THEN sal_raise := 0.05;
      WHEN 'PR_REP'   THEN sal_raise := 0.05;
      WHEN 'MK_REP'   THEN sal_raise := 0.04;
      ELSE NULL;
    END CASE;
    IF (sal_raise != 0) THEN
      BEGIN
        DBMS_OUTPUT.PUT_LINE('If salary ' || sal || ' increases by ' ||
          ROUND((sal_raise * 100),0) ||
          '% each year, it will be:');
        WHILE sal <= sal_max LOOP
          sal := sal * (1 + sal_raise);
          DBMS_OUTPUT.PUT_LINE(ROUND(sal, 2));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Maximum salary for this job is ' || sal_max);
      END;
    END IF;
  ELSE
    eval_freq := 2;
  END IF;
 
  RETURN eval_freq;
END eval_frequency;

-------------------------------------------
-- FLOW CONTROL - BASIC LOOP & EXIT WHEN --
-------------------------------------------

CREATE OR REPLACE FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date      EMPLOYEES.HIRE_DATE%TYPE;
  today       EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq   PLS_INTEGER;
  j_id        EMPLOYEES.JOB_ID%TYPE;
  sal         EMPLOYEES.SALARY%TYPE;
  sal_raise   NUMBER(3,3) := 0;
  sal_max     JOBS.MAX_SALARY%TYPE;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE, j.JOB_ID, SALARY, MAX_SALARY INTO h_date, j_id, sal, sal
  FROM EMPLOYEES e, JOBS j
  WHERE EMPLOYEE_ID = eval_frequency.emp_id AND JOB_ID = eval_frequency.j_id
  IF ((h_date + (INTERVAL '12' MONTH)) < today) THEN
    eval_freq := 1;
    CASE j_id
      WHEN 'PU_CLERK' THEN sal_raise := 0.08;
      WHEN 'SH_CLERK' THEN sal_raise := 0.07;
      WHEN 'ST_CLERK' THEN sal_raise := 0.06;
      WHEN 'HR_REP'   THEN sal_raise := 0.05;
      WHEN 'PR_REP'   THEN sal_raise := 0.05;
      WHEN 'MK_REP'   THEN sal_raise := 0.04;
      ELSE NULL;
    END CASE;
    IF (sal_raise != 0) THEN
      BEGIN
        DBMS_OUTPUT.PUT_LINE('If salary ' || sal || ' increases by ' ||
          ROUND((sal_raise * 100),0) ||
          '% each year, it will be:');
		LOOP
          sal := sal * (1 + sal_raise);
          EXIT WHEN sal > sal_max;
          DBMS_OUTPUT.PUT_LINE(ROUND(sal,2));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Maximum salary for this job is ' || sal_max);
      END;
    END IF;
  ELSE
    eval_freq := 2;
  END IF;
 
  RETURN eval_freq;
END eval_frequency;

--------------------------
-- CREATING RECORD TYPE --
--------------------------

CREATE OR REPLACE PACKAGE EMP_EVAL AS

  PROCEDURE eval_department(dept_id IN NUMBER);
  
  FUNCTION calculate_score(evaluation_id IN NUMBER
                        , performance_id IN NUMBER)
                          RETURN NUMBER;
						  
  TYPE sal_info IS RECORD
  ( j_id     jobs.job_id%type
  , sal_min  jobs.min_salary%type
  , sal_max  jobs.max_salary%type
  , sal      employees.salary%type
  , sal_raise NUMBER(3,3) );
  
END EMP_EVAL;

----------------------------------------------------------------
-- Creating and Invoking a Subprogram with a Record Parameter --
----------------------------------------------------------------

PROCEDURE salary_schedule (emp IN sal_info) AS
  accumulating_sal  NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('If salary ' || emp.sal || 
    ' increases by ' || ROUND((emp.sal_raise * 100),0) || 
    '% each year, it will be:');
  accumulating_sal := emp.sal;
  WHILE accumulating_sal <= emp.sal_max LOOP
    accumulating_sal := accumulating_sal * (1 + emp.sal_raise);
    DBMS_OUTPUT.PUT_LINE(ROUND(accumulating_sal,2) ||', ');
  END LOOP;
END salary_schedule;

FUNCTION eval_frequency (emp_id EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date     EMPLOYEES.HIRE_DATE%TYPE;
  today      EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq  PLS_INTEGER;
  emp_sal    SAL_INFO;  -- replaces sal, sal_raise, and sal_max
  
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
   
  SELECT HIRE_DATE INTO h_date
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = eval_frequency.emp_id;
 
  IF ((h_date + (INTERVAL '120' MONTH)) < today) THEN
     eval_freq := 1;
 
     /* populate emp_sal */
 
     SELECT j.JOB_ID, j.MIN_SALARY, j.MAX_SALARY, e.SALARY
     INTO emp_sal.j_id, emp_sal.sal_min, emp_sal.sal_max, emp_sal.sal
     FROM EMPLOYEES e, JOBS j
     WHERE e.EMPLOYEE_ID = eval_frequency.emp_id
     AND j.JOB_ID = eval_frequency.emp_id;
 
     emp_sal.sal_raise := 0;  -- default
 
     CASE emp_sal.j_id
       WHEN 'PU_CLERK' THEN emp_sal.sal_raise := 0.08;
       WHEN 'SH_CLERK' THEN emp_sal.sal_raise := 0.07;
       WHEN 'ST_CLERK' THEN emp_sal.sal_raise := 0.06;
       WHEN 'HR_REP' THEN emp_sal.sal_raise := 0.05;
       WHEN 'PR_REP' THEN emp_sal.sal_raise := 0.05;
       WHEN 'MK_REP' THEN emp_sal.sal_raise := 0.04;
       ELSE NULL;
     END CASE;
 
     IF (emp_sal.sal_raise != 0) THEN
       salary_schedule(emp_sal);
     END IF;
   ELSE
     eval_freq := 2;
   END IF;
 
   RETURN eval_freq;
END eval_frequency;

-----------------------------------------------------------------------
-- Using a Declared Cursor to Retrieve Result Set Rows One at a Time --
-----------------------------------------------------------------------

PROCEDURE eval_department(dept_id IN employees.department_id%TYPE);

PROCEDURE eval_department (dept_id IN employees.department_id%TYPE)
AS
  CURSOR emp_cursor IS
    SELECT * FROM EMPLOYEES
    WHERE DEPARTMENT_ID = eval_department.dept_id;
  emp_record  EMPLOYEES%ROWTYPE;  -- for row returned by cursor
  all_evals   BOOLEAN;  -- true if all employees in dept need evaluations
  today       DATE;
BEGIN
  today := SYSDATE;
  IF (EXTRACT(MONTH FROM today) < 6) THEN
    all_evals := FALSE; -- only new employees need evaluations
  ELSE
    all_evals := TRUE;  -- all employees need evaluations
  END IF;
  OPEN emp_cursor;
  DBMS_OUTPUT.PUT_LINE (
    'Determining evaluations necessary in department # ' || dept_id );
  LOOP
    FETCH emp_cursor INTO emp_record;
    EXIT WHEN emp_cursor%NOTFOUND;
    IF all_evals THEN
      add_eval(emp_record.employee_id, today);
    ELSIF (eval_frequency(emp_record.employee_id) = 2) THEN
      add_eval(emp_record.employee_id, today);
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Processed ' || emp_cursor%ROWCOUNT || ' records.');
  CLOSE emp_cursor;
END eval_department;

-------------------------------------------------
-- Declaring and Populating Associative Arrays --
-------------------------------------------------

DECLARE
  -- Declare cursor:
  CURSOR employees_jobs_cursor IS
    SELECT FIRST_NAME, LAST_NAME, JOB_ID
    FROM EMPLOYEES
    ORDER BY JOB_ID, LAST_NAME, FIRST_NAME;
  -- Declare associative array type:
  TYPE employees_jobs_type IS TABLE OF employees_jobs_cursor%ROWTYPE
    INDEX BY PLS_INTEGER;
  -- Declare associative array:
  employees_jobs  employees_jobs_type;
  -- Use same procedure to declare another associative array:
  CURSOR jobs_cursor IS
    SELECT JOB_ID, JOB_TITLE
    FROM JOBS;
  TYPE jobs_type IS TABLE OF jobs_cursor%ROWTYPE
    INDEX BY PLS_INTEGER;
  jobs_  jobs_type;
-- Declare associative array without using cursor:
  TYPE job_titles_type IS TABLE OF JOBS.JOB_TITLE%TYPE
    INDEX BY JOBS.JOB_ID%TYPE;  -- jobs.job_id%type is varchar2(10)
  job_titles  job_titles_type;
BEGIN
  -- Populate associative arrays indexed by integer:
SELECT FIRST_NAME, LAST_NAME, JOB_ID BULK COLLECT INTO employees_jobs
  FROM EMPLOYEES ORDER BY JOB_ID, LAST_NAME, FIRST_NAME;
SELECT JOB_ID, JOB_TITLE BULK COLLECT INTO jobs_ FROM JOBS;
  -- Populate associative array indexed by string:
  FOR i IN 1..jobs_.COUNT() LOOP
    job_titles(jobs_(i).job_id) := jobs_(i).job_title;
  END LOOP;
END;

-----------------------------------------
-- Traversing Dense Associative Arrays --
-----------------------------------------

-- Code that populates employees_jobs must precede this code:
FOR i IN 1..employees_jobs.COUNT LOOP
  DBMS_OUTPUT.PUT_LINE(
    RPAD(employees_jobs(i).first_name, 23) ||
    RPAD(employees_jobs(i).last_name,  28) ||     employees_jobs(i).job_id);
END LOOP;

------------------------------------------
-- Traversing Sparse Associative Arrays --
------------------------------------------
  
-- Declare the following variable in declarative part:
-- i jobs.job_id%TYPE
i := job_titles.FIRST;
WHILE i IS NOT NULL LOOP
  DBMS_OUTPUT.PUT_LINE(RPAD(i, 12) || job_titles(i));
  i := job_titles.NEXT(i);
END LOOP;

------------------------------------
-- Handling Predefined Exceptions --
------------------------------------

PROCEDURE eval_department(dept_id IN employees.department_id%TYPE) AS
  emp_cursor    emp_refcursor_type;
  current_dept  departments.department_id%TYPE;
BEGIN
  current_dept := dept_id;
  FOR loop_c IN 1..3 LOOP
    OPEN emp_cursor FOR
      SELECT * 
      FROM employees
      WHERE current_dept = eval_department.dept_id;
    DBMS_OUTPUT.PUT_LINE
      ('Determining necessary evaluations in department #' ||
       current_dept);
    eval_loop_control(emp_cursor);
    DBMS_OUTPUT.PUT_LINE
      ('Processed ' || emp_cursor%ROWCOUNT || ' records.');
    CLOSE emp_cursor;
    current_dept := current_dept + 10; 
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('The query did not return a result set');
END eval_department;

----------------------------------------------------
-- Declaring and Handling User-Defined Exceptions --
----------------------------------------------------

FUNCTION calculate_score ( evaluation_id IN scores.evaluation_id%TYPE
                         , performance_id IN scores.performance_id%TYPE )
                         RETURN NUMBER AS
  weight_wrong  EXCEPTION;
  score_wrong   EXCEPTION;
  n_score       scores.score%TYPE;
  n_weight      performance_parts.weight%TYPE;
  running_total NUMBER := 0;
  max_score     CONSTANT scores.score%TYPE := 9;
  max_weight    CONSTANT performance_parts.weight%TYPE:= 1;
BEGIN
  SELECT s.score INTO n_score
  FROM SCORES s
  WHERE evaluation_id = s.evaluation_id 
  AND performance_id = s.performance_id;
  SELECT p.weight INTO n_weight
  FROM PERFORMANCE_PARTS p
  WHERE performance_id = p.performance_id;
  BEGIN
    IF (n_weight > max_weight) OR (n_weight < 0) THEN
      RAISE weight_wrong;
    END IF;
  END;
  BEGIN
    IF (n_score > max_score) OR (n_score < 0) THEN
      RAISE score_wrong;
    END IF;
  END;
  running_total := n_score * n_weight;
  RETURN running_total;
EXCEPTION
  WHEN weight_wrong THEN
    DBMS_OUTPUT.PUT_LINE(
      'The weight of a score must be between 0 and ' || max_weight);
    RETURN -1;
  WHEN score_wrong THEN
    DBMS_OUTPUT.PUT_LINE(
      'The score must be between 0 and ' || max_score);
    RETURN -1;
END calculate_score;

------------------------------------------------
-- Creating a Trigger that Logs Table Changes --
------------------------------------------------

CREATE TABLE EVALUATIONS_LOG ( log_date DATE
                             , action VARCHAR2(50));
							 
CREATE OR REPLACE TRIGGER EVAL_CHANGE_TRIGGER
  AFTER INSERT OR UPDATE OR DELETE
  ON EVALUATIONS
DECLARE
  log_action  EVALUATIONS_LOG.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;
  INSERT INTO EVALUATIONS_LOG (log_date, action)
    VALUES (SYSDATE, log_action);
END;

-------------------------------------------------
-- Creating a Trigger that Generates a Primary --
-- Key for a Row Before It Is Inserted         --
-------------------------------------------------

CREATE OR REPLACE
TRIGGER NEW_EVALUATION_TRIGGER
BEFORE INSERT ON EVALUATIONS
FOR EACH ROW
BEGIN
  :NEW.evaluation_id := evaluations_sequence.NEXTVAL;
END;

------------------------------------
-- Creating an INSTEAD OF Trigger --
------------------------------------

CREATE OR REPLACE TRIGGER update_name_view_trigger
INSTEAD OF UPDATE ON emp_locations
BEGIN
  UPDATE employees SET
    first_name = substr( :NEW.name, instr( :new.name, ',' )+2),
    last_name = substr( :NEW.name, 1, instr( :new.name, ',')-1)
  WHERE employee_id = :OLD.employee_id;
END;

--------------------------------------------------------
-- Creating Triggers that Log LOGON and LOGOFF Events --
--------------------------------------------------------

CREATE TABLE hr_users_log (
  user_name VARCHAR2(30),
  activity VARCHAR2(20),
  event_date DATE
);

CREATE OR REPLACE TRIGGER hr_logon_trigger
  AFTER LOGON
  ON HR.SCHEMA
BEGIN
  INSERT INTO hr_users_log (user_name, activity, event_date)
  VALUES (USER, 'LOGON', SYSDATE);
END;

CREATE OR REPLACE TRIGGER hr_logoff_trigger
  BEFORE LOGOFF
  ON HR.SCHEMA
BEGIN
  INSERT INTO hr_users_log (user_name, activity, event_date)
  VALUES (USER, 'LOGOFF', SYSDATE);
END;

--------------------------------------------
-- Disabling or Enabling a Single Trigger --
--------------------------------------------

ALTER TRIGGER eval_change_trigger DISABLE;
ALTER TRIGGER eval_change_trigger ENABLE;

----------------------------------------------------------
-- Disabling or Enabling All Triggers on a Single Table --
----------------------------------------------------------

ALTER TABLE evaluations DISABLE ALL TRIGGERS;
ALTER TABLE evaluations ENABLE ALL TRIGGERS;

-----------------------
-- Dropping Triggers --
-----------------------

DROP TRIGGER EVAL_CHANGE_TRIGGER;

--------------
-- Bulk SQL --
--------------

CREATE OR REPLACE PROCEDURE bulk AS
  TYPE ridArray IS TABLE OF ROWID;
  TYPE onameArray IS TABLE OF t.object_name%TYPE;
 
  CURSOR c is SELECT ROWID rid, object_name  -- explicit cursor
              FROM t t_bulk;
 
  l_rids    ridArray;
  l_onames  onameArray;
  N         NUMBER := 100;
BEGIN
  OPEN c;
  LOOP
    FETCH c BULK COLLECT
    INTO l_rids, l_onames LIMIT N;   -- retrieve N rows from t
    FOR i in 1 .. l_rids.COUNT
      LOOP                           -- process N rows
        l_onames(i) := substr(l_onames(i),2) || substr(l_onames(i),1,1);
      END LOOP;
      FORALL i in 1 .. l_rids.count  -- return processed rows to t
        UPDATE t
        SET object_name = l_onames(i)
        WHERE ROWID = l_rids(i);
        EXIT WHEN c%NOTFOUND;
  END LOOP;
  CLOSE c;
END;

------------------
-- Non-Bulk SQL --
------------------

CREATE OR REPLACE PROCEDURE slow_by_slow AS
BEGIN
  FOR x IN (SELECT rowid rid, object_name FROM t t_slow_by_slow)
    LOOP
      x.object_name := substr(x.object_name,2) || substr(x.object_name,1,1);
      UPDATE t
      SET object_name = x.object_name
      WHERE rowid = x.rid;
    END LOOP;
END;

------------
-- OTHERS --
------------

-- Installation guide
http://blog.whitehorses.nl/2014/03/18/installing-java-oracle-11g-r2-express-edition-and-sql-developer-on-ubuntu-64-bit/

-- Creating a schema
http://docs.oracle.com/cd/B12037_01/server.101/b10759/statements_6013.htm
http://www.techonthenet.com/oracle/schemas/create_schema.php

-- Using EXPLAIN PLAN
http://docs.oracle.com/cd/B19306_01/server.102/b14200/statements_9010.htm
http://www.orafaq.com/wiki/Explain_Plan

-- Kill a running statement
http://stackoverflow.com/questions/9545560/how-to-kill-a-running-select-statement

-- Data Pump
http://www.rebellionrider.com/oracle-data-pump-impdp-expdp/data-pump-expdp-how-to-export-full-database.htm
http://www.orafaq.com/wiki/Datapump

sqlplus / as sysdba
select directory_name, directory_path from dba_directories;
GRANT read, write ON DIRECTORY DATA_PUMP_DIR TO hr;
GRANT DATAPUMP_EXP_FULL_DATABASE TO hr;
expdp hr/hr@XE DIRECTORY=DATA_PUMP_DIR DUMPFILE=hr_exp.dmp LOGFILE=hr_exp.log FULL=YES