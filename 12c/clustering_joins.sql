-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/clustering_joins.sql
-- Author       : Tim Hall
-- Description  : Display clustering joins in the specified schema, or all schemas.
-- Call Syntax  : @clustering_joins (schema or all)
-- Last Modified: 24/12/2020
-- -----------------------------------------------------------------------------------
set linesize 260 verify off trimspool on
column owner format a30
column table_name form a30
column tab1_owner form a30
column tab1_name form a30
column tab1_column form a30
column tab2_owner form a30
column tab2_name form a30
column tab2_column form a31

select owner,
       table_name,
       tab1_owner,
       tab1_name,
       tab1_column,
       tab2_owner,
       tab2_name,
       tab2_column
from   dba_clustering_joins
where  owner = decode(upper('&1'), 'ALL', owner, upper('&1'))
order by owner, table_name;
