-- Role and environment
USE ROLE ALL_USERS_ROLE; 
USE DATABASE DATAEXPERT_STUDENT; 
USE SCHEMA THOMRADAD4TA; 
USE WAREHOUSE COMPUTE_WH;

-- Crear schemas equivalentes dentro de tu espacio personal 
CREATE OR REPLACE SCHEMA DATAEXPERT_STUDENT.RAW_POS;
CREATE OR REPLACE SCHEMA DATAEXPERT_STUDENT.RAW_CUSTOMER;
CREATE OR REPLACE SCHEMA DATAEXPERT_STUDENT.HARMONIZED;
CREATE OR REPLACE SCHEMA DATAEXPERT_STUDENT.ANALYTICS;

---> create warehouses (optional)
CREATE OR REPLACE WAREHOUSE demo_build_wh
    WAREHOUSE_SIZE = 'xxxlarge'
    WAREHOUSE_TYPE = 'standard'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
COMMENT = 'demo build warehouse for tasty bytes assets';
    
CREATE OR REPLACE WAREHOUSE tasty_de_wh
    WAREHOUSE_SIZE = 'xsmall'
    WAREHOUSE_TYPE = 'standard'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
COMMENT = 'data engineering warehouse for tasty bytes';

---> file format creation
CREATE OR REPLACE FILE FORMAT DATAEXPERT_STUDENT.THOMRADAD4TA.csv_ff
    TYPE = 'csv';

---> stage creation
CREATE OR REPLACE STAGE DATAEXPERT_STUDENT.THOMRADAD4TA.s3load
    URL = 's3://sfquickstarts/frostbyte_tastybytes/'
    FILE_FORMAT = DATAEXPERT_STUDENT.THOMRADAD4TA.csv_ff;

---> list files in stage
LS @DATAEXPERT_STUDENT.THOMRADAD4TA.s3load;

---> Create tables
---> country table build
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.country
(
    country_id NUMBER(18,0),
    country VARCHAR(16777216),
    iso_currency VARCHAR(3),
    iso_country VARCHAR(2),
    city_id NUMBER(19,0),
    city VARCHAR(16777216),
    city_population VARCHAR(16777216)
);

---> franchise table build
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.franchise 
(
    franchise_id NUMBER(38,0),
    first_name VARCHAR(16777216),
    last_name VARCHAR(16777216),
    city VARCHAR(16777216),
    country VARCHAR(16777216),
    e_mail VARCHAR(16777216),
    phone_number VARCHAR(16777216)
);

---> location table build
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.location
(
    location_id NUMBER(19,0),
    placekey VARCHAR(16777216),
    location VARCHAR(16777216),
    city VARCHAR(16777216),
    region VARCHAR(16777216),
    iso_country_code VARCHAR(16777216),
    country VARCHAR(16777216)
);

---> menu table build
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.menu
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

---> truck table build
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.truck
(
    truck_id NUMBER(38,0),
    menu_type_id NUMBER(38,0),
    primary_city VARCHAR(16777216),
    region VARCHAR(16777216),
    iso_region VARCHAR(16777216),
    country VARCHAR(16777216),
    iso_country_code VARCHAR(16777216),
    franchise_flag NUMBER(38,0),
    year NUMBER(38,0),
    make VARCHAR(16777216),
    model VARCHAR(16777216),
    ev_flag NUMBER(38,0),
    franchise_id NUMBER(38,0),
    truck_opening_date DATE
);

---> order_header table build
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.order_header
(
    order_id NUMBER(38,0),
    truck_id NUMBER(38,0),
    location_id FLOAT,
    customer_id NUMBER(38,0),
    discount_id VARCHAR(16777216),
    shift_id NUMBER(38,0),
    shift_start_time TIME(9),
    shift_end_time TIME(9),
    order_channel VARCHAR(16777216),
    order_ts TIMESTAMP_NTZ(9),
    served_ts VARCHAR(16777216),
    order_currency VARCHAR(3),
    order_amount NUMBER(38,4),
    order_tax_amount VARCHAR(16777216),
    order_discount_amount VARCHAR(16777216),
    order_total NUMBER(38,4)
);

---> order_detail table build
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_POS.order_detail 
(
    order_detail_id NUMBER(38,0),
    order_id NUMBER(38,0),
    menu_item_id NUMBER(38,0),
    discount_id VARCHAR(16777216),
    line_number NUMBER(38,0),
    quantity NUMBER(5,0),
    unit_price NUMBER(38,4),
    price NUMBER(38,4),
    order_item_discount_amount VARCHAR(16777216)
);

---> Raw customer schema
---> customer_loyalty table build
CREATE OR REPLACE TABLE DATAEXPERT_STUDENT.RAW_CUSTOMER.customer_loyalty
(
    customer_id NUMBER(38,0),
    first_name VARCHAR(16777216),
    last_name VARCHAR(16777216),
    city VARCHAR(16777216),
    country VARCHAR(16777216),
    postal_code VARCHAR(16777216),
    preferred_language VARCHAR(16777216),
    gender VARCHAR(16777216),
    favourite_brand VARCHAR(16777216),
    marital_status VARCHAR(16777216),
    children_count VARCHAR(16777216),
    sign_up_date DATE,
    birthday_date DATE,
    e_mail VARCHAR(16777216),
    phone_number VARCHAR(16777216)
);

---> Harmonized Layer (Views)
---> orders_v view 
CREATE OR REPLACE VIEW DATAEXPERT_STUDENT.HARMONIZED.orders_v AS
SELECT 
    oh.order_id,
    oh.truck_id,
    oh.order_ts,
    od.order_detail_id,
    od.line_number,
    m.truck_brand_name,
    m.menu_type,
    t.primary_city,
    t.region,
    t.country,
    t.franchise_flag,
    t.franchise_id,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name,
    l.location_id,
    cl.customer_id,
    cl.first_name,
    cl.last_name,
    cl.e_mail,
    cl.phone_number,
    cl.children_count,
    cl.gender,
    cl.marital_status,
    od.menu_item_id,
    m.menu_item_name,
    od.quantity,
    od.unit_price,
    od.price,
    oh.order_amount,
    oh.order_tax_amount,
    oh.order_discount_amount,
    oh.order_total
FROM DATAEXPERT_STUDENT.RAW_POS.order_detail od
JOIN DATAEXPERT_STUDENT.RAW_POS.order_header oh
    ON od.order_id = oh.order_id
JOIN DATAEXPERT_STUDENT.RAW_POS.truck t
    ON oh.truck_id = t.truck_id
JOIN DATAEXPERT_STUDENT.RAW_POS.menu m
    ON od.menu_item_id = m.menu_item_id
JOIN DATAEXPERT_STUDENT.RAW_POS.franchise f
    ON t.franchise_id = f.franchise_id
JOIN DATAEXPERT_STUDENT.RAW_POS.location l
    ON oh.location_id = l.location_id
LEFT JOIN DATAEXPERT_STUDENT.RAW_CUSTOMER.customer_loyalty cl
    ON oh.customer_id = cl.customer_id;

---> loyalty_metrics_v view
CREATE OR REPLACE VIEW DATAEXPERT_STUDENT.HARMONIZED.customer_loyalty_metrics_v
AS
SELECT 
    cl.customer_id,
    cl.city,
    cl.country,
    cl.first_name,
    cl.last_name,
    cl.phone_number,
    cl.e_mail,
    SUM(oh.order_total) AS total_sales,
    ARRAY_AGG(DISTINCT oh.location_id) AS visited_location_ids_array
FROM DATAEXPERT_STUDENT.RAW_CUSTOMER.customer_loyalty cl
JOIN DATAEXPERT_STUDENT.RAW_POS.order_header oh
    ON cl.customer_id = oh.customer_id
GROUP BY 
    cl.customer_id,
    cl.city,
    cl.country,
    cl.first_name,
    cl.last_name,
    cl.phone_number,
    cl.e_mail;

---> orders_v view
CREATE OR REPLACE VIEW DATAEXPERT_STUDENT.ANALYTICS.orders_v
COMMENT = 'Tasty Bytes Order Detail View'
AS
SELECT 
    DATE(o.order_ts) AS date,
    *
FROM DATAEXPERT_STUDENT.HARMONIZED.orders_v o;

---> Analytics Layer
---> customer_loyalty_metrics_v view
CREATE OR REPLACE VIEW DATAEXPERT_STUDENT.ANALYTICS.customer_loyalty_metrics_v
COMMENT = 'Tasty Bytes Customer Loyalty Member Metrics View'
AS
SELECT *
FROM DATAEXPERT_STUDENT.HARMONIZED.customer_loyalty_metrics_v;

---> table loads
USE ROLE ALL_USERS_ROLE;
USE DATABASE DATAEXPERT_STUDENT;
USE SCHEMA THOMRADAD4TA;
USE WAREHOUSE COMPUTE_WH;

---> country table load
COPY INTO DATAEXPERT_STUDENT.RAW_POS.country
FROM @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage/raw_pos/country/;

---> franchise table load
COPY INTO DATAEXPERT_STUDENT.RAW_POS.franchise
FROM @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage/raw_pos/franchise/;

---> location table load
COPY INTO DATAEXPERT_STUDENT.RAW_POS.location
FROM @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage/raw_pos/location/;

---> menu table load
COPY INTO DATAEXPERT_STUDENT.RAW_POS.menu
FROM @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage/raw_pos/menu/;

---> truck table load
COPY INTO DATAEXPERT_STUDENT.RAW_POS.truck
FROM @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage/raw_pos/truck/;

---> customer_loyalty table load
COPY INTO DATAEXPERT_STUDENT.RAW_CUSTOMER.customer_loyalty
FROM @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage/raw_customer/customer_loyalty/;

---> order_header table load
COPY INTO DATAEXPERT_STUDENT.RAW_POS.order_header
FROM @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage/raw_pos/order_header/;

---> order_detail table load
COPY INTO DATAEXPERT_STUDENT.RAW_POS.order_detail
FROM @DATAEXPERT_STUDENT.THOMRADAD4TA.blob_stage/raw_pos/order_detail/;

---> last_time_load audit (Snowflake tool)

SELECT 
    file_name, 
    error_count, 
    status, 
    last_load_time 
FROM snowflake.account_usage.copy_history
ORDER BY last_load_time DESC
LIMIT 10;

-- Es ideal para:
-- verificar si tus cargas desde S3 funcionaron
-- detectar errores en archivos CSV/JSON/Parquet
-- confirmar si Snowflake saltó archivos duplicados
-- auditar cargas históricas
-- monitorear pipelines ETL/ELT
