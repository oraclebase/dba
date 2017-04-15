-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/system_fix.sql
-- Author       : Tim Hall
-- Description  : Provides information about system fixes for the specified phrase and version.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @system_fix (phrase | all) (version | all)
-- Last Modified: 30/11/2011
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300

COLUMN sql_feature FORMAT A35
COLUMN optimizer_feature_enable FORMAT A9

SELECT *
FROM   v$system_fix_control
WHERE  LOWER(description) LIKE DECODE('&1', 'all', '%', '%&1%')
AND    optimizer_feature_enable = DECODE('&2', 'all', optimizer_feature_enable, '&2');