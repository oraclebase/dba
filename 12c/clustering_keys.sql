-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/clustering_keys.sql
-- Author       : Tim Hall
-- Description  : Display clustering keys in the specified schema, or all schemas.
-- Call Syntax  : @clustering_keys (schema or all)
-- Last Modified: 24/12/2020
-- -----------------------------------------------------------------------------------
set linesize 200 verify off trimspool on
column owner format a30
column table_name format a30
column detail_owner format a30
column detail_name format a30
column detail_column format a30

select owner,
       table_name,
       detail_owner,
       detail_name,
       detail_column,
       position,
       groupid
from   dba_clustering_keys
where  owner = decode(upper('&1'), 'ALL', owner, upper('&1'))
order by owner, table_name;
