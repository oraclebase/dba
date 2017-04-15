-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/windows.sql
-- Author       : Tim Hall
-- Description  : Displays scheduler information about windows.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @windows
-- Last Modified: 05/11/2004
-- -----------------------------------------------------------------------------------
SET LINESIZE 250

COLUMN comments FORMAT A40

SELECT window_name,
       resource_plan,
       enabled,
       active,
       comments
FROM   dba_scheduler_windows
ORDER BY window_name;
