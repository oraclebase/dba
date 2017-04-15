-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/health.sql
-- Author       : Tim Hall
-- Description  : Lots of information about the database so you can asses the general health of the system.
-- Requirements : Access to the V$ & DBA views and several other monitoring scripts.
-- Call Syntax  : @health (username/password@service)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SPOOL Health_Checks.txt

conn &1
@db_info
@sessions
@ts_full
@max_extents

SPOOL OFF