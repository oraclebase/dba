-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/flashback_db_info.sql
-- Author       : Tim Hall
-- Description  : Displays information relevant to flashback database.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @flashback_db_info
-- Last Modified: 21/12/2004
-- -----------------------------------------------------------------------------------
PROMPT Flashback Status
PROMPT ================
select flashback_on from v$database;

PROMPT Flashback Parameters
PROMPT ====================

column name format A30
column value format A50
select name, value
from   v$parameter
where  name in ('db_flashback_retention_target', 'db_recovery_file_dest','db_recovery_file_dest_size')
order by name;

PROMPT Flashback Restore Points
PROMPT ========================

select * from v$restore_point;

PROMPT Flashback Logs
PROMPT ==============

select * from v$flashback_database_log;
