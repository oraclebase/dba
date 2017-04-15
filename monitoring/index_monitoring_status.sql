-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/index_monitoring_status.sql
-- Author       : Tim Hall
-- Description  : Shows the monitoring status for the specified table indexes.
-- Call Syntax  : @index_monitoring_status (schema) (table-name or all)
-- Last Modified: 04/02/2005
-- -----------------------------------------------------------------------------------
SET VERIFY OFF

SELECT table_name,
       index_name,
       monitoring
FROM   v$object_usage
WHERE  table_name = UPPER('&1')
AND    index_name = DECODE(UPPER('&2'), 'ALL', index_name, UPPER('&2'));
