-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/obj_lock.sql
-- Author       : Tim Hall
-- Description  : Displays a list of locked objects.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @obj_lock
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SELECT a.type,
       Substr(a.owner,1,30) owner,
       a.sid,
       Substr(a.object,1,30) object
FROM   v$access a
WHERE  a.owner NOT IN ('SYS','PUBLIC')
ORDER BY 1,2,3,4
/
