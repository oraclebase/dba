-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/logfiles.sql
-- Author       : Tim Hall
-- Description  : Displays information about redo log files.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @logfiles
-- Last Modified: 21/12/2004
-- -----------------------------------------------------------------------------------

SET LINESIZE 200
COLUMN member FORMAT A50
COLUMN first_change# FORMAT 99999999999999999999
COLUMN next_change# FORMAT 99999999999999999999

SELECT l.thread#,
       lf.group#,
       lf.member,
       TRUNC(l.bytes/1024/1024) AS size_mb,
       l.status,
       l.archived,
       lf.type,
       lf.is_recovery_dest_file AS rdf,
       l.sequence#,
       l.first_change#,
       l.next_change#   
FROM   v$logfile lf
       JOIN v$log l ON l.group# = lf.group#
ORDER BY l.thread#,lf.group#, lf.member;

SET LINESIZE 80
