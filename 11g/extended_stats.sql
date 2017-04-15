-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/extended_stats.sql
-- Author       : Tim Hall
-- Description  : Provides information about extended statistics.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @extended_stats
-- Last Modified: 30/11/2011
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
COLUMN owner FORMAT A20
COLUMN extension_name FORMAT A15
COLUMN extension FORMAT A50

SELECT owner, table_name, extension_name, extension
FROM   dba_stat_extensions
ORDER by owner, table_name;