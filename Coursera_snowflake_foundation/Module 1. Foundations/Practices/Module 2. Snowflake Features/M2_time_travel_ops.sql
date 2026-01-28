-- Role and environment
USE ROLE ALL_USERS_ROLE; 
USE DATABASE DATAEXPERT_STUDENT; 
USE SCHEMA THOMRADAD4TA; 
USE WAREHOUSE COMPUTE_WH;

SHOW TABLES;

---> set the data retention time to 90 days
ALTER TABLE DATAEXPERT_STUDENT.RAW_POS.TEST_MENU 
    SET DATA_RETENTION_TIME_IN_DAYS = 90;

SHOW TABLES;

---> set the data retention time to 1 day
ALTER TABLE DATAEXPERT_STUDENT.RAW_POS.TEST_MENU 
    SET DATA_RETENTION_TIME_IN_DAYS = 1;

---> clone the truck table
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV 
    CLONE DATAEXPERT_STUDENT.RAW_POS.TRUCK;

SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model
FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV t;
    
---> see how the age should have been calculated
SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model,
    (YEAR(CURRENT_DATE()) - t.year) AS truck_age
FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV t;

---> record the most recent query_id, back when the data was still correct
SET good_data_query_id = LAST_QUERY_ID();

---> view the variable’s value
SELECT $good_data_query_id;

---> record the time (set variable), back when the data was still correct
SET good_data_timestamp = CURRENT_TIMESTAMP;

---> view the variable’s value
SELECT $good_data_timestamp;

---> confirm that that worked
SHOW VARIABLES;

---> make the first mistake: calculating the truck’s age incorrectly
SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model,
    (YEAR(CURRENT_DATE()) / t.year) AS truck_age
FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV t;

---> make the second mistake: calculate age wrong, and overwrite the year!
UPDATE DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV t
    SET t.year = (YEAR(CURRENT_DATE()) / t.year);

SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model
FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV t;

---> select the data as of a particular timestamp
SELECT * FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV
AT(TIMESTAMP => $good_data_timestamp);

SELECT $good_data_timestamp;

---> example code, without a timestamp inserted:

-- SELECT * FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV
-- AT(TIMESTAMP => '[insert timestamp]'::TIMESTAMP_LTZ);

---> example code, with a timestamp inserted
SELECT * FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV
AT(TIMESTAMP => '2024-04-04 21:34:31.833 -0700'::TIMESTAMP_LTZ);

---> calculate the right offset
SELECT TIMESTAMPDIFF(second, CURRENT_TIMESTAMP, $good_data_timestamp);

---> Example code, without an offset inserted:

-- SELECT * FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV
-- AT(OFFSET => -[WRITE OFFSET SECONDS PLUS A BIT]);

---> select the data as of a particular number of seconds back in time
SELECT * FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV
AT(OFFSET => -45);

SELECT $good_data_query_id;

---> select the data as of its state before a previous query was run
SELECT * FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV
BEFORE(STATEMENT => $good_data_query_id);
