-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/statistics_global_prefs.sql
-- Author       : Tim Hall
-- Description  : Displays the top-level global statistics preferences.
-- Requirements : Access to the DBMS_STATS package.
-- Call Syntax  : @statistics_global_prefs
-- Last Modified: 13-DEC-2016
-- -----------------------------------------------------------------------------------

SET SERVEROUTPUT ON
DECLARE
  PROCEDURE display(p_param IN VARCHAR2) AS
    l_result VARCHAR2(50);
  BEGIN
    l_result := DBMS_STATS.get_prefs (pname => p_param);
    DBMS_OUTPUT.put_line(RPAD(p_param, 30, ' ') || ' : ' || l_result);
  END;
BEGIN
  display('AUTOSTATS_TARGET');
  display('CASCADE');
  display('DEGREE');
  display('ESTIMATE_PERCENT');
  display('METHOD_OPT');
  display('NO_INVALIDATE');
  display('GRANULARITY');
  display('PUBLISH');
  display('INCREMENTAL');
  display('STALE_PERCENT');
END;
/
