---> see an example of a column with semi-structured (JSON) data
SELECT MENU_ITEM_NAME
    , MENU_ITEM_HEALTH_METRICS_OBJ
FROM DATAEXPERT_STUDENT.RAW_POS.MENU;

DESCRIBE TABLE DATAEXPERT_STUDENT.RAW_POS.MENU;


---> check out the data type for the menu_item_health_metrics_obj column – It’s a VARIANT 
CREATE TABLE DATAEXPERT_STUDENT.RAW_POS.MENU
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


---> create the test_menu table with just a variant column in it, as a test
CREATE TABLE DATAEXPERT_STUDENT.RAW_POS.TEST_MENU (cost_of_goods_variant)
AS SELECT cost_of_goods_usd::VARIANT -- Casting
FROM DATAEXPERT_STUDENT.RAW_POS.MENU;


---> notice that the column is of the VARIANT type
DESCRIBE TABLE DATAEXPERT_STUDENT.RAW_POS.TEST_MENU;


---> but the typeof() function reveals the underlying data type
SELECT TYPEOF(cost_of_goods_variant) 
FROM DATAEXPERT_STUDENT.RAW_POS.TEST_MENU;


---> Snowflake lets you perform operations based on the underlying data type
SELECT cost_of_goods_variant, cost_of_goods_variant * 2.0 
FROM DATAEXPERT_STUDENT.RAW_POS.TEST_MENU;


DROP TABLE DATAEXPERT_STUDENT.RAW_POS.TEST_MENU;


---> you can use the colon to pull out info from menu_item_health_metrics_obj
SELECT MENU_ITEM_HEALTH_METRICS_OBJ:menu_item_health_metrics 
FROM DATAEXPERT_STUDENT.RAW_POS.MENU;


---> use typeof() to see the underlying type
SELECT TYPEOF(MENU_ITEM_HEALTH_METRICS_OBJ) 
FROM DATAEXPERT_STUDENT.RAW_POS.MENU;


SELECT MENU_ITEM_HEALTH_METRICS_OBJ, 
       MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_id'] 
FROM DATAEXPERT_STUDENT.RAW_POS.MENU;

-- Unstructered data types
---> see an example of a column with semi-structured (JSON) data
SELECT 
    MENU_ITEM_NAME,
    MENU_ITEM_HEALTH_METRICS_OBJ
FROM DATAEXPERT_STUDENT.RAW_POS.MENU;

DESCRIBE TABLE DATAEXPERT_STUDENT.RAW_POS.MENU;

-- se the TYPEOF function to check the underlying data type of MENU_ITEM_HEALTH_METRICS_OBJ
SELECT TYPEOF(MENU_ITEM_HEALTH_METRICS_OBJ) 
FROM DATAEXPERT_STUDENT.RAW_POS.MENU;

