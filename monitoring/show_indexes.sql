-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/show_indexes.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays information about specified indexes.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @show_indexes (schema) (table-name or all)
-- Last Modified: 04/10/2006
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 200

COLUMN table_owner FORMAT A20
COLUMN index_owner FORMAT A20
COLUMN index_type FORMAT A12
COLUMN tablespace_name FORMAT A20

SELECT table_owner,
       table_name,
       owner AS index_owner,
       index_name,
       tablespace_name,
       num_rows,
       status,
       index_type
FROM   dba_indexes
WHERE  table_owner = UPPER('&1')
AND    table_name = DECODE(UPPER('&2'), 'ALL', table_name, UPPER('&2'))
ORDER BY table_owner, table_name, index_owner, index_name;
