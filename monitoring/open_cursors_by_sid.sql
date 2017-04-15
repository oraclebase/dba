-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/open_cursors_by_sid.sql
-- Author       : Tim Hall
-- Description  : Displays the SQL statement held for a specific SID.
-- Comments     : The SID can be found by running session.sql or top_session.sql.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @open_cursors_by_sid (sid)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF

SELECT oc.sql_text, cursor_type
FROM   v$open_cursor oc
WHERE  oc.sid = &1
ORDER BY cursor_type;

PROMPT
SET PAGESIZE 14