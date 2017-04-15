-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/sga_dynamic_free_memory.sql
-- Author       : Tim Hall
-- Description  : Provides information about free memory in the SGA.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @sga_dynamic_free_memory
-- Last Modified: 23/08/2008
-- -----------------------------------------------------------------------------------

SELECT *
FROM   v$sga_dynamic_free_memory;
