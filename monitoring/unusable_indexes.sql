-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/unusable_indexes.sql
-- Author       : Tim Hall
-- Description  : Displays unusable indexes for the specified schema or all schemas.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @unusable_indexes (schema-name or all)
-- Last Modified: 28/01/2018
-- -----------------------------------------------------------------------------------
SET VERIFY OFF LINESIZE 200

COLUMN owner FORMAT A30
COLUMN index_name FORMAT A30
COLUMN table_owner FORMAT A30
COLUMN table_name FORMAT A30

SELECT owner,
       index_name,
       index_type,
       table_owner,
       table_name
       table_type
FROM   dba_indexes
WHERE  owner = DECODE(UPPER('&1'), 'ALL', owner, UPPER('&1'))
AND    status NOT IN ('VALID', 'N/A')
ORDER BY owner, index_name;

