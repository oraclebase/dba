-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/system_events.sql
-- Author       : Tim Hall
-- Description  : Displays information on all system events.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @system_events
-- Last Modified: 21-FEB-2005
-- -----------------------------------------------------------------------------------
SELECT event,
       total_waits,
       total_timeouts,
       time_waited,
       average_wait,
       time_waited_micro
FROM v$system_event
ORDER BY event;
