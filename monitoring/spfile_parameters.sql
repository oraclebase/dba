-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/spfile_parameters.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all the spfile parameters.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @spfile_parameters
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500

COLUMN name  FORMAT A30
COLUMN value FORMAT A60
COLUMN displayvalue FORMAT A60

SELECT sp.sid,
       sp.name,
       sp.value,
       sp.display_value
FROM   v$spparameter sp
ORDER BY sp.name, sp.sid;
