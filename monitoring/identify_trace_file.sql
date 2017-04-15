-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/identify_trace_file.sql
-- Author       : Tim Hall
-- Description  : Displays the name of the trace file associated with the current session.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @identify_trace_file
-- Last Modified: 17-AUG-2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 100
COLUMN trace_file FORMAT A60

SELECT s.sid,
       s.serial#,
       pa.value || '/' || LOWER(SYS_CONTEXT('userenv','instance_name')) ||    
       '_ora_' || p.spid || '.trc' AS trace_file
FROM   v$session s,
       v$process p,
       v$parameter pa
WHERE  pa.name = 'user_dump_dest'
AND    s.paddr = p.addr
AND    s.audsid = SYS_CONTEXT('USERENV', 'SESSIONID');