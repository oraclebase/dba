-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/sql_area.sql
-- Author       : Tim Hall
-- Description  : Displays the SQL statements for currently running processes.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @sql_area
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
SET FEEDBACK OFF

SELECT s.sid,
       s.status "Status",
       p.spid "Process",
       s.schemaname "Schema Name",
       s.osuser "OS User",
       Substr(a.sql_text,1,120) "SQL Text",
       s.program "Program"
FROM   v$session s,
       v$sqlarea a,
       v$process p
WHERE  s.sql_hash_value = a.hash_value (+)
AND    s.sql_address    = a.address (+)
AND    s.paddr          = p.addr;

SET PAGESIZE 14
SET FEEDBACK ON

