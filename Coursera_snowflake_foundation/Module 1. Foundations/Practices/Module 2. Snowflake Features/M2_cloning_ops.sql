---> create a clone of the truck table
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_CLONE 
    CLONE DATAEXPERT_STUDENT.RAW_POS.TRUCK;

/* look at metadata for the truck and truck_clone tables from the table_storage_metrics view in the information_schema */
SELECT * FROM DATAEXPERT_STUDENT.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

/* look at metadata for the truck and truck_clone tables from the tables view in the information_schema */
SELECT * FROM DATAEXPERT_STUDENT.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

---> insert the truck table into the clone (thus doubling the clone’s size!)
INSERT INTO DATAEXPERT_STUDENT.RAW_POS.TRUCK_CLONE
SELECT * FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK;

---> now use the tables view to look at metadata for the truck and truck_clone tables again
SELECT * FROM DATAEXPERT_STUDENT.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

---> clone a schema
CREATE OR REPLACE SCHEMA DATAEXPERT_STUDENT.RAW_POS_CLONE
CLONE DATAEXPERT_STUDENT.RAW_POS;

---> clone a database
CREATE OR REPLACE DATABASE DATAEXPERT_STUDENT_CLONE
CLONE DATAEXPERT_STUDENT;

---> clone a table based on an offset (so the table as it was at a certain interval in the past) 
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_CLONE_TIME_TRAVEL 
    CLONE DATAEXPERT_STUDENT.RAW_POS.TRUCK AT(OFFSET => -60*10);

SELECT * FROM DATAEXPERT_STUDENT.RAW_POS.TRUCK_CLONE_TIME_TRAVEL;
