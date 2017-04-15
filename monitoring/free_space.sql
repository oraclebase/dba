-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/free_space.sql
-- Author       : Tim Hall
-- Description  : Displays space usage for each datafile.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @free_space
-- Last Modified: 15-JUL-2000 - Created.
--                12-OCT-2012 - Amended to include auto-extend and maxsize.
-- -----------------------------------------------------------------------------------
SET PAGESIZE 100
SET LINESIZE 265

COLUMN tablespace_name FORMAT A20
COLUMN file_name FORMAT A50

SELECT df.tablespace_name,
       df.file_name,
       df.size_mb,
       f.free_mb,
       df.max_size_mb,
       f.free_mb + (df.max_size_mb - df.size_mb) AS max_free_mb,
       RPAD(' '|| RPAD('X',ROUND((df.max_size_mb-(f.free_mb + (df.max_size_mb - df.size_mb)))/max_size_mb*10,0), 'X'),11,'-') AS used_pct
FROM   (SELECT file_id,
               file_name,
               tablespace_name,
               TRUNC(bytes/1024/1024) AS size_mb,
               TRUNC(GREATEST(bytes,maxbytes)/1024/1024) AS max_size_mb
        FROM   dba_data_files) df,
       (SELECT TRUNC(SUM(bytes)/1024/1024) AS free_mb,
               file_id
        FROM dba_free_space
        GROUP BY file_id) f
WHERE  df.file_id = f.file_id (+)
ORDER BY df.tablespace_name,
         df.file_name;

PROMPT
SET PAGESIZE 14