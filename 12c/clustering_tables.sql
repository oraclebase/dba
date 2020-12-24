-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/clustering_tables.sql
-- Author       : Tim Hall
-- Description  : Display clustering tables in the specified schema, or all schemas.
-- Call Syntax  : @clustering_tables (schema or all)
-- Last Modified: 24/12/2020
-- -----------------------------------------------------------------------------------
set linesize 200 verify off trimspool on
column owner format a30
column table_name format a30
column clustering_type format a25
column on_load format a7
column on_datamovement format a15
column valid format a5
column with_zonemap format a12
column last_load_clst format a30
column last_datamove_clst format a30

select owner,
       table_name,
       clustering_type,
       on_load,
       on_datamovement,
       valid,
       with_zonemap,
       last_load_clst,
       last_datamove_clst
from   dba_clustering_tables
where  owner = decode(upper('&1'), 'ALL', owner, upper('&1'))
order by owner, table_name;
