-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/event_histogram.sql
-- Author       : Tim Hall
-- Description  : Displays histogram of the event waits times.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @event_histogram "(event-name)"
-- Last Modified: 08-NOV-2005
-- -----------------------------------------------------------------------------------

SET VERIFY OFF
COLUMN event FORMAT A30

SELECT event#,
       event,
       wait_time_milli,
       wait_count
FROM   v$event_histogram
WHERE  event LIKE '%&1%'
ORDER BY event, wait_time_milli;

COLUMN FORMAT DEFAULT
SET VERIFY ON