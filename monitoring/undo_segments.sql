-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/undo_segments.sql
-- Author       : Tim Hall
-- Description  : Displays information about undo segments.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @undo_segments {name | all}
-- Last Modified: 20-APR-2021
-- -----------------------------------------------------------------------------------

set verify off linesize 100
column owner format a30
column segment_name format a30
column segment_type format a20

select owner,
       segment_name,
       segment_type
from   dba_segments
where  segment_type in ('TYPE2 UNDO','ROLLBACK')
and    lower(segment_name) like '%' || decode(lower('&1'), 'all', '', lower('&1')) || '%'
order by 1, 2;