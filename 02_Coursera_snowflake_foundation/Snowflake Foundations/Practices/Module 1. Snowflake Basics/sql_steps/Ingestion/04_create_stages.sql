-- 4. create the Stage referencing the Blob location and CSV File Format
CREATE OR REPLACE STAGE DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage
url = 's3://sfquickstarts/tastybytes/'
file_format = (type = csv);

-- 4.1 query blob stages
SHOW STAGES;
SHOW STAGES IN SCHEMA DATAEXPERT_STUDENT.THOMRADAD4TA;
DESCRIBE STAGE DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage;

-- 4.2. Files in the blob stage to find the Menu CSV file
LIST @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage;