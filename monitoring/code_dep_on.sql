-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/code_dep_on.sql
-- Author       : Tim Hall
-- Description  : Displays all objects dependant on the specified object.
-- Call Syntax  : @code_dep_on (schema-name or all) (object-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 255
SET PAGESIZE 1000
BREAK ON type SKIP 1

COLUMN owner FORMAT A20

SELECT a.type,
       a.owner,
       a.name
FROM   all_dependencies a
WHERE  a.referenced_owner = DECODE(UPPER('&1'), 'ALL', a.referenced_owner, UPPER('&1'))
AND    a.referenced_name  = UPPER('&2')
ORDER BY 1,2,3;

SET PAGESIZE 22
SET VERIFY ON