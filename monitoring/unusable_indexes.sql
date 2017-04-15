-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/unusable_indexes.sql
-- Author       : Tim Hall
-- Description  : Displays unusable indexes for the specified schema or all schemas.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @unusable_indexes (schema-name or all)
-- Last Modified: 05/11/2004
-- -----------------------------------------------------------------------------------
SET VERIFY OFF

SELECT owner,
       index_name
FROM   dba_indexes
WHERE  owner = DECODE(UPPER('&1'), 'ALL', owner, UPPER('&1'))
AND    status NOT IN ('VALID', 'N/A')
ORDER BY owner, index_name;

