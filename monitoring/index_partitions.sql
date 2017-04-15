-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/index_partitions.sql
-- Author       : Tim Hall
-- Description  : Displays partition information for the specified index, or all indexes.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @index_patitions (index_name or all) (schema-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
SET FEEDBACK OFF
SET VERIFY OFF

SELECT a.index_name,
       a.partition_name,
       a.tablespace_name,
       a.initial_extent,
       a.next_extent,
       a.pct_increase,
       a.num_rows
FROM   dba_ind_partitions a
WHERE  a.index_name  = Decode(Upper('&&1'),'ALL',a.index_name,Upper('&&1'))
AND    a.index_owner = Upper('&&2')
ORDER BY a.index_name, a.partition_name
/

PROMPT
SET PAGESIZE 14
SET FEEDBACK ON
