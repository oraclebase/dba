-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/monitoring_status.sql
-- Author       : Tim Hall
-- Description  : Shows the monitoring status for the specified tables.
-- Call Syntax  : @monitoring_status (schema) (table-name or all)
-- Last Modified: 21/03/2003
-- -----------------------------------------------------------------------------------
SET VERIFY OFF

SELECT table_name, monitoring 
FROM   dba_tables
WHERE  owner = UPPER('&1')
AND    table_name = DECODE(UPPER('&2'), 'ALL', table_name, UPPER('&2'));
