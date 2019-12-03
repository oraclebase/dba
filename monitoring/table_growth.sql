-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/table_growth.sql
-- Author       : Tim Hall
-- Description  : Displays information on all active database sessions.
-- Requirements : Access to the DBA_HIST views. Diagnostics and Tuning license.
-- Call Syntax  : @table_growth (schema-name) (table_name)
-- Last Modified: 03-DEC-2019
-- -----------------------------------------------------------------------------------
COLUMN object_name FORMAT A30
 
SELECT TO_CHAR(sn.begin_interval_time,'DD-MON-YYYY HH24:MM') AS begin_interval_time,
       sso.object_name,
       ss.space_used_total
FROM   dba_hist_seg_stat ss,
       dba_hist_seg_stat_obj sso,
       dba_hist_snapshot sn
WHERE  sso.owner = UPPER('&1')
AND    sso.obj# = ss.obj#
AND    sn.snap_id = ss.snap_id
AND    sso.object_name LIKE UPPER('&2') || '%'
ORDER BY sn.begin_interval_time;
