-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/dynamic_memory.sql
-- Author       : Tim Hall
-- Description  : Displays the values of the dynamically memory pools.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @dynamic_memory
-- Last Modified: 08-NOV-2004
-- -----------------------------------------------------------------------------------

COLUMN name  FORMAT A40
COLUMN value FORMAT A40

SELECT name,
       value
FROM   v$parameter
WHERE  SUBSTR(name, 1, 1) = '_'
ORDER BY name;

COLUMN FORMAT DEFAULT
