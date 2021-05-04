-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/pdb_spfiles.sql
-- Author       : Tim Hall
-- Description  : Displays information from the pdb_spfile$ table.
-- Requirements : Access to pdb_spfile$ and v$pdbs.
-- Call Syntax  : @pdb_spfiles
-- Last Modified: 04/05/2021
-- -----------------------------------------------------------------------------------
set linesize 120
column pdb_name format a10
column name format a30
column value$ format a30

select ps.db_uniq_name,
       ps.pdb_uid,
       p.name as pdb_name,
       ps.name,
       ps.value$
from   pdb_spfile$ ps
       join v$pdbs p on ps.pdb_uid = p.con_uid
order by 1, 2, 3;
