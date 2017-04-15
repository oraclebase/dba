-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/index_extents.sql
-- Author       : Tim Hall
-- Description  : Displays number of extents for all indexes belonging to the specified table, or all tables.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @index_extents (table_name or all) (schema-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF

SELECT i.index_name,
       Count(e.segment_name) extents,
       i.max_extents,
       t.num_rows "ROWS",
       Trunc(i.initial_extent/1024) "INITIAL K",
       Trunc(i.next_extent/1024) "NEXT K",
       t.table_name
FROM   all_tables t,
       all_indexes i,
       dba_extents e
WHERE  i.table_name   = t.table_name
AND    i.owner        = t.owner
AND    e.segment_name = i.index_name
AND    e.owner        = i.owner
AND    i.table_name   = Decode(Upper('&&1'),'ALL',i.table_name,Upper('&&1'))
AND    i.owner        = Upper('&&2')
GROUP BY t.table_name,
         i.index_name,
         i.max_extents,
         t.num_rows,
         i.initial_extent,
         i.next_extent
HAVING   Count(e.segment_name) > 5
ORDER BY Count(e.segment_name) DESC;

SET PAGESIZE 18
SET VERIFY ON