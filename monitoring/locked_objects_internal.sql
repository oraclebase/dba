-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/locked_objects_internal.sql
-- Author       : Tim Hall
-- Description  : Lists all locks on the specific object.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @locked_objects_internal (object-name)
-- Last Modified: 16/02/2018
-- -----------------------------------------------------------------------------------
SET LINESIZE 1000 VERIFY OFF

COLUMN lock_type FORMAT A20
COLUMN mode_held FORMAT A10
COLUMN mode_requested FORMAT A10
COLUMN lock_id1 FORMAT A50
COLUMN lock_id2 FORMAT A30

SELECT li.session_id AS sid,
       s.serial#,
       li.lock_type,
       li.mode_held,
       li.mode_requested,
       li.lock_id1,
       li.lock_id2
FROM   dba_lock_internal li
       JOIN v$session s ON li.session_id = s.sid
WHERE  UPPER(lock_id1) LIKE UPPER('%&1%');

SET VERIFY ON