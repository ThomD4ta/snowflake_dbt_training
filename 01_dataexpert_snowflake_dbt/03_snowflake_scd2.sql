-- Slowly Changing Dimension 2 (SCD2) in Snowflake
-- Streams + Merge

-- Create Table without Table
DROP TABLE IF EXISTS nba_players_lab;
CREATE TABLE nba_players_lab (
    player_name VARCHAR,
    is_active BOOLEAN
);

-- Create Stream
DROP STREAM IF EXISTS nba_players_changes_stream;
CREATE STREAM nba_players_changes_stream ON TABLE nba_players_lab;

-- consume stream
DROP TABLE IF EXISTS nba_players_lab_store_stream;
CREATE TABLE nba_players_lab_store_stream as (select * from nba_players_changes_stream);

select * from nba_players_lab_store_stream;

-- Create SCD2 table to collect historical data
DROP TABLE IF EXISTS nba_players_scd_lab;
create table nba_players_scd_lab (
    player_name VARCHAR,
    is_active BOOLEAN,
    start_season INTEGER, -- valid from
    end_season INTEGER -- valid to
);

SET season = 1996;

MERGE INTO nba_players_lab target USING (
    WITH this_season AS (
        SELECT * FROM dataexpert_student.bootcamp.nba_player_seasons
        WHERE season = $season
    )
    SELECT COALESCE(n.player_name, s.player_name) as player_name,
           s.player_name IS NOT NULL as is_active_this_season,
           n.player_name IS NOT NULL as is_active_last_season
    FROM this_season s
    FULL OUTER JOIN nba_players_lab n ON s.player_name = n.player_name
) as v
ON target.player_name = v.player_name
WHEN MATCHED AND NOT v.is_active_this_season THEN DELETE
WHEN NOT MATCHED THEN INSERT (player_name, is_active) values (v.player_name, true);

-- Update SCD2 table
MERGE INTO nba_players_scd_lab target USING (
  SELECT
    player_name,
    is_active,
    METADATA$action as action,
    METADATA$isupdate as is_update,
    CURRENT_TIMESTAMP() as timestamp
  FROM nba_players_changes_stream
) changes ON target.player_name = changes.player_name AND target.end_season is null
WHEN MATCHED AND ACTION = 'DELETE' THEN UPDATE SET target.end_season = $season - 1
WHEN NOT MATCHED and ACTION = 'INSERT' THEN INSERT (player_name, is_active, start_season, end_season) VALUES (changes.player_name, changes.is_active, $season, null);

SELECT * FROM nba_players_scd_lab;
