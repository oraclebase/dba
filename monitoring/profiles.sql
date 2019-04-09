-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/profiles.sql
-- Author       : Tim Hall
-- Description  : Displays the specified profile(s).
-- Call Syntax  : @profiles (profile | part of profile | all)
-- Last Modified: 28/01/2006
-- -----------------------------------------------------------------------------------

SET LINESIZE 150 PAGESIZE 20 VERIFY OFF

BREAK ON profile SKIP 1

COLUMN profile FORMAT A35
COLUMN resource_name FORMAT A40
COLUMN limit FORMAT A15

SELECT profile,
       resource_type,
       resource_name,
       limit
FROM   dba_profiles
WHERE  profile LIKE (DECODE(UPPER('&1'), 'ALL', '%', UPPER('%&1%')))
ORDER BY profile, resource_type, resource_name;

CLEAR BREAKS
SET LINESIZE 80 PAGESIZE 14 VERIFY ON
