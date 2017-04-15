-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/sequence_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for the specified sequence, or all sequences.
-- Call Syntax  : @sequence_ddl (schema-name) (sequence-name or all)
-- Last Modified: 16/03/2013 - Rewritten to use DBMS_METADATA
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('SEQUENCE', sequence_name, sequence_owner)
FROM   all_sequences
WHERE  sequence_owner = UPPER('&1')
AND    sequence_name  = DECODE(UPPER('&2'), 'ALL', sequence_name, UPPER('&2'));

SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON