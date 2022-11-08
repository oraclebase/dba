-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/statistics_global_prefs.sql
-- Author       : Tim Hall
-- Description  : Displays the top-level global statistics preferences.
-- Requirements : Access to the DBMS_STATS package.
-- Call Syntax  : @statistics_global_prefs
-- Last Modified: 08-NOV-2022
-- -----------------------------------------------------------------------------------

SET SERVEROUTPUT ON
DECLARE
  PROCEDURE display(p_param IN VARCHAR2) AS
    l_result VARCHAR2(32767);
  BEGIN
    l_result := DBMS_STATS.get_prefs (pname => p_param);
    DBMS_OUTPUT.put_line(RPAD(p_param, 30, ' ') || ' : ' || l_result);
  END;
BEGIN
  display('APPROXIMATE_NDV_ALGORITHM');
  display('AUTO_STAT_EXTENSIONS');
  display('AUTO_TASK_STATUS');
  display('AUTO_TASK_MAX_RUN_TIME');
  display('AUTO_TASK_INTERVAL');
  display('CASCADE');
  display('CONCURRENT');
  display('DEGREE');
  display('ESTIMATE_PERCENT');
  display('GLOBAL_TEMP_TABLE_STATS');
  display('GRANULARITY');
  display('INCREMENTAL');
  display('INCREMENTAL_STALENESS');
  display('INCREMENTAL_LEVEL');
  display('METHOD_OPT');
  display('NO_INVALIDATE');
  display('OPTIONS');
  display('PREFERENCE_OVERRIDES_PARAMETER');
  display('PUBLISH');
  display('STALE_PERCENT');
  display('STAT_CATEGORY');
  display('TABLE_CACHED_BLOCKS');
  display('WAIT_TIME_TO_UPDATE_STATS');
END;
/

