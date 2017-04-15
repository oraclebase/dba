-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/session_fix.sql
-- Author       : Tim Hall
-- Description  : Provides information about session fixes for the specified phrase and version.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @session_fix (session_id | all) (phrase | all) (version | all)
-- Last Modified: 30/11/2011
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300

COLUMN sql_feature FORMAT A35
COLUMN optimizer_feature_enable FORMAT A9

SELECT *
FROM   v$session_fix_control
WHERE  session_id = DECODE('&1', 'all', session_id, '&1')
AND    LOWER(description) LIKE DECODE('&2', 'all', '%', '%&2%')
AND    optimizer_feature_enable = DECODE('&3', 'all', optimizer_feature_enable, '&3');