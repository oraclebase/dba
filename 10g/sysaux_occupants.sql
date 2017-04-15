-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/sysaux_occupants.sql
-- Author       : Tim Hall
-- Description  : Displays information about the contents of the SYSAUX tablespace.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @sysaux_occupants
-- Last Modified: 27/07/2005
-- -----------------------------------------------------------------------------------
COLUMN occupant_name FORMAT A30
COLUMN schema_name FORMAT A20

SELECT occupant_name,
       schema_name,
       space_usage_kbytes
FROM   v$sysaux_occupants
ORDER BY occupant_name;
