-- Roles & Warehouse

USE ROLE ALL_USERS_ROLE;

USE WAREHOUSE compute_wh;

---> Show or create the Tasty Bytes Database
SHOW DATABASES; -- DATAEXPERT_STUDENT: Priviledges & THOMRADAD4TA: No permissions
USE DATABASE DATAEXPERT_STUDENT;

-- CREATE OR REPLACE DATABASE tasty_bytes_sample_data;

---> Show Schemas or create the Raw POS (Point-of-Sale) Schema
SHOW SCHEMAS IN DATABASE DATAEXPERT_STUDENT;
USE SCHEMA THOMRADAD4TA;

-- CREATE OR REPLACE SCHEMA tasty_bytes_sample_data.raw_pos;

---> create the Raw Menu Table
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU
-- CREATE OR REPLACE TABLE tasty_bytes_sample_data.raw_pos.menu
(
    menu_id NUMBER(19,0),
    menu_type_id NUMBER(38,0),
    menu_type VARCHAR(16777216),
    truck_brand_name VARCHAR(16777216),
    menu_item_id NUMBER(38,0),
    menu_item_name VARCHAR(16777216),
    item_category VARCHAR(16777216),
    item_subcategory VARCHAR(16777216),
    cost_of_goods_usd NUMBER(38,4),
    sale_price_usd NUMBER(38,4),
    menu_item_health_metrics_obj VARIANT
);

---> create the Stage referencing the Blob location and CSV File Format
CREATE OR REPLACE STAGE DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage
url = 's3://sfquickstarts/tastybytes/'
file_format = (type = csv);

-- CREATE OR REPLACE STAGE tasty_bytes_sample_data.public.blob_stage
-- url = 's3://sfquickstarts/tastybytes/'
-- file_format = (type = csv);

---> Query Stages
SHOW STAGES;
SHOW STAGES IN SCHEMA DATAEXPERT_STUDENT.THOMRADAD4TA;
DESCRIBE STAGE DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage;

---> Files in the blob stage to find the Menu CSV file
LIST @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage;
-- LIST @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;

---> copy the Menu file into the Menu table
COPY INTO DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU
FROM @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage/raw_pos/menu/;

-- COPY INTO tasty_bytes_sample_data.raw_pos.menu
-- FROM @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;