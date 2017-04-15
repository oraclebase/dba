-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/recyclebin.sql
-- Author       : Tim Hall
-- Description  : Displays the contents of the recyclebin.
-- Requirements : Access to the DBA views. Depending on DB version, different columns
--                are available.
-- Call Syntax  : @recyclebin (owner | all)
-- Last Modified: 15/07/2010
-- -----------------------------------------------------------------------------------
SET LINESIZE 500 VERIFY OFF

SELECT owner,
       original_name,
       object_name,
       operation,
       type,
       space AS space_blks,
       ROUND((space*8)/1024,2) space_mb
FROM   dba_recyclebin
WHERE  owner = DECODE(UPPER('&1'), 'ALL', owner, UPPER('&1'))
ORDER BY 1, 2;

SET VERIFY ON