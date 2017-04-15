-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/active_session_waits.sql
-- Author       : Tim Hall
-- Description  : Displays information on the current wait states for all active database sessions.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @active_session_waits
-- Last Modified: 21/12/2004
-- -----------------------------------------------------------------------------------
SET LINESIZE 250
SET PAGESIZE 1000

COLUMN username FORMAT A15
COLUMN osuser FORMAT A15
COLUMN sid FORMAT 99999
COLUMN serial# FORMAT 9999999
COLUMN wait_class FORMAT A15
COLUMN state FORMAT A19
COLUMN logon_time FORMAT A20

SELECT NVL(a.username, \'(oracle)\') AS username,
       a.osuser,
       a.sid,
       a.serial#,
       d.spid AS process_id,
       a.wait_class,
       a.seconds_in_wait,
       a.state,
       a.blocking_session,
       a.blocking_session_status,
       a.module,
       TO_CHAR(a.logon_Time,\'DD-MON-YYYY HH24:MI:SS\') AS logon_time
FROM   v$session a,
       v$process d
WHERE  a.paddr  = d.addr
AND    a.status = \'ACTIVE\'
ORDER BY 1,2;

SET PAGESIZE 14

