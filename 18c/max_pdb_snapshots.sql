-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/18c/max_pdb_snapshots.sql
-- Author       : Tim Hall
-- Description  : Displays the MAX_PDB_SNAPSHOTS setting for each container.
-- Requirements : Access to the CDB views.
-- Call Syntax  : @max_pdb_snapshots
-- Last Modified: 01/01/2019
-- -----------------------------------------------------------------------------------
SET LINESIZE 150 TAB OFF

COLUMN property_name FORMAT A20
COLUMN pdb_name FORMAT A10
COLUMN property_value FORMAT A15
COLUMN description FORMAT A50

SELECT pr.con_id,
       p.pdb_name,
       pr.property_name, 
       pr.property_value,
       pr.description 
FROM   cdb_properties pr
       JOIN cdb_pdbs p ON pr.con_id = p.con_id 
WHERE  pr.property_name = 'MAX_PDB_SNAPSHOTS' 
ORDER BY pr.property_name;
