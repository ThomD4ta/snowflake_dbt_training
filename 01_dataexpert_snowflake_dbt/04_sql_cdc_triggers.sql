-- Change Data Capture Script example
-- Postgresql
-- Trigger + CDC

CREATE TRIGGER nba_players_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON nba_players
FOR EACH ROW EXECUTE FUNCTION log_nba_players_changes();

CREATE OR REPLACE FUNCTION log_nba_players_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO audit_log (operation_type, new_data)
        VALUES (TG_OP, row_to_json(NEW));
        RETURN NEW;

    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO audit_log (operation_type, old_data, new_data)
        VALUES (TG_OP, row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO audit_log (operation_type, old_data)
        VALUES (TG_OP, row_to_json(OLD));
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

