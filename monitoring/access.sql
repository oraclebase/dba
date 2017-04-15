-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/access.sql
-- Author       : Tim Hall
-- Description  : Lists all objects being accessed in the schema.
-- Call Syntax  : @access (schema-name or all) (object-name or all)
-- Requirements : Access to the v$views.
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 255
SET VERIFY OFF

COLUMN object FORMAT A30

SELECT a.object,
       a.type,
       a.sid,
       b.serial#,
       b.username,
       b.osuser,
       b.program
FROM   v$access a,
       v$session b
WHERE  a.sid    = b.sid
AND    a.owner  = DECODE(UPPER('&1'), 'ALL', a.object, UPPER('&1'))
AND    a.object = DECODE(UPPER('&2'), 'ALL', a.object, UPPER('&2'))
ORDER BY a.object;
