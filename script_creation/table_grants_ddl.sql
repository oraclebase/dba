-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/table_grants_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for all grants on the specified table.
-- Call Syntax  : @table_grants_ddl (schema) (table_name)
-- Last Modified: 16/03/2013 - Rewritten to use DBMS_METADATA
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT dbms_metadata.get_dependent_ddl('OBJECT_GRANT', UPPER('&2'), UPPER('&1')) from dual;

SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON