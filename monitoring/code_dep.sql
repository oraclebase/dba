-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/code_dep.sql
-- Author       : Tim Hall
-- Description  : Displays all dependencies of specified object.
-- Call Syntax  : @code_dep (schema-name or all) (object-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 255
SET PAGESIZE 1000
BREAK ON referenced_type SKIP 1

COLUMN referenced_type FORMAT A20
COLUMN referenced_owner FORMAT A20
COLUMN referenced_name FORMAT A40
COLUMN referenced_link_name FORMAT A20

SELECT a.referenced_type,
       a.referenced_owner,
       a.referenced_name,
       a.referenced_link_name
FROM   all_dependencies a
WHERE  a.owner = DECODE(UPPER('&1'), 'ALL', a.referenced_owner, UPPER('&1'))
AND    a.name  = UPPER('&2')
ORDER BY 1,2,3;

SET VERIFY ON
SET PAGESIZE 22