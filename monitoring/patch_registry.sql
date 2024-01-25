-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/patch_registry.sql
-- Author       : Tim Hall
-- Description  : Lists all patches applied.
-- Call Syntax  : @patch_registry
-- Requirements : Access to the DBA views.
-- Last Modified: 25/01/2024
-- -----------------------------------------------------------------------------------

set linesize 150
column status format a10
column action_time format a30

select install_id,
       patch_id,
       patch_uid,
       patch_type,
       action,
       status,
       target_version,
       action_time
from   dba_registry_sqlpatch
order by 1;
