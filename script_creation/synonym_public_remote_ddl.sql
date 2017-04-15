-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/synonym_public_remote_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for public synonyms to remote objects.
-- Call Syntax  : @synonym_remote_ddl
-- Last Modified: 08/07/2013 - Rewritten to use DBMS_METADATA
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('SYNONYM', synonym_name, owner)
FROM   dba_synonyms
WHERE  owner = 'PUBLIC'
AND    db_link IS NOT NULL;

SET PAGESIZE 14 FEEDBACK ON VERIFY ON