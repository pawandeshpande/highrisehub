


SELECT 'CREATING TABLE DOD_PAYMENT_TRANSACTION' AS ' '; 
CREATE TABLE IF NOT EXISTS DOD_PAYMENT_TRANSACTION (ROW_ID MEDIUMINT AUTO_INCREMENT PRIMARY KEY, 
ORDER_ID VARCHAR(100) NOT NULL, 
AMT DECIMAL(7,2) NOT NULL, 
CURRENCY VARCHAR(10), 
DESCRIPTION VARCHAR(200), 
CUSTOMER_ID MEDIUMINT NOT NULL, 
VENDOR_ID MEDIUMINT NOT NULL, 
PAYMENT_MODE VARCHAR(20), 
TRANSACTION_ID VARCHAR(30) NOT NULL, 
PAYMENT_DATETIME TIMESTAMP, 
RESPONSE_CODE SMALLINT, 
RESPONSE_MESSAGE VARCHAR(100), 
ERROR_DESC VARCHAR(100),
CREATED TIMESTAMP NOT NULL DEFAULT NOW() ,
CREATED_BY MEDIUMINT,
DELETED_STATE CHAR(1),
TENANT_ID MEDIUMINT NOT NULL); 


-- CREATE FOREIGN KEY REFERENCES : DOD_PAYMENT_TRANSACTION TABLE
SELECT 'CREATE FOREIGN KEY REFERENCES : DOD_PAYMENT_TRANSACTION TABLE' AS ' ';
ALTER TABLE DOD_PAYMENT_TRANSACTION ADD FOREIGN KEY(TENANT_ID) REFERENCES DOD_COMPANY(ROW_ID);
ALTER TABLE DOD_PAYMENT_TRANSACTION ADD FOREIGN KEY(ORDER_ID) REFERENCES DOD_ORDER(ROW_ID);
ALTER TABLE DOD_PAYMENT_TRANSACTION ADD FOREIGN KEY(CUSTOMER_ID) REFERENCES DOD_CUST_PROFILE(ROW_ID);
ALTER TABLE DOD_PAYMENT_TRANSACTION ADD FOREIGN KEY(VENDOR_ID) REFERENCES DOD_VEND_PROFILE(ROW_ID);

