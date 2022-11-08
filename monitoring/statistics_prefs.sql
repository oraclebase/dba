-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/statistics_prefs.sql
-- Author       : Tim Hall
-- Description  : Displays current statistics preferences.
-- Requirements : Access to the DBMS_STATS package.
-- Call Syntax  : @statistics_prefs
-- Last Modified: 08-NOV-2022
-- -----------------------------------------------------------------------------------

SET LINESIZE 450

COLUMN approximate_ndv_algorithm FORMAT A25
COLUMN auto_stat_extensions FORMAT A20
COLUMN auto_task_status FORMAT A16
COLUMN auto_task_max_run_time FORMAT A22
COLUMN auto_task_interval FORMAT A18
COLUMN cascade FORMAT A23
COLUMN concurrent FORMAT A10
COLUMN degree FORMAT A6
COLUMN estimate_percent FORMAT A27
COLUMN global_temp_table_stats FORMAT A23
COLUMN granularity FORMAT A11
COLUMN incremental FORMAT A11
COLUMN incremental_staleness FORMAT A21
COLUMN incremental_level FORMAT A17
COLUMN method_opt FORMAT A25
COLUMN no_invalidate FORMAT A26
COLUMN options FORMAT A7
COLUMN preference_overrides_parameter FORMAT A30
COLUMN publish FORMAT A7
COLUMN options FORMAT A7
COLUMN stale_percent FORMAT A13
COLUMN stat_category FORMAT A28
COLUMN table_cached_blocks FORMAT A19
COLUMN wait_time_to_update_stats FORMAT A19

SELECT DBMS_STATS.GET_PREFS('APPROXIMATE_NDV_ALGORITHM') AS approximate_ndv_algorithm,
       DBMS_STATS.GET_PREFS('AUTO_STAT_EXTENSIONS') AS auto_stat_extensions,
       DBMS_STATS.GET_PREFS('AUTO_TASK_STATUS') AS auto_task_status,
       DBMS_STATS.GET_PREFS('AUTO_TASK_MAX_RUN_TIME') AS auto_task_max_run_time,
       DBMS_STATS.GET_PREFS('AUTO_TASK_INTERVAL') AS auto_task_interval,
       DBMS_STATS.GET_PREFS('CASCADE') AS cascade,
       DBMS_STATS.GET_PREFS('CONCURRENT') AS concurrent,
       DBMS_STATS.GET_PREFS('DEGREE') AS degree,
       DBMS_STATS.GET_PREFS('ESTIMATE_PERCENT') AS estimate_percent,
       DBMS_STATS.GET_PREFS('GLOBAL_TEMP_TABLE_STATS') AS global_temp_table_stats,
       DBMS_STATS.GET_PREFS('GRANULARITY') AS granularity,
       DBMS_STATS.GET_PREFS('INCREMENTAL') AS incremental,
       DBMS_STATS.GET_PREFS('INCREMENTAL_STALENESS') AS incremental_staleness,
       DBMS_STATS.GET_PREFS('INCREMENTAL_LEVEL') AS incremental_level,
       DBMS_STATS.GET_PREFS('METHOD_OPT') AS method_opt,
       DBMS_STATS.GET_PREFS('NO_INVALIDATE') AS no_invalidate,
       DBMS_STATS.GET_PREFS('OPTIONS') AS options,
       DBMS_STATS.GET_PREFS('PREFERENCE_OVERRIDES_PARAMETER') AS preference_overrides_parameter,
       DBMS_STATS.GET_PREFS('PUBLISH') AS publish,
       DBMS_STATS.GET_PREFS('STALE_PERCENT') AS stale_percent,
       DBMS_STATS.GET_PREFS('STAT_CATEGORY') AS stat_category,
       DBMS_STATS.GET_PREFS('TABLE_CACHED_BLOCKS') AS table_cached_blocks,
       DBMS_STATS.GET_PREFS('WAIT_TIME_TO_UPDATE_STATS') AS wait_time_to_update_stats
FROM   dual;