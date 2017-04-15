-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/parameter_diffs.sql
-- Author       : Tim Hall
-- Description  : Displays parameter values that differ between the current value and the spfile.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @parameter_diffs
-- Last Modified: 08-NOV-2004
-- -----------------------------------------------------------------------------------

SET LINESIZE 120
COLUMN name          FORMAT A30
COLUMN current_value FORMAT A30
COLUMN sid           FORMAT A8
COLUMN spfile_value  FORMAT A30

SELECT p.name,
       i.instance_name AS sid,
       p.value AS current_value,
       sp.sid,
       sp.value AS spfile_value      
FROM   v$spparameter sp,
       v$parameter p,
       v$instance i
WHERE  sp.name   = p.name
AND    sp.value != p.value;

COLUMN FORMAT DEFAULT
