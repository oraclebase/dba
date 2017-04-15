-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/fks_ref_table_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for the foreign keys that reference the specified table.
-- Call Syntax  : @fks_ref_table_ddl (schema) (table-name)
-- Last Modified: 16/03/2013 - Rewritten to use DBMS_METADATA
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('REF_CONSTRAINT', ac1.constraint_name, ac1.owner)
FROM   all_constraints ac1
       JOIN all_constraints ac2 ON ac1.r_owner = ac2.owner AND ac1.r_constraint_name = ac2.constraint_name
WHERE  ac2.owner      = UPPER('&1')
AND    ac2.table_name = UPPER('&2')
AND    ac2.constraint_type IN ('P','U')
AND    ac1.constraint_type = 'R';

SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON