SELECT 'DROPPING DATABASE DAIRYONDEMAND' AS ' ';
DROP DATABASE IF EXISTS DAIRYONDEMAND;


DROP USER  'TESTCRMCORE'@'LOCALHOST';
CREATE USER 'TESTCRMCORE'@'LOCALHOST' IDENTIFIED BY 'TESTCRMCORE';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE, ALTER   ON DAIRYONDEMAND.*   TO 'TESTCRMCORE'@'LOCALHOST';

SELECT 'CREATING DATABASE DAIRYONDEMAND' AS ' ';
CREATE DATABASE DAIRYONDEMAND;

USE DAIRYONDEMAND;

SELECT 'DROPPING THE TABLES' AS ' ';
DROP TABLE IF EXISTS DOD_COMPANY;  SELECT 'DROPPING APARTMENT COMPLEX/SOCIETY/GROUP ';
 DROP TABLE IF EXISTS DOD_ORD_PREF; SELECT 'DROPPING PRODUCT PREFERENCE TABLE, WHICH WILL LET THE VENDOR KNOW WHAT THE PRODUCT PREFERENCES OF THE USER ARE.'; 
 DROP TABLE IF EXISTS DOD_ORDER; SELECT 'DROPPING ORDER TABLE'; 
 DROP TABLE IF EXISTS DOD_ORDER_DETAILS; SELECT 'DROPPING ORDER DETAILS TABLE.'; 
 DROP TABLE IF EXISTS DOD_ORDER_TRACK; SELECT 'DROPPING ORDER STATUS TABLE'; 
DROP TABLE IF EXISTS DOD_ORDER_DETAILS_TRACK; SELECT 'DROPPING ORDER DETAILS TRACK TABLE'; 
 DROP TABLE IF EXISTS DOD_PRD_MASTER; SELECT 'DROPPING PRODUCT MASTER TABLE.';
 DROP TABLE IF EXISTS DOD_PRD_CATG; SELECT 'DROPPING PRODUCT CATEGORIES TABLE.';
 DROP TABLE IF EXISTS DOD_CUST_PROFILE; SELECT  'DROPPING CUSTOMER PROFILE TABLE.';
DROP TABLE IF EXISTS DOD_CUST_WALLET; SELECT 'DROPPING CUSTOMER WALLET TABLE.'; 
 DROP TABLE IF EXISTS DOD_VEND_PROFILE; SELECT 'DROPPING VENDOR PROFILE TABLE'; 
 DROP TABLE IF EXISTS DOD_USERS; SELECT 'DROPPING USERS TABLE'; 
DROP TABLE IF EXISTS DOD_REVIEWS; SELECT 'DROPPING REVIEWS TABLE';
DROP TABLE IF EXISTS DOD_VENDOR_ORDERS;  SELECT 'A TABLE TO STORE ALL THE ORDERS FOR A PARTICULAR VENDOR.';
DROP TABLE IF EXISTS DOD_ROLES; SELECT 'A Table to store all the roles'; 
DROP TABLE IF EXISTS DOD_USER_ROLES; SELECT 'A table to store users and roles associaiton'; 
DROP TABLE IF EXISTS DOD_AUTH_ATTR_LOOKUP; SELECT 'A table to store the attributes for authorization'; 
DROP TABLE IF EXISTS DOD_AUTH_POLICY_ATTR; SELECT 'An intermediate table to store all attributes associated with a policy'; 
DROP TABLE IF EXISTS DOD_AUTH_POLICY; SELECT 'A table to store the authorization policy'; 
DROP TABLE IF EXISTS DOD_BUS_OBJECT; SELECT 'A table to store the Business Object'; 
DROP TABLE IF EXISTS DOD_BUS_TRANSACTION; SELECT 'A table to store the Business Transactions'; 


 SELECT 'TABLES DROPPED' AS ' ';

 SELECT 'CREATING TABLE DOD_USERS' AS ' ';    
CREATE TABLE DOD_USERS( ROW_ID MEDIUMINT AUTO_INCREMENT    PRIMARY KEY ,
 NAME VARCHAR(30) NOT NULL ,
 USERNAME VARCHAR(30) NOT NULL UNIQUE ,
 PASSWORD VARCHAR(100) NOT NULL ,
 EMAIL VARCHAR(255) NOT NULL,
 FIRSTNAME VARCHAR(50), 
 LASTNAME VARCHAR(50), 
 FULLNAME VARCHAR(50), 
 SALUTATION VARCHAR(10), 
 TITLE VARCHAR(255), 
 PHONE_HOME VARCHAR(50), 
 PHONE_MOBILE VARCHAR(50), 
 PHONE_OFFICE VARCHAR(50), 
 PRIMARY_ADDRESS_STREET VARCHAR(150), 
 PRIMARY_ADDRESS_CITY VARCHAR(100), 
 PRIMARY_ADDRESS_STATE VARCHAR(100), 
 PRIMARY_ADDRESS_POSTALCODE VARCHAR(20), 
 PRIMARY_ADDRESS_COUNTRY VARCHAR(255), 
 BIRTHDATE DATETIME, 
 PICTURE VARCHAR(255),
 CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
 CREATED_BY MEDIUMINT,
 UPDATED TIMESTAMP ,
 UPDATED_BY MEDIUMINT,
 ACTIVE_FLG CHAR(1),
 DELETED_STATE CHAR(1),
 TENANT_ID MEDIUMINT NOT NULL, 
PARENT_ID MEDIUMINT  );
 
 SELECT 'CREATING TABLE DOD_COMPANY' AS ' ';
CREATE TABLE DOD_COMPANY( ROW_ID MEDIUMINT AUTO_INCREMENT     PRIMARY KEY ,
 NAME VARCHAR(255) NOT NULL ,
 ADDRESS VARCHAR(512) NOT NULL ,
 CITY VARCHAR(256) NOT NULL,
 STATE VARCHAR(256),
 COUNTRY VARCHAR (100),
 ZIPCODE CHAR(10),
 PRIMARY_CONTACT VARCHAR(255), 
 CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
  CREATED_BY MEDIUMINT,
  UPDATED TIMESTAMP ,
  UPDATED_BY MEDIUMINT,
  ACTIVE_FLG CHAR(1) NOT NULL,
 DELETED_STATE CHAR(1));
 
SELECT 'CREATING TABLE DOD_ORD_PREF' AS ' ';
CREATE TABLE DOD_ORD_PREF( ROW_ID MEDIUMINT AUTO_INCREMENT     PRIMARY KEY ,
 CUST_ID MEDIUMINT, 
 PRD_ID MEDIUMINT, 
 PRD_QTY MEDIUMINT,
SUN CHAR(1),
MON CHAR(1),
TUE CHAR(1),
WED CHAR(1),
THU CHAR(1),
FRI CHAR(1),
SAT CHAR(1),
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
 TENANT_ID MEDIUMINT, 
 DELETED_STATE CHAR(1)
 );
  
SELECT  'THIS IS A DAILY TRANSACTION TABLE TO CALCULATE THE DEMAND FOR THE PRODUCT ON A DAILY BASIS.';
SELECT  'WE CAN COPY THE ROWS FROM DOD_PRD_PREF TABLE BY RUNNING A DAILY JOB AND CONSIDER THAT AS DAILY ONDEMAND PREFERENCE'; 
SELECT 'CREATING TABLE DOD_ORDER' AS ' ';    
CREATE TABLE DOD_ORDER( ROW_ID MEDIUMINT AUTO_INCREMENT    PRIMARY KEY ,
 ORD_DATE TIMESTAMP NOT NULL DEFAULT NOW(), 
 CUST_ID MEDIUMINT NOT NULL, 
 REQ_DATE TIMESTAMP NOT NULL, 
 SHIPPED_DATE TIMESTAMP NULL, 
 SHIP_ADDRESS VARCHAR(100),
ORDER_FULFILLED CHAR(1),
STATUS 	CHAR(3),
PAYMENT_MODE CHAR(3), 
CONTEXT_ID VARCHAR(100), 
ORDER_AMT DECIMAL(7,2),
COMMENTS VARCHAR(255), 
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
 TENANT_ID MEDIUMINT,
 DELETED_STATE CHAR(1));
 
SELECT 'CREATING TABLE DOD_ORD_DETAILS' AS ' ';    
CREATE TABLE DOD_ORDER_DETAILS( ROW_ID MEDIUMINT AUTO_INCREMENT    PRIMARY KEY ,
 ORDER_ID MEDIUMINT NOT NULL, 
 VENDOR_ID MEDIUMINT NOT NULL, 
PRD_ID MEDIUMINT NOT NULL, 
 UNIT_PRICE DECIMAL(7,2), 
 PRD_QTY MEDIUMINT,
 FULFILLED CHAR(1),
 STATUS CHAR(3), 
 CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
 DELETED_STATE CHAR(1),
 TENANT_ID MEDIUMINT 
);

SELECT 'CREATING TABLE DOD_VENDOR_ORDERS' AS ' ';    
CREATE TABLE DOD_VENDOR_ORDERS( ROW_ID MEDIUMINT AUTO_INCREMENT    PRIMARY KEY ,
 ORDER_ID MEDIUMINT NOT NULL, 
 VENDOR_ID MEDIUMINT NOT NULL, 
 FULFILLED CHAR(1),
 STATUS CHAR(3), 
 CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
 TENANT_ID MEDIUMINT 
);



SELECT 'CREATING TABLE DOD_ORDER_TRACK' AS ' ';
CREATE TABLE DOD_ORDER_TRACK (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
ORDER_ID MEDIUMINT NOT NULL,
STATUS  CHAR(3),
REMARKS VARCHAR(70),
UPDATED_BY VARCHAR(70),
TENANT_ID MEDIUMINT,
UPDATED TIMESTAMP, 
CREATED TIMESTAMP NOT NULL DEFAULT NOW()); 

SELECT 'CREATING TABLE DOD_ORDER_DETAILS_TRACK' AS ' ';
CREATE TABLE DOD_ORDER_DETAILS_TRACK (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
ITEM_ID MEDIUMINT NOT NULL,
STATUS  CHAR(3),
REMARKS VARCHAR(70),
UPDATED_BY VARCHAR(70),
UPDATED TIMESTAMP, 
TENANT_ID MEDIUMINT,
CREATED TIMESTAMP NOT NULL DEFAULT NOW()); 



 
SELECT 'CREATING TABLE DOD_PRD_MASTER' AS ' ';    
CREATE TABLE DOD_PRD_MASTER( ROW_ID MEDIUMINT AUTO_INCREMENT    PRIMARY KEY ,
PRD_NAME VARCHAR(70),
VENDOR_ID MEDIUMINT, 
CATG_ID MEDIUMINT, 
QTY_PER_UNIT VARCHAR(30), 
PRD_IMAGE_PATH VARCHAR(256),
UNIT_PRICE DECIMAL(7,2),
UNITS_IN_STOCK SMALLINT, 
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
 DELETED_STATE CHAR(1),
 SUBSCRIBE_FLAG CHAR(1), 
 TENANT_ID MEDIUMINT 
);

SELECT 'CREATING TABLE DOD_PRD_CAT' AS ' ';
CREATE TABLE DOD_PRD_CATG (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
CATG_NAME VARCHAR(70),
DESCRIPTION VARCHAR(100),
PICTURE_PATH VARCHAR(255),
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
 DELETED_STATE CHAR(1),
 ACTIVE_FLAG CHAR(1), 
 TENANT_ID MEDIUMINT);
 


SELECT 'CREATING TABLE DOD_CUST_PROFILE' AS ' ';    
CREATE TABLE DOD_CUST_PROFILE( ROW_ID MEDIUMINT AUTO_INCREMENT    PRIMARY KEY ,
NAME  VARCHAR(70) NOT NULL ,
ADDRESS VARCHAR(256),
PHONE VARCHAR(30) NOT NULL,
USERNAME VARCHAR(30) NOT NULL ,
PASSWORD VARCHAR(128) NOT NULL ,
SALT VARCHAR (128) ,
EMAIL VARCHAR(255),
 FIRSTNAME VARCHAR(50), 
 LASTNAME VARCHAR(50), 
 FULLNAME VARCHAR(50), 
 SALUTATION VARCHAR(10), 
 TITLE VARCHAR(255), 
 BIRTHDATE DATETIME,
 PICTURE_PATH VARCHAR(256),
 CITY VARCHAR(256),
 STATE VARCHAR(256),
 COUNTRY VARCHAR (100),
 ZIPCODE CHAR(10),
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
 UPDATED TIMESTAMP, 
 DELETED_STATE CHAR(1),
 TENANT_ID MEDIUMINT NOT NULL

);

SELECT 'CREATING TABLE DOD_CUST_WALLET' AS ' '; 
CREATE TABLE DOD_CUST_WALLET( ROW_ID MEDIUMINT AUTO_INCREMENT    PRIMARY KEY ,
CUST_ID MEDIUMINT NOT NULL, 
VENDOR_ID MEDIUMINT NOT NULL, 
BALANCE DECIMAL(7,2) DEFAULT 0.00, 
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
UPDATED TIMESTAMP , 
DELETED_STATE CHAR(1), 
TENANT_ID MEDIUMINT NOT NULL
);



SELECT 'CREATING TABLE DOD_VEND_PROFILE' AS ' ';    
CREATE TABLE DOD_VEND_PROFILE( ROW_ID MEDIUMINT AUTO_INCREMENT    PRIMARY KEY ,
NAME  VARCHAR(70) NOT NULL,
ADDRESS VARCHAR(70) NOT NULL, 
PHONE VARCHAR(30) NOT NULL, 
 USERNAME VARCHAR(30) NOT NULL ,
 PASSWORD VARCHAR(100) NOT NULL ,
 SALT VARCHAR (128),
 EMAIL VARCHAR(255),
 FIRSTNAME VARCHAR(50), 
 LASTNAME VARCHAR(50), 
 FULLNAME VARCHAR(50), 
 SALUTATION VARCHAR(10), 
 TITLE VARCHAR(255), 
 BIRTHDATE DATETIME,
 PICTURE_PATH VARCHAR(256),
 CITY VARCHAR(256),
 ZIPCODE VARCHAR(10), 
 STATE VARCHAR(256),
 COUNTRY VARCHAR (100),
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
UPDATED TIMESTAMP , 
 DELETED_STATE CHAR(1),
 TENANT_ID MEDIUMINT NOT NULL

);

SELECT 'CREATING TABLE DOD_REVIEWS' AS ' ';
CREATE TABLE DOD_REVIEWS (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
RATING SMALLINT DEFAULT 0,
CREATED TIMESTAMP NOT NULL DEFAULT NOW(),
DESCRIPTION VARCHAR(256),
DELETED_STATE CHAR(1),
TENANT_ID MEDIUMINT,
PRODUCT_ID MEDIUMINT ,
CUSTOMER_ID MEDIUMINT,
TRANSACTION_ID MEDIUMINT);


CREATE TABLE DOD_ROLES(ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
NAME VARCHAR(30),
DESCRIPTION VARCHAR(255),
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
CREATED_BY MEDIUMINT,
ACTIVE_FLG CHAR(1),
DELETED_STATE CHAR(1));
      
SELECT 'Creating table CRM_USER_ROLES' AS ' ';
CREATE TABLE DOD_USER_ROLES( ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
USER_ID  MEDIUMINT NOT NULL,
ROLE_ID MEDIUMINT NOT NULL, 
TENANT_ID MEDIUMINT NOT NULL);


SELECT 'Creating table DOD_AUTH_ATTR' AS ' '; 
CREATE TABLE DOD_AUTH_ATTR_LOOKUP (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY, 
NAME VARCHAR(50), 
DESCRIPTION VARCHAR(100), 
-- Lisp function where the underlying code to get the attribute value from business logic will be written.
-- This function is hidden from the UI.  
ATTR_FUNC VARCHAR(100) NOT NULL, 
-- Lisp function to get a list of unique values for that particular attribute. 
ATTR_UNIQUE_FUNC VARCHAR(100)  NOT NULL, 
-- Attribute types are "ACTION" "SUBJECT" "RESOURCE" "CONTEXT_BASED" 
ATTR_TYPE VARCHAR(50), 
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
CREATED_BY MEDIUMINT,
ACTIVE_FLG CHAR(1),
DELETED_STATE CHAR(1),
TENANT_ID MEDIUMINT NOT NULL); 

SELECT 'Creating table DOD_AUTH_POLICY' AS ' ';
CREATE TABLE DOD_AUTH_POLICY (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY, 
NAME VARCHAR (50), 
DESCRIPTION VARCHAR(100),
-- Whoever is creating a policy here has to paste a lisp function which is syntactically correct. 
POLICY_FUNC VARCHAR (255), 
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
CREATED_BY MEDIUMINT,
ACTIVE_FLG CHAR(1),
DELETED_STATE CHAR(1),
TENANT_ID MEDIUMINT NOT NULL); 


SELECT 'Creating table DOD_AUTH_POLICY_ATTR' AS ' '; 
CREATE TABLE DOD_AUTH_POLICY_ATTR (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY, 
POLICY_ID MEDIUMINT, 
ATTRIBUTE_ID MEDIUMINT,
ATTR_VAL VARCHAR(100) NOT NULL DEFAULT "<substitute>",
TENANT_ID MEDIUMINT NOT NULL); 

SELECT 'Creating table DOD_BUS_OBJECT' AS ' ' ; 
CREATE TABLE DOD_BUS_OBJECT (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY, 
NAME VARCHAR(100), 
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
CREATED_BY MEDIUMINT,
ACTIVE_FLG CHAR(1),
DELETED_STATE CHAR(1),
TENANT_ID MEDIUMINT NOT NULL); 

SELECT 'CREATING TABLE DOD_BUS_TRANSACTION' AS ' '; 
CREATE TABLE DOD_BUS_TRANSACTION (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY, 
NAME VARCHAR(100), 
URI VARCHAR(100), 
AUTH_POLICY_ID MEDIUMINT NOT NULL, 
BO_ID MEDIUMINT NOT NULL, 
TRANS_TYPE VARCHAR(15), 
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
CREATED_BY MEDIUMINT,
ACTIVE_FLG CHAR(1),
DELETED_STATE CHAR(1),
TENANT_ID MEDIUMINT NOT NULL); 


-- CREATE FOREIGN KEY REFERENCES : DOD_USER_ROLES TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_USER_ROLES TABLE' AS ' ';
ALTER TABLE DOD_USER_ROLES ADD FOREIGN KEY(TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);
ALTER TABLE DOD_USER_ROLES ADD FOREIGN KEY(USER_ID) REFERENCES DOD_USERS(ROW_ID);
ALTER TABLE DOD_USER_ROLES ADD FOREIGN KEY(ROLE_ID) REFERENCES DOD_ROLES(ROW_ID);


-- CREATE FOREIGN KEY REFERENCES : DOD_AUTH_POLICY_ATTR TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_AUTH_POLICY_ATTR TABLE' AS ' ';
ALTER TABLE DOD_AUTH_POLICY_ATTR ADD FOREIGN KEY(TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);
ALTER TABLE DOD_AUTH_POLICY_ATTR ADD FOREIGN KEY(ATTRIBUTE_ID) REFERENCES DOD_AUTH_ATTR_LOOKUP (ROW_ID);
ALTER TABLE DOD_AUTH_POLICY_ATTR ADD FOREIGN KEY(POLICY_ID) REFERENCES DOD_AUTH_POLICY (ROW_ID);


-- CREATE FOREIGN KEY REFERENCES : DOD_AUTH_POLICY TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_AUTH_POLICY TABLE' AS ' ';
ALTER TABLE DOD_AUTH_POLICY ADD FOREIGN KEY(TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);


-- CREATE FOREIGN KEY REFERENCES : DOD_AUTH_ATTR_LOOKUP TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_AUTH_ATTR_LOOKUP TABLE' AS ' ';
ALTER TABLE DOD_AUTH_ATTR_LOOKUP ADD FOREIGN KEY(TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);


-- CREATE FOREIGN KEY REFERENCES : DOD_BUS_OBJECT TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_BUS_OBJECT TABLE' AS ' ';
ALTER TABLE DOD_BUS_OBJECT ADD FOREIGN KEY(TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);


-- CREATE FOREIGN KEY REFERENCES : DOD_BUS_TRANSACTION TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_BUS_TRANSACTION TABLE' AS ' ';
ALTER TABLE DOD_BUS_TRANSACTION ADD FOREIGN KEY(TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);
ALTER TABLE DOD_BUS_TRANSACTION ADD FOREIGN KEY(BO_ID) REFERENCES DOD_BUS_OBJECT(ROW_ID); 
ALTER TABLE DOD_BUS_TRANSACTION ADD FOREIGN KEY (AUTH_POLICY_ID) REFERENCES DOD_AUTH_POLICY(ROW_ID); 


-- CREATE FOREIGN KEY REFERENCES : DOD_REVIEWS TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_REVIEWS TABLE' AS ' ';
ALTER TABLE DOD_REVIEWS ADD FOREIGN KEY(TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);
ALTER TABLE DOD_REVIEWS ADD FOREIGN KEY (PRODUCT_ID) REFERENCES DOD_PRD_MASTER(ROW_ID);
ALTER TABLE DOD_REVIEWS ADD FOREIGN KEY (CUSTOMER_ID) REFERENCES DOD_CUST_PROFILE(ROW_ID);
ALTER TABLE DOD_REVIEWS ADD FOREIGN KEY (TRANSACTION_ID) REFERENCES DOD_ORDER (ROW_ID);



-- CREATE FOREIGN KEY REFERENCES : DOD_ORD_PREF TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_ORD_PREF TABLE' AS ' '; 
ALTER TABLE DOD_ORD_PREF ADD FOREIGN KEY( TENANT_ID)   REFERENCES DOD_COMPANY(ROW_ID); 
ALTER TABLE DOD_ORD_PREF ADD FOREIGN KEY( CUST_ID)   REFERENCES DOD_CUST_PROFILE(ROW_ID); 
ALTER TABLE DOD_ORD_PREF ADD FOREIGN KEY( PRD_ID)   REFERENCES DOD_PRD_MASTER(ROW_ID); 


-- CREATE FOREIGN KEY REFERENCES : DOD_ORDER TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_ORDER' AS ' ';
ALTER TABLE DOD_ORDER ADD FOREIGN KEY (TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID); 
ALTER TABLE DOD_ORDER ADD FOREIGN KEY( CUST_ID)   REFERENCES DOD_CUST_PROFILE(ROW_ID);



-- CREATE FOREIGN KEY REFERENCES : DOD_ORDER_DETAILS TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_ORDER_DETAILS TABLE' AS ' ';
ALTER TABLE DOD_ORDER_DETAILS ADD FOREIGN KEY (TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID); 
ALTER TABLE DOD_ORDER_DETAILS ADD FOREIGN KEY( ORDER_ID)   REFERENCES DOD_ORDER(ROW_ID); 
ALTER TABLE DOD_ORD_PREF ADD FOREIGN KEY( PRD_ID)   REFERENCES DOD_PRD_MASTER(ROW_ID); 

-- CREATE FOREIGN KEY REFERENCES : DOD_VENDOR_ORDER TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES: DOD_VENDOR_ORDER  TABLE' AS ' ';
ALTER TABLE DOD_VENDOR_ORDERS ADD FOREIGN KEY (TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);


-- CREATE FOREIGN KEY REFERENCES : DOD_ORDER_TRACK TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES: DOD_ORDER_STATUS TABLE' AS ' ';
ALTER TABLE DOD_ORDER_TRACK ADD FOREIGN KEY (TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);
ALTER TABLE DOD_ORDER_TRACK ADD FOREIGN KEY (ORDER_ID) REFERENCES DOD_ORDER(ROW_ID); 


-- CREATE FOREIGN KEY REFERENCES : DOD_PRD_MASTER
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_PRD_MASTER ' AS ' ';
ALTER TABLE DOD_PRD_MASTER ADD FOREIGN KEY (TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID); 
ALTER TABLE DOD_PRD_MASTER ADD FOREIGN KEY (VENDOR_ID)   REFERENCES DOD_VEND_PROFILE(ROW_ID); 
ALTER TABLE DOD_PRD_MASTER ADD FOREIGN KEY (CATG_ID) REFERENCES DOD_PRD_CATG(ROW_ID); 

-- CREATE FOREIGN KEY REFERENCES : DOD_CUST_PROFILE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_CUST_PROFILE TABLE' AS ' ';
ALTER TABLE DOD_CUST_PROFILE ADD FOREIGN KEY (TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID); 

-- CREATE FOREIGN KEY REFERENCES : DOD_CUST_WALLET
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_CUST_WALLET  TABLE' AS ' ';
ALTER TABLE DOD_CUST_WALLET  ADD FOREIGN KEY (TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID); 
ALTER TABLE DOD_CUST_WALLET  ADD FOREIGN KEY (CUST_ID) REFERENCES DOD_CUST_PROFILE(ROW_ID); 
ALTER TABLE DOD_CUST_WALLET  ADD FOREIGN KEY (VENDOR_ID) REFERENCES DOD_VEND_PROFILE(ROW_ID); 



-- CREATE FOREIGN KEY REFERENCES : DOD_VEND_PROFILE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_VEND_PROFILE TABLE' AS ' ';
ALTER TABLE DOD_VEND_PROFILE ADD FOREIGN KEY (TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);

-- CREATE FOREIGN KEY REFERENCES : DOD_USERS
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_USERS TABLE' AS ' ';
ALTER TABLE DOD_USERS ADD FOREIGN KEY (TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);
ALTER TABLE DOD_USERS ADD FOREIGN KEY (PARENT_ID) REFERENCES DOD_USERS(ROW_ID);


-- ALTER TABLE DOD_CUST_PROFILE ADD UNIQUE KEY
ALTER IGNORE TABLE DOD_CUST_PROFILE  ADD CONSTRAINT UC_Customer UNIQUE (PHONE, TENANT_ID);

-- ALTER TABLE DOD_VEND_PROFILE ADD UNIQUE KEY 
ALTER IGNORE TABLE DOD_VEND_PROFILE  ADD CONSTRAINT UC_Vendor UNIQUE (PHONE, TENANT_ID);






-- AFTER CREATING ALL THE TABLES WE NEED TO INSERT THE DEFAULT COMPANY AND USER.



-- CREATE SUPER COMPANY 
SELECT 'CREATE SUPER COMPANY' AS ' ';
INSERT INTO DOD_COMPANY(NAME, ADDRESS, PRIMARY_CONTACT,ACTIVE_FLG,DELETED_STATE, 
CREATED,CREATED_BY, UPDATED, UPDATED_BY) VALUES("super", "BANGALORE", "SUPERADMIN", 'Y','N', CURDATE(),-1,CURDATE(),-1); 




-- CREATE DEMO COMPANY
SELECT 'CREATE ACME COMPANY' AS ' ';
INSERT INTO DOD_COMPANY(NAME, ADDRESS, PRIMARY_CONTACT,ACTIVE_FLG,DELETED_STATE, 
CREATED,CREATED_BY, UPDATED, UPDATED_BY) VALUES("demo", "BANGALORE", "demo", 'Y','N', CURDATE(),-1,CURDATE(),-1); 



-- CREATE SOME ROLES NOW
SELECT 'CREATE SUPERADMIN ROLE' AS ' ' ; 
INSERT INTO DOD_ROLES (NAME, DESCRIPTION, CREATED, CREATED_BY, ACTIVE_FLG, DELETED_STATE) VALUES 
("SUPERADMIN", "SUPERADMIN ROLE IS THE SUPREME ROLE IN ROLE HIERARCHY", CURDATE(), -1, 'Y', 'N');

-- CREATE OPERATOR ROLE NOW
SELECT 'CREATE OPERATOR ROLE' AS ' ' ; 
INSERT INTO DOD_ROLES (NAME, DESCRIPTION, CREATED, CREATED_BY, ACTIVE_FLG, DELETED_STATE) VALUES 
("OPERATOR", "Operator is the helpdesk. He can be assigned maintenance tasks on behalf of customers, vendors.", CURDATE(), -1, 'Y', 'N');

-- CREATE COMPANY ADMINISTRATOR ROLE NOW
SELECT 'CREATE COMPANY ADMINISTRATOR ROLE' AS ' ' ; 
INSERT INTO DOD_ROLES (NAME, DESCRIPTION, CREATED, CREATED_BY, ACTIVE_FLG, DELETED_STATE) VALUES 
("COMPADMIN", "Company Administrator is the helpdesk for a particular company/tenant. He can do maintenance tasks on behalf of customers, vendors for a given company", CURDATE(), -1, 'Y', 'N');


-- CREATE Super Admin USER
SELECT 'CREATE superadmin  USER' AS ' ';
INSERT INTO DOD_USERS(NAME ,
 USERNAME ,
 PASSWORD ,
 CREATED ,
 CREATED_BY ,
 UPDATED ,
 UPDATED_BY ,
 TENANT_ID, 
 ACTIVE_FLG,
 DELETED_STATE ) VALUES("Super Admin", "superadmin", "P@ssword1", CURDATE(), -1, CURDATE(), -1, 1,'Y','N'); 



-- CREATE Operator USER
SELECT 'CREATE Operator  USER' AS ' ';
INSERT INTO DOD_USERS(NAME ,
 USERNAME ,
 PASSWORD ,
 CREATED ,
 CREATED_BY ,
 UPDATED ,
 UPDATED_BY ,
 TENANT_ID, 
 ACTIVE_FLG,
 DELETED_STATE ) VALUES("Operator1", "opr1", "P@ssword1", CURDATE(), -1, CURDATE(), -1, 1,'Y','N'); 



-- GIVE SUPERADMIN USER A SUPERADMIN ROLE
SELECT 'GIVE SUPERADMIN USER A SUPERADMIN ROLE' AS ' '; 
INSERT INTO DOD_USER_ROLES (USER_ID, ROLE_ID, TENANT_ID) VALUES
(1, 1, 1); 


-- GIVE Operator1  USER A OPERATOR  ROLE
SELECT 'GIVE SUPERADMIN USER A SUPERADMIN ROLE' AS ' '; 
INSERT INTO DOD_USER_ROLES (USER_ID, ROLE_ID, TENANT_ID) VALUES
(2, 2, 2); 


-- Create one seed attribute
SELECT 'CREATE SUBJECT attribute' AS ' '; 
INSERT INTO DOD_AUTH_ATTR_LOOKUP (NAME, DESCRIPTION, ATTR_FUNC, ATTR_UNIQUE_FUNC, ATTR_TYPE, ACTIVE_FLG, DELETED_STATE, TENANT_ID) VALUES 
( "ROLE.NAME","Role name", "DOD-ATTR-ROLE.NAME", "DOD-UNIQUE-ATTR-ROLE.NAME", "SUBJECT", "Y", "N", 1);


-- Create a Business Object
SELECT 'Create Business Object = Company' AS ' '; 
INSERT INTO DOD_BUS_OBJECT (NAME, ACTIVE_FLG, DELETED_STATE, TENANT_ID) VALUES
("COMPANY", "Y", "N", 1); 

-- Create one seed policy
SELECT 'CREATE POLICY ' AS ' ';
INSERT INTO DOD_AUTH_POLICY (NAME, DESCRIPTION, POLICY_FUNC, ACTIVE_FLG, DELETED_STATE, TENANT_ID) VALUES
("DODPOL.SA_CREATE_COMPANY", "Only Superadmin role can create company", "DOD-POL-SA-CREATE-COMPANY","Y", "N", 1); 


-- Create entries in DOD_AUTH_POLICY_ATTR
SELECT 'CREATE POLICY ATTRIBUTES' AS ' '; 
INSERT INTO DOD_AUTH_POLICY_ATTR (ATTRIBUTE_ID, POLICY_ID, TENANT_ID) VALUES
(1, 1, 1); 


-- Create a Business Transaction 
SELECT 'Create Business Transaction = Create Company' AS ' '; 
INSERT INTO DOD_BUS_TRANSACTION (NAME,URI, AUTH_POLICY_ID, BO_ID, TRANS_TYPE, ACTIVE_FLG, DELETED_STATE, TENANT_ID) VALUES
("CREATE COMPANY", "/new-company", 1,1,  "CREATE", "Y", "N", 1); 



