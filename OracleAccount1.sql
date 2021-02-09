--Note: putting '--' before a line (such as this one) turns it into a comment line

/* Begin sections of comments with /* 
and end the comment section with:  */ 

/* This method is universal as it can be used for one line. */
--The '--' method is just simpler to type.


--BEGIN EXAM COMMENTS. See main document for directions.

/*The drop table statements below remove the current copies of these tables so they can be re-created.
If you do not remove previous versions the new CREATE TABLE statement will give you a 'name is already used' type error.

IMPORTANT - These statements will give you an error if run in your database before the tables are created
in your database.  Just ignore these 'table does not exist' errors(arising from these statements only).  
They do no damage and will stop when
you finish your script by inserting the missing create table statements. When you are FINISHED, this script should 
run with no errors - but not until you are finished.  */

/*If you run this script before creating any tables it will only create the EMPLOYEE table.  
This is because all the separation subtype tables (these begin with SEP_) cannot create until the 
SEPARATION is created with the primary key correct at a minimum.  The subtypes tables refer to the SEPARATION 
table so it must be there first.  Note also that you need to create the BENEFIT table before creating the 
SELECTION table for the same reason.  */

/* The drop table and create table statements are in the order they need to be to drop and create properly.
If you change the order then errors may occur because dropping or creating in a different order may
have foreign key errors arise. */

/**/
DROP TABLE SEP_RETIREMENT;
DROP TABLE SEP_INVOLUNTARY;
DROP TABLE SEP_DISABILITY;
DROP TABLE SEP_VOLUNTARY;
DROP TABLE SEPARATION;
DROP TABLE SELECTION;
DROP TABLE BENEFIT;
DROP TABLE EMPLOYEE;

/**/
CREATE TABLE EMPLOYEE (
EMPID               CHAR(5)                             NOT NULL,
LASTNAME            VARCHAR2(100)                       NOT NULL,
FIRSTNAME           VARCHAR2(100)                       NOT NULL,
DEPARTMENT          VARCHAR2(30) DEFAULT 'PRODUCTION'   NOT NULL,
HIREDATE            DATE         DEFAULT SYSDATE        NOT NULL,
PARKINGLOT          CHAR(5)      DEFAULT 'LOT A'        NULL,
EMP_EMAIL           VARCHAR(100)                        NULL,
CONSTRAINT          EMPLOYEE_PK                         PRIMARY KEY (EMPID),
CONSTRAINT          EMPLOYEE_EMAIL_AK1                  UNIQUE (EMP_EMAIL),
CONSTRAINT          EMPLOYEE_PARKINGLOT_CHK             CHECK (PARKINGLOT IN ('LOT A', 'LOT B', 'LOT C', 'LOT D')),
CONSTRAINT          EMPLOYEE_EMP_EMAIL_CHK              CHECK (EMP_EMAIL LIKE '%_@%_.%_'),
CONSTRAINT          EMPLOYEE_DEPARTMENT_CHK             CHECK (DEPARTMENT IN ('PRODUCTION', 'ADMINISTRATION', 'ACCOUNTING', 'FINANCE','MARKETING', 'HUMANRESOURCES', 'INFOSYSTEMS'))
);        

/* remove the comment symbols and this line when you are ready to run your CREATE TABLE statement*/
CREATE TABLE BENEFIT (
BENEFITID           CHAR(5)                             NOT NULL,
CATEGORY            VARCHAR2 (30) DEFAULT 'INSURANCE'   NOT NULL,
SHORTDESC           VARCHAR2(200)                       NOT NULL,
ISTAXABLE           CHAR(1)                             NOT NULL,
TAXCODE             CHAR(10)                            NOT NULL,
CONSTRAINT          BENEFIT_PK                          PRIMARY KEY (BENEFITID),
CONSTRAINT          BENEFIT_TAXCODE_AK1                 UNIQUE (TAXCODE),
CONSTRAINT          BENEFIT_CATEGORY_CHK                CHECK (CATEGORY IN ('INSURANCE', 'SAVING', 'WELLNESS', 'OTHER')), 
CONSTRAINT          BENEFIT_ISTAXABLE_CHK               CHECK (ISTAXABLE IN ('Y', 'N'))
);


/* remove the comment symbols and this line when you are ready to run your CREATE TABLE statement*/
CREATE TABLE SELECTION (
  EMPID             CHAR(5)                             NOT NULL,
  BENEFITID         CHAR(5)                             NOT NULL,
  SELECTIONDATE     DATE DEFAULT SYSDATE                NOT NULL,
  ACTIVEDATE        DATE                                NULL,
  DEACTIVEDATE      DATE                                NULL,
  CONSTRAINT        SELECTION_PK                        PRIMARY KEY (EMPID, BENEFITID, ACTIVEDATE),
  CONSTRAINT        SELECTION_EMPLOYEE_FK1              FOREIGN KEY (EMPID) 
    REFERENCES EMPLOYEE (EMPID),
  CONSTRAINT        BENEFIT_FK2                         FOREIGN KEY (BENEFITID) 
                        REFERENCES BENEFIT (BENEFITID),
  CONSTRAINT        SELECTION_DEACTIVEDATE_CHK          CHECK (DEACTIVEDATE > ACTIVEDATE),
  CONSTRAINT        SELECTION_DATE_LOWER_LIMIT_CHK      CHECK (SELECTIONDATE >= '01-JAN-1995'), CHECK (ACTIVEDATE >= '01-JAN-1995'), CHECK (DEACTIVEDATE >= '01-JAN-1995')
);


/* remove the comment symbols and this line of text when you are ready to run your CREATE TABLE statement*/
CREATE TABLE SEPARATION (
SEPARATION_EMPID    CHAR(5)                             NOT NULL,
DATE_ENTERED        DATE DEFAULT SYSDATE                NOT NULL,
DATE_EFFECTIVE      DATE                                NULL,
MONTHS_OF_SERVICE   NUMBER(4, 1)                        NULL,
TYPE_CODE           CHAR(1) DEFAULT 'V'                 NOT NULL,
CONSTRAINT          SEPARATION_PK                       PRIMARY KEY (SEPARATION_EMPID),
CONSTRAINT          SEPARATION_EMPLOYEE_FK1             FOREIGN KEY (SEPARATION_EMPID)
                        REFERENCES EMPLOYEE (EMPID),
CONSTRAINT          SEPARATION_TYPE_CODE_CHK            CHECK (TYPE_CODE IN ('V', 'I', 'R', 'D')),
CONSTRAINT          SEPARATION_MAX_MONTHS_CHK           CHECK (MONTHS_OF_SERVICE <= 960),
CONSTRAINT          SEPARATION_DATE_LOWER_LIM_CHK       CHECK (DATE_ENTERED >= '01-JAN-1995'), CHECK (DATE_EFFECTIVE >= '01-JAN-1995')
);


/* remove the comment symbols and this line when you are ready to run your CREATE TABLE statement*/
CREATE TABLE SEP_VOLUNTARY (
V_SEP_EMPID   	    CHAR(5)                             NOT NULL,
LETTER_OF_SEP       CHAR(20)                            NOT NULL,
CONSTRAINT          SEP_VOLUNTARY_PK                    PRIMARY KEY (V_SEP_EMPID),
CONSTRAINT          SEP_VOLUNTARY_SEPARATION_FK1        FOREIGN KEY (V_SEP_EMPID)
                        REFERENCES SEPARATION (SEPARATION_EMPID),
CONSTRAINT          SEP_VOLUNTARY_LETTER_CHK            CHECK (RTRIM(LETTER_OF_SEP) LIKE ('LOS____%'))
);

CREATE TABLE SEP_INVOLUNTARY (
I_SEP_EMPID         CHAR(5)                             NOT NULL,
INV_SEP_FORM        CHAR(20)                            NOT NULL,
CONSTRAINT          SEP_INVOLUNTARY_PK                  PRIMARY KEY(I_SEP_EMPID),
CONSTRAINT          SEP_INVOLUNTARY_SEPARATION_FK1      FOREIGN KEY(I_SEP_EMPID)
                        REFERENCES SEPARATION(SEPARATION_EMPID)
);

CREATE TABLE SEP_RETIREMENT (
R_SEP_EMPID         CHAR(5)                             NOT NULL,
RETIREMENT_PLAN     CHAR(10)                            NOT NULL,
CONSTRAINT          SEP_RETIREMENT_PK                   PRIMARY KEY(R_SEP_EMPID),
CONSTRAINT          SEP_RETIREMENT_SEPARATION_FK1       FOREIGN KEY(R_SEP_EMPID)
                        REFERENCES SEPARATION(SEPARATION_EMPID)
);

CREATE TABLE SEP_DISABILITY (
D_SEP_EMPID         CHAR(5)                             NOT NULL,
LETTER_OF_SEP       CHAR(20)                            NOT NULL,
CONSTRAINT          SEP_DISABILITY_PK                   PRIMARY KEY(D_SEP_EMPID),
CONSTRAINT          SEP_DISABILITY_SEPARATION_FK1       FOREIGN KEY(D_SEP_EMPID)
                        REFERENCES SEPARATION(SEPARATION_EMPID)
);
