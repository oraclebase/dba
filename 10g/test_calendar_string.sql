-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/test_calendar_string.sql
-- Author       : Tim Hall
-- Description  : Displays the schedule associated with a calendar string.
-- Requirements : Access to the DBMS_SCHEDULER package.
-- Call Syntax  : @test_calendar_string (frequency) (interations)
--                @test_calendar_string 'freq=hourly; byminute=0,30; bysecond=0;' 5
-- Last Modified: 27/07/2005
-- -----------------------------------------------------------------------------------

SET SERVEROUTPUT ON;
SET VERIFY OFF
ALTER SESSION SET nls_timestamp_format = 'DD-MON-YYYY HH24:MI:SS';

DECLARE
  l_calendar_string  VARCHAR2(100) := '&1';
  l_iterations       NUMBER        := &2;

  l_start_date         TIMESTAMP := TO_TIMESTAMP('01-JAN-2004 03:04:32',
                                                 'DD-MON-YYYY HH24:MI:SS');
  l_return_date_after  TIMESTAMP := l_start_date;
  l_next_run_date      TIMESTAMP;
BEGIN
  FOR i IN 1 .. l_iterations LOOP
    DBMS_SCHEDULER.evaluate_calendar_string(  
      calendar_string   => l_calendar_string,
      start_date        => l_start_date,
      return_date_after => l_return_date_after,
      next_run_date     => l_next_run_date);
    
    DBMS_OUTPUT.put_line('Next Run Date: ' || l_next_run_date);
    l_return_date_after := l_next_run_date;
  END LOOP;
END;
/