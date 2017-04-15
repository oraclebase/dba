-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/temp_segments.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all temporary segments.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @temp_segments
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500

SELECT owner,
       Trunc(Sum(bytes)/1024) Kb
FROM   dba_segments 
WHERE  segment_type = 'TEMPORARY'
GROUP BY owner;
