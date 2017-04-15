-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/table_triggers_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for all triggers on the specified table.
-- Call Syntax  : @table_triggers_ddl (schema) (table_name)
-- Last Modified: 16/03/2013 - Rewritten to use DBMS_METADATA
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('TRIGGER', trigger_name, owner)
FROM   all_triggers
WHERE  table_owner = UPPER('&1')
AND    table_name  = UPPER('&2');

SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON