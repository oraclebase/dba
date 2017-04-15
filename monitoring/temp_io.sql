-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/temp_io.sql
-- Author       : Tim Hall
-- Description  : Displays the amount of IO for each tempfile.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @temp_io
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
SET PAGESIZE 1000

SELECT SUBSTR(t.name,1,50) AS file_name,
       f.phyblkrd AS blocks_read,
       f.phyblkwrt AS blocks_written,
       f.phyblkrd + f.phyblkwrt AS total_io
FROM   v$tempstat f,
       v$tempfile t
WHERE  t.file# = f.file#
ORDER BY f.phyblkrd + f.phyblkwrt DESC;

SET PAGESIZE 18