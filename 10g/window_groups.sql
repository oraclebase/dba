-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/window_groups.sql
-- Author       : Tim Hall
-- Description  : Displays scheduler information about window groups.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @window_groups
-- Last Modified: 05/11/2004
-- -----------------------------------------------------------------------------------
SET LINESIZE 250

COLUMN comments FORMAT A40

SELECT window_group_name,
       enabled,
       number_of_windows,
       comments
FROM   dba_scheduler_window_groups
ORDER BY window_group_name;

SELECT window_group_name,
       window_name
FROM   dba_scheduler_wingroup_members
ORDER BY window_group_name, window_name;
