-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/index_monitoring_on.sql
-- Author       : Tim Hall
-- Description  : Sets monitoring on for the specified table indexes.
-- Call Syntax  : @index_monitoring_on (schema) (table-name or all)
-- Last Modified: 04/02/2005
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SPOOL temp.sql

SELECT 'ALTER INDEX "' || i.owner || '"."' || i.index_name || '" MONITORING USAGE;'
FROM   dba_indexes i
WHERE  owner      = UPPER('&1')
AND    table_name = DECODE(UPPER('&2'), 'ALL', table_name, UPPER('&2'));

SPOOL OFF

SET PAGESIZE 18
SET FEEDBACK ON

@temp.sql

