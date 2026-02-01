-- Clustering Snowflake
-- Merge + clustering commands

-- Create merge_example table
drop table if exists merge_example;
create table merge_example (
    id INT
    , status VARCHAR
);

insert into merge_example(id, status) values (1, 'new'), (2, 'new');

select * from merge_example;

-- MERGE command
merge into merge_example using (
    select 1 as id, 'shipped' as status union all
    select 3 as id, 'new' as status
) as new_data

on merge_example.id = new_data.id
when matched then update set merge_example.status = new_data.status
when not matched then insert (id, status) values (new_data.id, new_data.status);

-- CLustering Snowflake sample data
select * from snowflake_sample_data.TPCH_SF10.ORDERS

-- Create normal table
create or replace table cluster_example_1 as (select * from snowflake_sample_data.tpch_sf10.orders);

-- Create Clustered Table
create or replace table cluster_example_2 CLUSTER BY (O_ORDERDATE) as (select * from snowflake_sample_data.tpch_sf10.orders);

SELECT * FROM CLUSTER_EXAMPLE_1
LIMIT 1

SELECT TABLE_NAME, CLUSTERING_KEY
FROM DATAEXPERT_STUDENT.INFORMATION_SCHEMA.TABLES -- Metadata
WHERE
    TABLE_SCHEMA = 'THOMRADAD4TA'
    and (
        TABLE_NAME = 'CLUSTER_EXAMPLE_1'
        OR TABLE_NAME = 'CLUSTER_EXAMPLE_2'
    )

SELECT SYSTEM$CLUSTERING_DEPTH('CLUSTER_EXAMPLE_1');
SELECT SYSTEM$CLUSTERING_DEPTH('CLUSTER_EXAMPLE_2');

SELECT *
FROM CLUSTER_EXAMPLE_2
WHERE O_ORDERDATE = '1997-07-07'