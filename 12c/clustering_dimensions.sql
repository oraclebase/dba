-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/clustering_dimensions.sql
-- Author       : Tim Hall
-- Description  : Display clustering dimensions in the specified schema, or all schemas.
-- Call Syntax  : @clustering_dimensions (schema or all)
-- Last Modified: 24/12/2020
-- -----------------------------------------------------------------------------------
set linesize 200 verify off trimspool on
column owner form a30
column table_name form a30
column dimension_owner form a30
column dimension_name form a30

select owner,
       table_name,
       dimension_owner,
       dimension_name
from   dba_clustering_dimensions
where  owner = decode(upper('&1'), 'ALL', owner, upper('&1'))
order by owner, table_name;
