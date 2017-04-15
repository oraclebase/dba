-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/table_partitions.sql
-- Author       : Tim Hall
-- Description  : Displays partition information for the specified table, or all tables.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @table_partitions (table-name or all) (schema-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
SET FEEDBACK OFF
SET VERIFY OFF

SELECT a.table_name,
       a.partition_name,
       a.tablespace_name,
       a.initial_extent,
       a.next_extent,
       a.pct_increase,
       a.num_rows,
       a.avg_row_len
FROM   dba_tab_partitions a
WHERE  a.table_name  = Decode(Upper('&&1'),'ALL',a.table_name,Upper('&&1'))
AND    a.table_owner = Upper('&&2')
ORDER BY a.table_name, a.partition_name
/


SET PAGESIZE 14
SET FEEDBACK ON
