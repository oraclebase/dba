-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/parameters_non_default.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all the non-default parameters.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @parameters_non_default
-- Last Modified: 11-JAN-2017
-- -----------------------------------------------------------------------------------
SET LINESIZE 150

COLUMN name FORMAT A50
COLUMN value FORMAT A50

SELECT name,
       value
FROM   v$parameter
WHERE  isdefault = 'FALSE';
