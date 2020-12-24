-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/21c/blockchain_tables.sql
-- Author       : Tim Hall
-- Description  : Display blockchain tables in the specified schema, or all schemas.
-- Call Syntax  : @blockchain_tables (schema or all)
-- Last Modified: 23/12/2020
-- -----------------------------------------------------------------------------------
set linesize 200 verify off trimspool on

column schema_name format a30
column table_name format a30
column row_retention format a13
column row_retention_locked format a20
column table_inactivity_retention format a26
column hash_algorithm format a14

SELECT schema_name,
       table_name,
       row_retention,
       row_retention_locked, 
       table_inactivity_retention,
       hash_algorithm  
FROM   dba_blockchain_tables 
WHERE  schema_name = DECODE(UPPER('&1'), 'ALL', schema_name, UPPER('&1'));

