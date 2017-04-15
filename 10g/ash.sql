-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/ash.sql
-- Author       : Tim Hall
-- Description  : Displays the minutes spent on each event for the specified time.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @active_session_waits (mins)
-- Last Modified: 21/12/2004
-- -----------------------------------------------------------------------------------

SET VERIFY OFF

SELECT NVL(a.event, 'ON CPU') AS event,
       COUNT(*) AS total_wait_time
FROM   v$active_session_history a
WHERE  a.sample_time > SYSDATE - &1/(24*60)
GROUP BY a.event
ORDER BY total_wait_time DESC;

SET VERIFY ON