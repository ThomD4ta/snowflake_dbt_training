-- transformation Aternative Snowflake


-- 1. Snowpark Dataframes (API de Dataframes de Snowpark)
f_table = df_table.SELECT(COL("MENU_ITEM_NAME"), COL("ITEM_CATEGORY"))

-- 2. Dynamic Tables (Dynamic Tables with incremental refreshes)
CREATE DYNAMIC TABLE customer_sales_data_history
  LAG='1 MINUTE'
  WAREHOUSE=lab_s_wh
AS
SELECT
  customer_id,
  product_id,
  saleprice
FROM
  salesdata;

  -- 3. Stored Procedures
  CREATE OR REPLACE PROCEDURE delete_old()
RETURNS BOOLEAN
LANGUAGE SQL
AS
$$
DECLARE
  max_ts TIMESTAMP;
  cutoff_ts TIMESTAMP;
BEGIN
  max_ts := (SELECT MAX(ORDER_TS) FROM FROSTBYTE_TASTY_BYTES_CLONE.RAW_POS.ORDER_HEADER);
  cutoff_ts := (SELECT DATEADD('DAY',-180,:max_ts));
  DELETE FROM FROSTBYTE_TASTY_BYTES_CLONE.RAW_POS.ORDER_HEADER
  WHERE ORDER_TS < :cutoff_ts;
END;
$$

-- 4. UDFs, UDTFs (Python, SQL, etc.)
CREATE FUNCTION max_menu_price()
RETURNS NUMBER(5,2)
AS
$$
  SELECT MAX(SALE_PRICE_USD) FROM FROSTBYTE_TASTY_BYTES.RAW_POS.MENU
$$
;

-- 5. SQL (including SQL functions)
SELECT MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_health_metrics']
FROM FROSTBYTE_TASTY_BYTES.RAW_POS.MENU;