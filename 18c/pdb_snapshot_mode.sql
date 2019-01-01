-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/18c/pdb_snapshot_mode.sql
-- Author       : Tim Hall
-- Description  : Displays the SNAPSHOT_MODE and SNAPSHOT_INTERVAL setting for each container.
-- Requirements : Access to the CDB views.
-- Call Syntax  : @pdb_snapshot_mode
-- Last Modified: 01/01/2019
-- -----------------------------------------------------------------------------------
SET LINESIZE 150 TAB OFF

COLUMN pdb_name FORMAT A10
COLUMN snapshot_mode FORMAT A15

SELECT p.con_id,
       p.pdb_name,
       p.snapshot_mode,
       p.snapshot_interval
FROM   cdb_pdbs p
ORDER BY 1;
