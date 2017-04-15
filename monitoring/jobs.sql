-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/jobs.sql
-- Author       : Tim Hall
-- Description  : Displays information about all scheduled jobs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @jobs
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 1000 PAGESIZE 1000

COLUMN log_user FORMAT A15
COLUMN priv_user FORMAT A15
COLUMN schema_user FORMAT A15
COLUMN interval FORMAT A40
COLUMN what FORMAT A50
COLUMN nls_env FORMAT A50
COLUMN misc_env FORMAT A50

SELECT a.job,            
       a.log_user,       
       a.priv_user,     
       a.schema_user,    
       To_Char(a.last_date,'DD-MON-YYYY HH24:MI:SS') AS last_date,      
       --To_Char(a.this_date,'DD-MON-YYYY HH24:MI:SS') AS this_date,      
       To_Char(a.next_date,'DD-MON-YYYY HH24:MI:SS') AS next_date,      
       a.broken,         
       a.interval,       
       a.failures,       
       a.what,
       a.total_time,     
       a.nls_env,        
       a.misc_env          
FROM   dba_jobs a;

SET LINESIZE 80 PAGESIZE 14