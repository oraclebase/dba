-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/tablespace_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for the specified tablespace, or all tablespaces.
-- Call Syntax  : @tablespace_ddl (tablespace-name or all)
-- Last Modified: 16/03/2013 - Rewritten to use DBMS_METADATA
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('TABLESPACE', tablespace_name)
FROM   dba_tablespaces
WHERE  tablespace_name = DECODE(UPPER('&1'), 'ALL', tablespace_name, UPPER('&1'));

SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON