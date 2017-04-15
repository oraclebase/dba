-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/table_triggers.sql
-- Author       : Tim Hall
-- Description  : Lists the triggers for the specified table.
-- Call Syntax  : @table_triggers (schema) (table_name)
-- Last Modified: 07/11/2016
-- -----------------------------------------------------------------------------------
SELECT owner,
       trigger_name,
       status
FROM   dba_triggers
WHERE  table_owner = UPPER('&1')
AND    table_name = UPPER('&2');