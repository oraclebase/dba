-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/tablespaces.sql
-- Author       : Tim Hall
-- Description  : Displays information about tablespaces.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @tablespaces
-- Last Modified: 17-AUG-2005
-- -----------------------------------------------------------------------------------

SET LINESIZE 200

SELECT tablespace_name,
       block_size,
       extent_management,
       allocation_type,
       segment_space_management,
       status
FROM   dba_tablespaces
ORDER BY tablespace_name;
