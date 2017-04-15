-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/param_valid_values.sql
-- Author       : Tim Hall
-- Description  : Lists all valid values for the specified parameter.
-- Call Syntax  : @param_valid_values (parameter-name)
-- Requirements : Access to the v$views.
-- Last Modified: 14/05/2013
-- -----------------------------------------------------------------------------------
SET VERIFY OFF

COLUMN value FORMAT A50
COLUMN isdefault FORMAT A10

SELECT value,
       isdefault
FROM   v$parameter_valid_values
WHERE  name = '&1';
