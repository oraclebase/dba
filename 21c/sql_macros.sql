-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/21c/sql_macros.sql
-- Author       : Tim Hall
-- Description  : Displays information about SQL macros for the specific schema, or all schemas.
-- Call Syntax  : @sql_macros (schema or all)
-- Last Modified: 27/12/2020
-- -----------------------------------------------------------------------------------
set linesize 150 verify off trimspool on
column owner format a30
column object_name format a30
column procedure_name format a30
column sql_macro format a9

select p.owner,
       o.object_type,
       p.sql_macro,
       p.object_name,
       p.procedure_name
from   dba_procedures p
       join dba_objects  o on p.object_id = o.object_id
where  p.sql_macro != 'NULL'
and    p.owner = decode(upper('&1'), 'ALL', p.owner, upper('&1'))
order by p.owner, o.object_type, p.sql_macro, p.object_name, p.procedure_name;
