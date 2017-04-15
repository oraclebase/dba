-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/directory_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for specified directory, or all directories.
-- Call Syntax  : @directory_ddl (directory or all)
-- Last Modified: 16/03/2013
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('DIRECTORY', directory_name)
FROM   dba_directories
WHERE  directory_name = DECODE(UPPER('&1'), 'ALL', directory_name, UPPER('&1'));

SET PAGESIZE 14 LINESIZE 1000 FEEDBACK ON VERIFY ON