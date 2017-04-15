-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/view_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for the specified view.
-- Call Syntax  : @view_ddl (schema-name) (view-name)
-- Last Modified: 16/03/2013 - Rewritten to use DBMS_METADATA
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('VIEW', view_name, owner)
FROM   all_views
WHERE  owner      = UPPER('&1')
AND    view_name = DECODE(UPPER('&2'), 'ALL', view_name, UPPER('&2'));

SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON