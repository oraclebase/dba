-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/parameters.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all the parameters.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @parameters
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500

COLUMN name  FORMAT A30
COLUMN value FORMAT A60

SELECT p.name,
       p.type,
       p.value,
       p.isses_modifiable,
       p.issys_modifiable,
       p.isinstance_modifiable
FROM   v$parameter p
ORDER BY p.name;

