-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/plugin_violations.sql
-- Author       : Tim Hall
-- Description  : Displays information about recent PDB plugin violations.
-- Requirements : 
-- Call Syntax  : @plugin_violations
-- Last Modified: 09-JAN-2017
-- -----------------------------------------------------------------------------------

SET LINESIZE 200

COLUMN time FORMAT A30
COLUMN name FORMAT A30
COLUMN cause FORMAT A30
COLUMN message FORMAT A30

SELECT time, name, cause, message
FROM   pdb_plug_in_violations
WHERE  time > TRUNC(SYSTIMESTAMP)
ORDER BY time;