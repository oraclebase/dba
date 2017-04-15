-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/system_parameters.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all the system parameters.
--                Comment out isinstance_modifiable for use prior to 10g.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @system_parameters
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500

COLUMN name  FORMAT A30
COLUMN value FORMAT A60

SELECT sp.name,
       sp.type,
       sp.value,
       sp.isses_modifiable,
       sp.issys_modifiable,
       sp.isinstance_modifiable
FROM   v$system_parameter sp
ORDER BY sp.name;

