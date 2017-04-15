-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/open_cursors.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all cursors currently open.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @open_cursors
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SELECT a.user_name,
       a.sid,
       a.sql_text
FROM   v$open_cursor a
ORDER BY 1,2
/
