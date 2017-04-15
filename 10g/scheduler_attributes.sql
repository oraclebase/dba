-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/scheduler_attributes.sql
-- Author       : Tim Hall
-- Description  : Displays the top-level scheduler parameters.
-- Requirements : Access to the DBMS_SCHEDULER package and the MANAGE SCHEDULER privilege.
-- Call Syntax  : @scheduler_attributes
-- Last Modified: 13-DEC-2016
-- -----------------------------------------------------------------------------------

SET SERVEROUTPUT ON
DECLARE
  PROCEDURE display(p_param IN VARCHAR2) AS
    l_result VARCHAR2(50);
  BEGIN
    DBMS_SCHEDULER.get_scheduler_attribute(
      attribute => p_param,
      value     => l_result);
    DBMS_OUTPUT.put_line(RPAD(p_param, 30, ' ') || ' : ' || l_result);
  END;
BEGIN
  display('current_open_window');
  display('default_timezone');
  display('email_sender');
  display('email_server');
  display('event_expiry_time');
  display('log_history');
  display('max_job_slave_processes');
END;
/
