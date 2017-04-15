-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/system_stats.sql
-- Author       : Tim Hall
-- Description  : Displays system statistics.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @system_stats (statistic-name or all)
-- Last Modified: 03-NOV-2004
-- -----------------------------------------------------------------------------------
SET VERIFY OFF

COLUMN name FORMAT A50
COLUMN value FORMAT 99999999999999999999

SELECT sn.name, ss.value
FROM   v$sysstat ss,
       v$statname sn
WHERE  ss.statistic# = sn.statistic#
AND    sn.name LIKE '%' || DECODE(LOWER('&1'), 'all', '', LOWER('&1')) || '%';
