-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/monitoring_on.sql
-- Author       : Tim Hall
-- Description  : Sets monitoring off for the specified tables.
-- Call Syntax  : @monitoring_on (schema) (table-name or all)
-- Last Modified: 21/03/2003
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SPOOL temp.sql

SELECT 'ALTER TABLE "' || owner || '"."' || table_name || '" NOMONITORING;'
FROM   dba_tables
WHERE  owner      = UPPER('&1')
AND    table_name = DECODE(UPPER('&2'), 'ALL', table_name, UPPER('&2'))
AND    monitoring = 'YES';

SPOOL OFF

SET PAGESIZE 18
SET FEEDBACK ON

@temp.sql

