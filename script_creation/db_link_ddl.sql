-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/db_link_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for DB links for the specific schema, or all schemas.
-- Call Syntax  : @db_link_ddl (schema or all)
-- Last Modified: 16/03/2013
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('DB_LINK', db_link, owner)
FROM   dba_db_links
WHERE  owner = DECODE(UPPER('&1'), 'ALL', owner, UPPER('&1'));

SET PAGESIZE 14 LINESIZE 1000 FEEDBACK ON VERIFY ON