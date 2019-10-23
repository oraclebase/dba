-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/ts_thresholds.sql
-- Author       : Tim Hall
-- Description  : Displays threshold information for tablespaces.
-- Call Syntax  : @ts_thresholds
-- Last Modified: 13/02/2014 - Created
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

COLUMN metrics_name FORMAT A30
COLUMN warning_value FORMAT A30
COLUMN critical_value FORMAT A15

SELECT tablespace_name,
       contents,
       extent_management,
       threshold_type,
       metrics_name,
       warning_operator,
       warning_value,
       critical_operator,
       critical_value
FROM   dba_tablespace_thresholds
ORDER BY tablespace_name, metrics_name;

SET LINESIZE 80
