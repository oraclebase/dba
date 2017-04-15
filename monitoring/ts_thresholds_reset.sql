-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/ts_thresholds_reset.sql
-- Author       : Tim Hall
-- Description  : Displays threshold information for tablespaces.
-- Call Syntax  : @ts_thresholds_reset (warning) (critical)
--                @ts_thresholds_reset NULL NULL    -- To reset to defaults
-- Last Modified: 13/02/2014 - Created
-- -----------------------------------------------------------------------------------
SET VERIFY OFF

DECLARE
  g_warning_value      VARCHAR2(4) := '&1';
  g_warning_operator   VARCHAR2(4) := DBMS_SERVER_ALERT.OPERATOR_GE;
  g_critical_value     VARCHAR2(4) := '&2';
  g_critical_operator  VARCHAR2(4) := DBMS_SERVER_ALERT.OPERATOR_GE;

  PROCEDURE set_threshold(p_ts_name  IN VARCHAR2) AS
  BEGIN
    DBMS_SERVER_ALERT.SET_THRESHOLD(
      metrics_id              => DBMS_SERVER_ALERT.TABLESPACE_PCT_FULL,
      warning_operator        => g_warning_operator,
      warning_value           => g_warning_value,
      critical_operator       => g_critical_operator,
      critical_value          => g_critical_value,
      observation_period      => 1,
      consecutive_occurrences => 1,
      instance_name           => NULL,
      object_type             => DBMS_SERVER_ALERT.OBJECT_TYPE_TABLESPACE,
      object_name             => p_ts_name);
  END;
BEGIN
  IF g_warning_value  = 'NULL' THEN
    g_warning_value    := NULL;
    g_warning_operator := NULL;
  END IF;
  IF g_critical_value = 'NULL' THEN
    g_critical_value    := NULL;
    g_critical_operator := NULL;
  END IF;

  FOR cur_ts IN (SELECT tablespace_name
                 FROM   dba_tablespace_thresholds
                 WHERE  warning_operator != 'DO NOT CHECK'
                 AND    extent_management = 'LOCAL')
  LOOP
    set_threshold(cur_ts.tablespace_name);
  END LOOP;
END;
/

SET VERIFY ON