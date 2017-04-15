-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/part_tables.sql
-- Author       : Tim Hall
-- Description  : Displays information about all partitioned tables.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @part_tables
-- Last Modified: 21/12/2004
-- -----------------------------------------------------------------------------------

SELECT owner, table_name, partitioning_type, partition_count
FROM   dba_part_tables
WHERE  owner NOT IN ('SYS', 'SYSTEM')
ORDER BY owner, table_name;
