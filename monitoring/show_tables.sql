-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/show_tables.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays information about specified tables.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @show_tables (schema)
-- Last Modified: 04/10/2006
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 200

COLUMN owner FORMAT A20
COLUMN table_name FORMAT A30

SELECT t.table_name,
       t.tablespace_name,
       t.num_rows,
       t.avg_row_len,
       t.blocks,
       t.empty_blocks,
       ROUND(t.blocks * ts.block_size/1024/1024,2) AS size_mb
FROM   dba_tables t
       JOIN dba_tablespaces ts ON t.tablespace_name = ts.tablespace_name
WHERE  t.owner = UPPER('&1')
ORDER BY t.table_name;
