-- Orchestration Aternative Snowflake

-- 1. Streams and 
CREATE STREAM sales_stream
ON TABLE sales;

-- Script SQL Tasks (Serverless Tasks):
CREATE TASK sales_task
   WAREHOUSE = xsmall_vwh
   SCHEDULE = '1 minute' as
   INSERT INTO new_sales (
   SELECT KEY, cust_id, amount
   FROM sales_stream
   WHERE metadata$action = 'INSERT');