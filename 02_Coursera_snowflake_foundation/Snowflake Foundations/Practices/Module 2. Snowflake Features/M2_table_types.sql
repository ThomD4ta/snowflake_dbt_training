-- Table types on Snowflake
---> drop truck_dev if not dropped previously
DROP TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_DEV;

---> create a transient table
CREATE TRANSIENT TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_TRANSIENT
    CLONE DATAEXPERT_STUDENT.RAW_POS.TRUCK;

---> create a temporary table
CREATE TEMPORARY TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_TEMPORARY
    CLONE DATAEXPERT_STUDENT.RAW_POS.TRUCK;

---> show tables that start with the word TRUCK
SHOW TABLES LIKE 'TRUCK%';

---> attempt (successfully) to set the data retention time to 90 days for the standard table
ALTER TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK SET DATA_RETENTION_TIME_IN_DAYS = 90;

---> attempt (unsuccessfully) to set the data retention time to 90 days for the transient table
ALTER TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_TRANSIENT SET DATA_RETENTION_TIME_IN_DAYS = 90;

---> attempt (unsuccessfully) to set the data retention time to 90 days for the temporary table
ALTER TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_TEMPORARY SET DATA_RETENTION_TIME_IN_DAYS = 90;

SHOW TABLES LIKE 'TRUCK%';

---> attempt (successfully) to set the data retention time to 0 days for the transient table
ALTER TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_TRANSIENT SET DATA_RETENTION_TIME_IN_DAYS = 0;

---> attempt (successfully) to set the data retention time to 0 days for the temporary table
ALTER TABLE DATAEXPERT_STUDENT.RAW_POS.TRUCK_TEMPORARY SET DATA_RETENTION_TIME_IN_DAYS = 0;

SHOW TABLES LIKE 'TRUCK%';
