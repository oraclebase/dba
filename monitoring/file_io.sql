-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/file_io.sql
-- Author       : Tim Hall
-- Description  : Displays the amount of IO for each datafile.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @file_io
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
SET PAGESIZE 1000

SELECT Substr(d.name,1,50) "File Name",
       f.phyblkrd "Blocks Read",
       f.phyblkwrt "Blocks Writen",
       f.phyblkrd + f.phyblkwrt "Total I/O"
FROM   v$filestat f,
       v$datafile d
WHERE  d.file# = f.file#
ORDER BY f.phyblkrd + f.phyblkwrt DESC;

SET PAGESIZE 18