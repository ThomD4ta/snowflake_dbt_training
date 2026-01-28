-- Observability Aternative Snowflake

-- set snowflake alerts
CREATE ALERT my_alert
  WAREHOUSE = mywarehouse
  SCHEDULE = '1 minute'
  IF ( EXISTS(
    SELECT gauge_value FROM gauge WHERE gauge_value > 200))
  THEN
    INSERT INTO gauge_value_exceeded_history VALUES (current_timestamp());

-- set snowflake notifications
-- Email notification
CALL SYSTEM$SEND_EMAIL(
  'my_email_int',
  'first.last@example.com',
  'Email Alert: Task A has finished.',
  'Task A has successfully finished.\nTotal Records Processed: N'
);

-- Create event table
CREATE EVENT TABLE my_database.my_schema.my_events;


