-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/fks_on_table_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for the foreign keys on the specified table, or all tables.
-- Call Syntax  : @fks_on_table_ddl (schema) (table-name or all)
-- Last Modified: 16/03/2013 - Rewritten to use DBMS_METADATA
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('REF_CONSTRAINT', constraint_name, owner)
FROM   all_constraints
WHERE  owner      = UPPER('&1')
AND    table_name = DECODE(UPPER('&2'), 'ALL', table_name, UPPER('&2'))
AND    constraint_type = 'R';

SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON
