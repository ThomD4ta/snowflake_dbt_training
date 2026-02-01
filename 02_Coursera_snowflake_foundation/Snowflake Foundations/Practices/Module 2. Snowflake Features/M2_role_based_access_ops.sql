-- Role and environment
USE ROLE ALL_USERS_ROLE; 
USE DATABASE DATAEXPERT_STUDENT; 
USE SCHEMA THOMRADAD4TA; 
USE WAREHOUSE COMPUTE_WH;

USE ROLE accountadmin;

---> create a role
CREATE ROLE dataexpert_de;

---> see what privileges this new role has
SHOW GRANTS TO ROLE dataexpert_de;

---> see what privileges an auto-generated role has
SHOW GRANTS TO ROLE accountadmin;

---> grant a role to a specific user
GRANT ROLE dataexpert_de TO USER [username];

---> use a role
USE ROLE dataexpert_de;

---> try creating a warehouse with this new role
CREATE WAREHOUSE dataexpert_de_test;

USE ROLE accountadmin;

---> grant the create warehouse privilege to the dataexpert_de role
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE dataexpert_de;

---> show all of the privileges the dataexpert_de role has
SHOW GRANTS TO ROLE dataexpert_de;

USE ROLE dataexpert_de;

---> test to see whether dataexpert_de can create a warehouse
CREATE WAREHOUSE dataexpert_de_test;

---> learn more about the privileges each of the following auto-generated roles has

SHOW GRANTS TO ROLE securityadmin;

SHOW GRANTS TO ROLE useradmin;

SHOW GRANTS TO ROLE sysadmin;

SHOW GRANTS TO ROLE public;
