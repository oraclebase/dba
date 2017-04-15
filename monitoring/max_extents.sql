-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/max_extents.sql
-- Author       : Tim Hall
-- Description  : Displays all tables and indexes nearing their MAX_EXTENTS setting.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @max_extents
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF

PROMPT
PROMPT Tables and Indexes nearing MAX_EXTENTS
PROMPT **************************************
SELECT e.owner,
       e.segment_type,
       Substr(e.segment_name, 1, 30) segment_name,
       Trunc(s.initial_extent/1024) "INITIAL K",
       Trunc(s.next_extent/1024) "NEXT K",
       s.max_extents,
       Count(*) as extents
FROM   dba_extents e,
       dba_segments s
WHERE  e.owner        = s.owner
AND    e.segment_name = s.segment_name
AND    e.owner        NOT IN ('SYS', 'SYSTEM')
GROUP BY e.owner, e.segment_type, e.segment_name, s.initial_extent, s.next_extent, s.max_extents
HAVING Count(*) > s.max_extents - 10
ORDER BY e.owner, e.segment_type, Count(*) DESC;
