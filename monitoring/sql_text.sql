-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/sql_text.sql
-- Author       : Tim Hall
-- Description  : Displays the SQL statement held at the specified address.
-- Comments     : The address can be found using v$session or Top_SQL.sql.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @sql_text (address)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
SET FEEDBACK OFF
SET VERIFY OFF

SELECT a.sql_text
FROM   v$sqltext_with_newlines a
WHERE  a.address = UPPER('&&1')
ORDER BY a.piece;

PROMPT
SET PAGESIZE 14
SET FEEDBACK ON
