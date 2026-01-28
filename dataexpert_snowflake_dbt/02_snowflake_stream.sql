-- Change data Campture (CDC) in Snowflake
-- Streams

-- create table or sincronize stage
DROP TABLE IF EXISTS nba_players_lab;
CREATE TABLE nba_players_lab (
    player_name VARCHAR,
    is_active BOOLEAN
);

-- Create Stream
DROP STREAM IF EXISTS nba_players_changes_stream;
CREATE STREAM nba_players_changes_stream ON TABLE nba_players_lab;

INSERT INTO nba_players_lab
VALUES ('bruno', true);

select * from nba_players_lab;

-- Run stream to gather insert change metadata
select * from nba_players_changes_stream

-- consume stream
DROP TABLE IF EXISTS nba_players_lab_store_stream;
CREATE TABLE nba_players_lab_store_stream as (select * from nba_players_changes_stream);

select * from nba_players_lab_store_stream;

-- Common Operations to feed stream
INSERT INTO nba_players_lab
VALUES ('alice', true);

INSERT INTO nba_players_lab
VALUES ('bob', true);

DELETE FROM nba_players_lab
WHERE player_name = 'bruno'

