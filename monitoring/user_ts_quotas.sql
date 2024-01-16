-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/user_ts_quotas.sql
-- Author       : Tim Hall
-- Description  : Displays tablespaces the user has quotas on.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @user_ts_quotas {username}
-- Last Modified: 16-JAN-2024
-- -----------------------------------------------------------------------------------

set verify off
column tablespace_name format a30

select tablespace_name, blocks, max_blocks
from   dba_ts_quotas
where  username = decode(upper('&1'), 'all', username, upper('&1'))
order by 1;
