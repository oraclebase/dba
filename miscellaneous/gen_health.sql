-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/gen_health.sql
-- Author       : Tim Hall
-- Description  : Miscellaneous queries to check the general health of the system.
-- Call Syntax  : @gen_health
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SELECT file_id, 
       tablespace_name, 
       file_name, 
       status 
FROM   sys.dba_data_files; 

SELECT file#, 
       name, 
       status, 
       enabled 
FROM   v$datafile;

SELECT * 
FROM   v$backup;

SELECT * 
FROM   v$recovery_status;

SELECT * 
FROM   v$recover_file;

SELECT * 
FROM   v$recovery_file_status;

SELECT * 
FROM   v$recovery_log;

SELECT username, 
       command, 
       status, 
       module 
FROM   v$session;

