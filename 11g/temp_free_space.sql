-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/temp_free_space.sql
-- Author       : Tim Hall
-- Description  : Displays information about temporary tablespace usage.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @temp_free_space
-- Last Modified: 23-AUG-2008
-- -----------------------------------------------------------------------------------
SELECT *
FROM   dba_temp_free_space;