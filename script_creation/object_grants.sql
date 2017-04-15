-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/object_grants.sql
-- Author       : Tim Hall
-- Description  : Displays the DDL for all grants on a specific object.
-- Call Syntax  : @object_grants (owner) (object_name)
-- Last Modified: 28/01/2006
-- -----------------------------------------------------------------------------------

set long 1000000 linesize 1000 pagesize 0 feedback off trimspool on verify off
column ddl format a1000

begin
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', true);
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);
end;
/
 
select dbms_metadata.get_dependent_ddl('OBJECT_GRANT', UPPER('&2'), UPPER('&1')) AS ddl
from   dual;

set linesize 80 pagesize 14 feedback on trimspool on verify on
