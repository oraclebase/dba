-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/segment_stats.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays statistics for segments in th specified schema.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @segment_stats
-- Last Modified: 20/10/2006
-- -----------------------------------------------------------------------------------
SELECT statistic#,
       name
FROM   v$segstat_name
ORDER BY statistic#;

ACCEPT l_schema char PROMPT 'Enter Schema: '
ACCEPT l_stat  NUMBER PROMPT 'Enter Statistic#: '
SET VERIFY OFF

SELECT object_name,
       object_type,
       value
FROM   v$segment_statistics 
WHERE  owner = UPPER('&l_schema')
AND    statistic# = &l_stat
ORDER BY value;
