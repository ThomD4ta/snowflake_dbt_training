-- Role and environment
USE ROLE ALL_USERS_ROLE; 
USE DATABASE DATAEXPERT_STUDENT; 
USE WAREHOUSE COMPUTE_WH;

---> clone the truck table
CREATE TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV
    CLONE DATAEXPERT_STUDENT.RAW_POS.TRUCK;

SELECT * FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV;

---> save the most recent query id
SET saved_query_id = LAST_QUERY_ID();

---> save the current timestamp
SET saved_timestamp = CURRENT_TIMESTAMP;

---> variables: values in the “type” column for saved_query_id and saved_timestamp
SHOW VARIABLES;

---> Test query with time travel timestamp method
SELECT *
FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV
AT (TIMESTAMP => $saved_timestamp::TIMESTAMP_LTZ);

---> Test query with time travel query_id method
---> (Optional) Validate the saved query_id before using it 
SELECT $saved_query_id AS saved_query_id, 
TYPEOF($saved_query_id) AS query_id_type;

SELECT *
FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV
BEFORE (STATEMENT => $saved_query_id);

---> make an intentional mistake: overwrite the year with a wrong calculation
UPDATE DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV t
    SET t.year = (YEAR(CURRENT_DATE()) - 1000);