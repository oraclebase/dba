-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/sessions_by_osuser.sql
-- Author       : Tim Hall
-- Description  : Displays the number of sessions for each OS user.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @sessions_by_osuser (osuser)
-- Last Modified: 11-MAR-2025
-- -----------------------------------------------------------------------------------
SET LINESIZE 500 PAGESIZE 1000 VERIFY OFF

COLUMN username FORMAT A30
COLUMN osuser FORMAT A20
COLUMN spid FORMAT A10
COLUMN service_name FORMAT A15
COLUMN module FORMAT A45
COLUMN machine FORMAT A30
COLUMN logon_time FORMAT A20

SELECT NVL(s.username, '(oracle)') AS username,
       s.osuser,
       s.sid,
       s.serial#,
       p.spid,
       s.lockwait,
       s.status,
       s.service_name,
       s.machine,
       s.program,
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time,
       s.last_call_et AS last_call_et_secs,
       s.module,
       s.action,
       s.client_info,
       s.client_identifier
FROM   v$session s,
       v$process p
WHERE  s.paddr = p.addr
AND    lower(s.osuser) = lower('&1')
ORDER BY s.username, s.osuser;

SET PAGESIZE 14
