---> create the orders_v view – note the “CREATE VIEW view_name AS SELECT” syntax
CREATE OR REPLACE VIEW DATAEXPERT_STUDENT.HARMONIZED.ORDERS_V AS
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
FROM DATAEXPERT_STUDENT.RAW_POS.ORDER_DETAIL od
JOIN DATAEXPERT_STUDENT.RAW_POS.ORDER_HEADER oh
    ON od.order_id = oh.order_id
JOIN DATAEXPERT_STUDENT.RAW_POS.TRUCK t
    ON oh.truck_id = t.truck_id
JOIN DATAEXPERT_STUDENT.RAW_POS.MENU m
    ON od.menu_item_id = m.menu_item_id
JOIN DATAEXPERT_STUDENT.RAW_POS.FRANCHISE f
    ON t.franchise_id = f.franchise_id
JOIN DATAEXPERT_STUDENT.RAW_POS.LOCATION l
    ON oh.location_id = l.location_id
LEFT JOIN DATAEXPERT_STUDENT.RAW_CUSTOMER.CUSTOMER_LOYALTY cl
    ON oh.customer_id = cl.customer_id;


SELECT COUNT(*) 
FROM DATAEXPERT_STUDENT.HARMONIZED.ORDERS_V;

---> see metadata about ORDERS_V view
DESCRIBE VIEW DATAEXPERT_STUDENT.HARMONIZED.ORDERS_V;

---> create BRAND_NAMES view
CREATE OR REPLACE VIEW DATAEXPERT_STUDENT.HARMONIZED.BRAND_NAMES AS
SELECT truck_brand_name
FROM DATAEXPERT_STUDENT.RAW_POS.MENU;

SHOW VIEWS IN SCHEMA DATAEXPERT_STUDENT.HARMONIZED;

---> select the Brand_names view
SELECT * 
FROM DATAEXPERT_STUDENT.HARMONIZED.BRAND_NAMES;

---> see metadata about the BRAND_NAMES view we just made
DESCRIBE MATERIALIZED VIEW DATAEXPERT_STUDENT.HARMONIZED.BRAND_NAMES;

---> drop BRAND_NAMES view
DROP VIEW DATAEXPERT_STUDENT.HARMONIZED.BRAND_NAMES;


---> create BRAND_NAMES_MATERIALIZED materialized view
CREATE OR REPLACE MATERIALIZED VIEW DATAEXPERT_STUDENT.HARMONIZED.BRAND_NAMES_MATERIALIZED AS
SELECT DISTINCT truck_brand_name
FROM DATAEXPERT_STUDENT.RAW_POS.MENU;

---> select the materialized view
SELECT * 
FROM DATAEXPERT_STUDENT.HARMONIZED.BRAND_NAMES_MATERIALIZED;

---> see metadata about the materialized view we just made
DESCRIBE MATERIALIZED VIEW DATAEXPERT_STUDENT.HARMONIZED.BRAND_NAMES_MATERIALIZED;

---> drop the materialized view
DROP MATERIALIZED VIEW DATAEXPERT_STUDENT.HARMONIZED.BRAND_NAMES_MATERIALIZED;


---> Use the CREATE VIEW command to create a “truck_franchise” view of the following query:
CREATE OR REPLACE VIEW DATAEXPERT_STUDENT.TRUCK_FRANCHISE
SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM DATAEXPERT_STUDENT.raw_pos.truck t
JOIN DATAEXPERT_STUDENT.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;