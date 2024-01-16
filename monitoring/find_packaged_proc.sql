-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/find_packaged_proc.sql
-- Author       : Tim Hall
-- Description  : Displays tablespaces the user has quotas on.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @find_packaged_proc {procedure_name}
-- Last Modified: 16-JAN-2024
-- -----------------------------------------------------------------------------------

set verify off
column owner format a30
column object_name format a30
column procedure_name format a30

select owner, object_name, procedure_name
from   dba_procedures
where  object_type = 'PACKAGE'
and    procedure_name like '%' || upper('&1') || '%';
