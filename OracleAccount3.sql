/*
Running this script creates a procedure in your database
that evaluates much of the practicum's database structure. 
Running this script only installs the procedure (and if you
Have compiling errors in the script then your table and/or 
attribute names have errors - you probably recieved errors 
when inserting data as well).

To run the procedure and evaluate your structure, 
first run this file as a script (in SQL Dev.), installing the 
procedure.  THEN find the 'Procedures' entry in your DB structure 
to the left. Refresh 'Procedures' and then select the procedure 
we just installed (likely the only one there).  Right click it 
and select run or click the green arrow above the procedure text 
(not the procedure sql file). Click OK on the dialog that opens. 
The procedure should run and provide output concerning many of the 
required structural elements.

The guarantee I provide you with is that if this script shows 
no errors(says 'Congratulations' at the bottom) then you will 
receive all the points associated with this part of the practicum. 
The exception is that if a script error is found early, students 
will need to pass the revised script.  I do test the script but 
it is basically in Beta test when released - if something becomes 
evident very quickly (max 24 HOURS from release) it will be
repaired and rereleased.
This guarantee covers 50% of the practicum points (everything 
except SQL DML).

Finally, a warning concerning this (added only because someone tried 
to pull this in a previous term).  The evaluation script is plain 
text and you technically could change it so that your database 'passes' 
everything on the script.  Please do note I run my own copy of the 
evaluation script as the final evaluation.  The one installed in your 
database is only for your use. Therefore, changing the script is both 
pointless and would be considered academic dishonesty.
*/

create or replace PROCEDURE EVALUATE_DDL 
			
	
AS 
      VARROWCOUNT				INT;
      IncorrectCount    INT;
      COUNT1             INT;
      VARDATE           DATE;
      VARSTRING         STRING(30);
      VARNUMBER         NUMBER(5,2);

BEGIN
  INCORRECTCOUNT := 0;
  --first commit all uncommitted work so it is not unintentionally rolled back
  COMMIT;
DBMS_OUTPUT.PUT_LINE('   ');
DBMS_OUTPUT.PUT_LINE('----------CHECKING EXISTENCE OF TABLES AND RECORDS----------');


  -- CHECK TABLE SELECTION
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SELECTION
	;
	-- IF varRowCount = 27 THEN CORRECT.
		BEGIN
			DBMS_OUTPUT.PUT_LINE('Table SELECTION exists.');
			DBMS_OUTPUT.PUT_LINE('Table SELECTION has '||VARROWCOUNT||' records (should have 27).');
		END;
  IF (VARROWCOUNT <> 27) THEN 
    INCORRECTCOUNT := INCORRECTCOUNT + 1;
    DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
  END IF;

	 -- CHECK TABLE BENEFIT
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		BENEFIT
	;
	-- IF varRowCount = 5 THEN CORRECT.
		BEGIN
			DBMS_OUTPUT.PUT_LINE('Table BENEFIT exists.');
			DBMS_OUTPUT.PUT_LINE('Table BENEFIT has '||VARROWCOUNT||' records (should have 5).');
		END;
  IF (VARROWCOUNT <> 5) THEN 
    INCORRECTCOUNT := INCORRECTCOUNT + 1;
    DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
  END IF;

-- CHECK TABLE SEPARATION
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEPARATION
	;
	-- IF varRowCount = 22 THEN CORRECT.
		BEGIN
			DBMS_OUTPUT.PUT_LINE('Table SEPARATION exists.');
			DBMS_OUTPUT.PUT_LINE('Table SEPARATION has '||VARROWCOUNT||' records (should have 22).');
		END;
  IF (VARROWCOUNT <> 22) THEN 
    INCORRECTCOUNT := INCORRECTCOUNT + 1;
    DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
  END IF;

 -- CHECK TABLE SEP_VOLUNTARY
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEP_VOLUNTARY
	;
	-- IF varRowCount = 6 THEN CORRECT.
		BEGIN
			DBMS_OUTPUT.PUT_LINE('Table SEP_VOLUNTARY exists.');
			DBMS_OUTPUT.PUT_LINE('Table SEP_VOLUNTARY has '||VARROWCOUNT||' records (should have 6).');
		END;
  IF (VARROWCOUNT <> 6) THEN 
    INCORRECTCOUNT := INCORRECTCOUNT + 1;
    DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
  END IF;


 
DBMS_OUTPUT.PUT_LINE('   ');
DBMS_OUTPUT.PUT_LINE('----------CHECKING ATTRIBUTE AND PRIMARY KEY STRUCTURE----------');

BEGIN  
Insert into SELECTION (EMPID,BENEFITID,SELECTIONDATE,ACTIVEDATE,DEACTIVEDATE) values ('20001','60003',to_date('25-OCT-18','DD-MON-RR'),to_date('03-JAN-12','DD-MON-RR'),to_date('31-AUG-19','DD-MON-RR'));
DBMS_OUTPUT.PUT_LINE('SELECTION ACCEPTS APPROPRIATE INSERTS');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('SELECTION REJECTS APPROPRIATE INSERTS');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
END;
BEGIN 
SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SELECTION
  WHERE EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-19','DD-MON-RR')
	;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Primary Key Test Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
Insert into SELECTION (EMPID,BENEFITID,SELECTIONDATE,ACTIVEDATE,DEACTIVEDATE) values ('20001','60003',to_date('25-OCT-18','DD-MON-RR'),to_date('01-JAN-19','DD-MON-RR'),to_date('31-AUG-19','DD-MON-RR'));
DBMS_OUTPUT.PUT_LINE('CUSTOMERS DOES NOT SEEM TO HAVE A PRIMARY KEY SPECIFIED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('SELECTION HAS A PRIMARY KEY SPECIFIED');
END;
END IF;
END;

BEGIN  
Insert into BENEFIT (BENEFITID,CATEGORY,SHORTDESC,ISTAXABLE,TAXCODE) values ('90005','SAVING','RETIREMENT 401K','N','12-3Q45-2');
DBMS_OUTPUT.PUT_LINE('BENEFIT ACCEPTS APPROPRIATE INSERTS');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('BENEFIT REJECTS APPROPRIATE INSERTS');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
END;
BEGIN  
SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		BENEFIT
  WHERE BENEFITID = '60005'
	;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Primary Key Test Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
Insert into BENEFIT (BENEFITID,CATEGORY,SHORTDESC,ISTAXABLE,TAXCODE) values ('60005','SAVING','RETIREMENT 401K','N','12-3L45-2');
DBMS_OUTPUT.PUT_LINE('ORDER_ITEMS DOES NOT SEEM TO HAVE A PRIMARY KEY SPECIFIED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('BENEFIT HAS A PRIMARY KEY SPECIFIED');
END;
END IF;
END;

BEGIN  
Insert into SEPARATION (SEPARATION_EMPID,DATE_ENTERED,DATE_EFFECTIVE,MONTHS_OF_SERVICE,TYPE_CODE) values ('20001',to_date('11-NOV-13','DD-MON-RR'),to_date('01-JAN-14','DD-MON-RR'),430.8,'V');
DBMS_OUTPUT.PUT_LINE('SEPARATION ACCEPTS APPROPRIATE INSERTS');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('SEPARATION REJECTS APPROPRIATE INSERTS');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
END;
BEGIN  
SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEPARATION
  WHERE SEPARATION_EMPID = '20015'
 	;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Primary Key Test Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
Insert into SEPARATION (SEPARATION_EMPID,DATE_ENTERED,DATE_EFFECTIVE,MONTHS_OF_SERVICE,TYPE_CODE) values ('20015',to_date('11-NOV-13','DD-MON-RR'),to_date('01-JAN-14','DD-MON-RR'),430.8,'V');
DBMS_OUTPUT.PUT_LINE('PRODUCTS DOES NOT SEEM TO HAVE A PRIMARY KEY SPECIFIED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('SEPARATION HAS A PRIMARY KEY SPECIFIED');
END;
END IF;
END;

BEGIN  
Insert into SEP_VOLUNTARY (V_SEP_EMPID,LETTER_OF_SEP) values ('20017','LOS1237');
DBMS_OUTPUT.PUT_LINE('SEP_VOLUNTARY ACCEPTS APPROPRIATE INSERTS');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('SEP_VOLUNTARY REJECTS APPROPRIATE INSERTS');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
END;
BEGIN  
SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEP_VOLUNTARY
  WHERE V_SEP_EMPID = '20015';
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Primary Key Test Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
Insert into SEP_VOLUNTARY (V_SEP_EMPID,LETTER_OF_SEP) values ('20015','LOS4207');
DBMS_OUTPUT.PUT_LINE('SEP_VOLUNTARY DOES NOT SEEM TO HAVE A PRIMARY KEY SPECIFIED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('SEP_VOLUNTARY HAS A PRIMARY KEY SPECIFIED');
END;
END IF;
END;


--Check Foreign keys

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('   ');
DBMS_OUTPUT.PUT_LINE('----------CHECKING FOREIGN KEYS----------');

DBMS_OUTPUT.PUT_LINE('CHECKING SELECTION.EMPID references EMPLOYEE.EMPID...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		EMPLOYEE, SELECTION
  WHERE SELECTION.EMPID = '20001'
  AND SELECTION.EMPID = EMPLOYEE.EMPID
	;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE SELECTION SET EMPID = '50232' WHERE EMPID = '20001';
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
end;
end if;
END; 
ROLLBACK;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING SELECTION.BENEFITID references BENEFIT.BENEFITID...');
SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SELECTION, BENEFIT
  WHERE SELECTION.BENEFITID = BENEFIT.BENEFITID AND BENEFIT.BENEFITID = '60001';
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE SELECTION SET BENEFITID = '60099' WHERE BENEFITID = '60001';
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
end;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING SEPARATION.SEPARATION_EMPID references EMPLOYEE.EMPID...');

SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEPARATION, EMPLOYEE
  WHERE SEPARATION.SEPARATION_EMPID = EMPLOYEE.EMPID AND EMPLOYEE.EMPID = '20021'
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE SEPARATION SET SEPARATION_EMPID = '000' WHERE SEPARATION_EMPID = '20021'
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
end;
END IF;
END;





BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING SEP_VOLUNTARY.V_SEP_EMPID references SEPARATION.SEPARATION_EMPID...');

  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEP_VOLUNTARY, SEPARATION
  WHERE SEP_VOLUNTARY.V_SEP_EMPID = SEPARATION.SEPARATION_EMPID AND SEPARATION.SEPARATION_EMPID = '20015'
	;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE SEP_VOLUNTARY SET V_SEP_EMPID = '90099' WHERE V_SEP_EMPID = '20015';
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
end;
end if;
END;


BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('   ');
DBMS_OUTPUT.PUT_LINE('----------CHECKING CHECK CONSTRAINTS----------');

DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on BENEFIT.CATEGORY...');
 SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		BENEFIT
  WHERE BENEFITID = '60001' 
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE BENEFIT SET CATEGORY = 'Q' WHERE BENEFITID = '60001'
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on BENEFIT.ISTAXABLE...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		BENEFIT
  WHERE BENEFITID = '60001' 
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE BENEFIT SET CATEGORY = 'Q' WHERE BENEFITID = '60001'
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;




BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on SELECTION.DEACTIVEDATE...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SELECTION
  WHERE  EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-19','DD-MON-RR')  
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE  SELECTION SET DEACTIVEDATE = to_date('01-JAN-18','DD-MON-RR') WHERE EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-19','DD-MON-RR')
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on SELECTION.DEACTIVEDATE >= 1995...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SELECTION
  WHERE  EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-19','DD-MON-RR')  
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE  SELECTION SET ACTIVEDATE = to_date('01-JAN-94','DD-MON-RR'), DEACTIVEDATE = to_date('02-JAN-94','DD-MON-RR') WHERE EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-19','DD-MON-RR')
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on SELECTION.ACTIVEDATE >= 1995...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SELECTION
  WHERE  EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-19','DD-MON-RR')  
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE  SELECTION SET ACTIVEDATE = to_date('01-JAN-94','DD-MON-RR') WHERE EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-19','DD-MON-RR')
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on SELECTION.SELECTIONDATE >= 1995...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SELECTION
  WHERE  EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-19','DD-MON-RR')  
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE  SELECTION SET SELECTIONDATE = to_date('01-JAN-94','DD-MON-RR') WHERE EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-19','DD-MON-RR')
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on SEPARATION.TYPE_CODE...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEPARATION
  WHERE SEPARATION_EMPID = '20015' 
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE SEPARATION SET TYPE_CODE = 'Q' WHERE SEPARATION_EMPID = '20015'
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on SEPARATION.MONTHS_OF_SERVICE...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEPARATION
  WHERE SEPARATION_EMPID = '20015' 
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE SEPARATION SET MONTHS_OF_SERVICE = 961 WHERE SEPARATION_EMPID = '20015'
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on SEPARATION.DATE_ENTERED...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEPARATION
  WHERE SEPARATION_EMPID = '20015' 
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE SEPARATION SET DATE_ENTERED = '31-DEC-1994' WHERE SEPARATION_EMPID = '20015'
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on SEPARATION.DATE_EFFECTIVE...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEPARATION
  WHERE SEPARATION_EMPID = '20015' 
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE SEPARATION SET DATE_EFFECTIVE = '31-DEC-1994' WHERE SEPARATION_EMPID = '20015'
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;


BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING check constraint on SEP_VOLUNTARY.LETTER_OF_SEP...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEP_VOLUNTARY
  WHERE V_SEP_EMPID = '20015'  
;
IF VARROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE SEP_VOLUNTARY SET LETTER_OF_SEP = 'LOS222' WHERE V_SEP_EMPID = '20015'  
;
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END;
END IF;
END;


BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('   ');
DBMS_OUTPUT.PUT_LINE('----------CHECKING UNIQUE CONSTRAINTS----------');
DBMS_OUTPUT.PUT_LINE('CHECKING UNIQUE CONSTRAINT FOR BENEFITS.TAXCODE...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		BENEFIT
  WHERE (BENEFITID = '60005' AND TAXCODE = '12-345-2') OR BENEFITID = '60001'
  ;
IF VARROWCOUNT <> 2 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test records not found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
UPDATE BENEFIT SET TAXCODE = '12-345-2' WHERE BENEFITID = '60001';
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
end;
END IF;
END;




BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('   ');
DBMS_OUTPUT.PUT_LINE('----------CHECKING DEFAULT VALUES----------');
DBMS_OUTPUT.PUT_LINE('CHECKING DEFAULT VALUE FOR BENEFIT.CATEGORY...');
  SELECT	COUNT(*) INTO VARROWCOUNT
  FROM		BENEFIT
  WHERE BENEFITID = '60099' 
;
IF VARROWCOUNT <> 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
Insert into BENEFIT (BENEFITID,SHORTDESC,ISTAXABLE,TAXCODE) values ('60099','RETIREMENT 401K','N','12-345332');
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....ERROR CODE 1');
END;
BEGIN
 BEGIN
  VARSTRING := '';
  SELECT	CATEGORY INTO VARSTRING
  FROM		BENEFIT
  WHERE BENEFITID = '60099'  
;
EXCEPTION 
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('    ....ERROR CODE 2');
 END;
IF VARSTRING <> 'INSURANCE' THEN
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END IF;
END;
END IF;
END;




BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING DEFAULT VALUE FOR SELECTION.SELECTIONDATE...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SELECTION
  WHERE  EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-18','DD-MON-RR')  
;
IF VARROWCOUNT <> 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
Insert into SELECTION (EMPID,BENEFITID,ACTIVEDATE,DEACTIVEDATE) values ('20001','60003',to_date('01-JAN-18','DD-MON-RR'),to_date('31-AUG-18','DD-MON-RR'));
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....NO DEFAULT SET');
END;
BEGIN
 BEGIN
  VARDATE := '04-JUL-76';
  SELECT	SELECTIONDATE INTO VARDATE
	FROM		SELECTION
 WHERE  EMPID = '20001' AND BENEFITID = '60003' AND ACTIVEDATE = to_date('01-JAN-18','DD-MON-RR')  
;
EXCEPTION 
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('    ....INSERTED DEFAULT VALUE NOT FOUND');
 END;
IF VARDATE > SYSDATE +.10 OR VARDATE < SYSDATE - .10 OR VARDATE = '04-JUL-76' THEN
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END IF;
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING DEFAULT VALUE FOR SEPARATION.DATE_ENTERED...');
  SELECT	COUNT(*) INTO VARROWCOUNT
	FROM		SEPARATION
  WHERE  SEPARATION_EMPID = '20001' 
;  
IF VARROWCOUNT <> 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
Insert into SEPARATION (SEPARATION_EMPID,DATE_EFFECTIVE,MONTHS_OF_SERVICE,TYPE_CODE) values ('20001',to_date('01-JAN-20','DD-MON-RR'),336.1,'R')
;
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....NO DEFAULT SET');
END;
BEGIN
 BEGIN
  VARDATE := '04-JUL-76';
  SELECT	DATE_ENTERED INTO VARDATE
	FROM		SEPARATION
 WHERE  SEPARATION_EMPID = '20001' 
; 
EXCEPTION 
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('    ....INSERTED DEFAULT VALUE NOT FOUND');
 END;
IF VARDATE > SYSDATE +.10 OR VARDATE < SYSDATE - .10 OR VARDATE = '04-JUL-76' THEN
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END IF;
END;
END IF;
END;

BEGIN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('CHECKING DEFAULT VALUE FOR SEPARATION.TYPE_CODE...');
  SELECT	COUNT(*) INTO VARROWCOUNT
  FROM		SEPARATION
  WHERE SEPARATION_EMPID = '20001' 
;
IF VARROWCOUNT <> 0 THEN
DBMS_OUTPUT.PUT_LINE('    ....Aborted - test record found');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
BEGIN
Insert into SEPARATION (SEPARATION_EMPID,DATE_ENTERED,DATE_EFFECTIVE,MONTHS_OF_SERVICE) values ('20001',to_date('05-JAN-18','DD-MON-RR'),to_date('01-JAN-20','DD-MON-RR'),336.1);
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('    ....ERROR CODE 1');
END;
BEGIN
 BEGIN
  VARSTRING := '';
  SELECT	TYPE_CODE INTO VARSTRING
  FROM		SEPARATION
  WHERE SEPARATION_EMPID = '20001' 
;
EXCEPTION 
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('    ....ERROR CODE 2');
 END;
IF VARSTRING <> 'V' THEN
DBMS_OUTPUT.PUT_LINE('    ....FAILED');
INCORRECTCOUNT := INCORRECTCOUNT + 1;
DBMS_OUTPUT.PUT_LINE('##### NOTE ERROR ABOVE #####');
ELSE
DBMS_OUTPUT.PUT_LINE('    ....PASSED');
END IF;
END;
END IF;
END;


  ROLLBACK ;

BEGIN
	DBMS_OUTPUT.PUT_LINE('********************************************************************');
	DBMS_OUTPUT.PUT_LINE('********************************************************************');
	DBMS_OUTPUT.PUT_LINE('***  You have '||INCORRECTCOUNT||' errors that need to be fixed (see detail above)  ***');
    IF INCORRECTCOUNT = 0 THEN
    	DBMS_OUTPUT.PUT_LINE('***             C O N G R A T U L A T I O N S ! ! !              ***');
    	DBMS_OUTPUT.PUT_LINE('*** (Do not forget to submit your DDL statements on Blackboard!) ***');
    END IF;
	DBMS_OUTPUT.PUT_LINE('********************************************************************');
	DBMS_OUTPUT.PUT_LINE('********************************************************************');

END;

  RETURN;
END;


/*copyright 2015-2020 Alan Brandyberry*/