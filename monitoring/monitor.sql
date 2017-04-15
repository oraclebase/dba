-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/monitor.sql
-- Author       : Tim Hall
-- Description  : Displays SQL statements for the current database sessions.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @monitor
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 255
COL SID FORMAT 999
COL STATUS FORMAT A8
COL PROCESS FORMAT A10
COL SCHEMANAME FORMAT A16
COL OSUSER  FORMAT A16
COL SQL_TEXT FORMAT A120 HEADING 'SQL QUERY'
COL PROGRAM	FORMAT A30

SELECT s.sid,
       s.status,
       s.process,
       s.schemaname,
       s.osuser,
       a.sql_text,
       p.program
FROM   v$session s,
       v$sqlarea a,
       v$process p
WHERE  s.SQL_HASH_VALUE = a.HASH_VALUE
AND    s.SQL_ADDRESS = a.ADDRESS
AND    s.PADDR = p.ADDR
/

SET VERIFY ON
SET LINESIZE 255