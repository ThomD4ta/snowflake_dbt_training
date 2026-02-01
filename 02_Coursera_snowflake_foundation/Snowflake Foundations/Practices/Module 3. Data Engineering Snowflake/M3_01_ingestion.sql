-- Ingestion Aternative Snowflake

-- Streaming Ingest (Ingesta por Streaming)
CREATE PIPE S3_db.public.S3_pipe AUTO_INGEST=TRUE AS
  COPY INTO S3_db.public.S3_table
  FROM @S3_db.public.S3_stage;

-- 2. Batch Ingest (Ingesta por Lotes)
COPY INTO frostbyte_tasty_bytes.raw_pos.menu
FROM @frostbyte_tasty_bytes.public.s3load/raw_pos/menu/;

-- 3. Snowflake Native Connectors (Conectores Nativos)
-- Script (Python/SQLAlchemy):
from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine

engine = create_engine(URL(
    account = 'myorganization-myaccount',
    user = 'testuser1',
    password = '0123456',
    database = 'testdb',
    schema = 'public',
    warehouse = 'testwh',
    role='myrole',
))
connection = engine.connect()

-- 4. In-place Data Sharing (Compartición de Datos)
CREATE DATABASE shared_data FROM SHARE data_sharing_account.data_to_share;
