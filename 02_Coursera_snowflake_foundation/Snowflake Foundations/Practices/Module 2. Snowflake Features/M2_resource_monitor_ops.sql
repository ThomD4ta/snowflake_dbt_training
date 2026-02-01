---> create a resource monitor as a variable
CREATE RESOURCE MONITOR DATAEXPERT_TEST_RM
WITH 
    CREDIT_QUOTA = 20 -- 20 credits
    FREQUENCY = daily -- reset the monitor daily
    START_TIMESTAMP = immediately -- begin tracking immediately
    TRIGGERS 
        ON 80 PERCENT DO NOTIFY -- notify accountadmins at 80%
        ON 100 PERCENT DO SUSPEND -- suspend warehouse at 100 percent, let queries finish
        ON 110 PERCENT DO SUSPEND_IMMEDIATE; -- suspend warehouse and cancel all queries at 110 percent

---> see all resource monitors
SHOW RESOURCE MONITORS;

---> assign a resource monitor to a warehouse
ALTER WAREHOUSE DATAEXPERT_DE_WH SET RESOURCE_MONITOR = DATAEXPERT_TEST_RM;

SHOW RESOURCE MONITORS;

---> change the credit quota on a resource monitor
ALTER RESOURCE MONITOR DATAEXPERT_TEST_RM
  SET CREDIT_QUOTA = 30;

SHOW RESOURCE MONITORS;

---> drop a resource monitor
DROP RESOURCE MONITOR DATAEXPERT_TEST_RM;

SHOW RESOURCE MONITORS;
