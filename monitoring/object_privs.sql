-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/object_privs.sql
-- Author       : Tim Hall
-- Description  : Displays object privileges on a specified object.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @object_privs (owner) (object-name)
-- Last Modified: 27/07/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200 VERIFY OFF

COLUMN owner FORMAT A30
COLUMN object_name FORMAT A30
COLUMN grantor FORMAT A30
COLUMN grantee FORMAT A30

SELECT owner,
       table_name AS object_name,
       grantor,
       grantee,
       privilege,
       grantable,
       hierarchy
FROM   dba_tab_privs
WHERE  owner      = UPPER('&1')
AND    table_name = UPPER('&2')
ORDER BY 1,2,3,4;

SET VERIFY ON