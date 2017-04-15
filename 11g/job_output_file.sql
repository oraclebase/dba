-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/job_output_file.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays scheduler job information for previous runs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @job_output_file (job-name) (credential-name)
-- Last Modified: 06/06/2014
-- -----------------------------------------------------------------------------------

SET VERIFY OFF

SET SERVEROUTPUT ON
DECLARE
  l_clob             CLOB;
  l_additional_info  VARCHAR2(4000);
  l_external_log_id  VARCHAR2(50);
BEGIN
  SELECT additional_info, external_log_id
  INTO   l_additional_info, l_external_log_id
  FROM   (SELECT log_id, 
                 additional_info,
                 REGEXP_SUBSTR(additional_info,'job[_0-9]*') AS external_log_id
          FROM   dba_scheduler_job_run_details
          WHERE  job_name = UPPER('&1')
          ORDER BY log_id DESC)
  WHERE  ROWNUM = 1;

  DBMS_OUTPUT.put_line('ADDITIONAL_INFO: ' || l_additional_info);
  DBMS_OUTPUT.put_line('EXTERNAL_LOG_ID: ' || l_external_log_id);

  DBMS_LOB.createtemporary(l_clob, FALSE);

  DBMS_SCHEDULER.get_file(
    source_file     => l_external_log_id ||'_stdout',
    credential_name => UPPER('&2'),
    file_contents   => l_clob,
    source_host     => NULL);

  DBMS_OUTPUT.put_line('stdout:');
  DBMS_OUTPUT.put_line(l_clob);
END;
/
