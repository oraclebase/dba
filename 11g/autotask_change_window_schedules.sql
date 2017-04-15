-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/autotask_change_window_schedules.sql
-- Author       : Tim Hall
-- Description  : Use this script to alter the autotask window schedules.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @autotask_change_window_schedules.sql
-- Last Modified: 14-JUL-2016
-- -----------------------------------------------------------------------------------

DECLARE
  TYPE t_window_tab IS TABLE OF VARCHAR2(30)
    INDEX BY BINARY_INTEGER;
    
  l_tab              t_window_tab;
  l_repeat_interval  VARCHAR2(100);
  l_duration         NUMBER;
BEGIN

  -- Windows of interest.
  l_tab(1) := 'SYS.MONDAY_WINDOW';
  l_tab(2) := 'SYS.TUESDAY_WINDOW';
  l_tab(3) := 'SYS.WEDNESDAY_WINDOW';
  l_tab(4) := 'SYS.THURSDAY_WINDOW';
  l_tab(5) := 'SYS.FRIDAY_WINDOW';
  --l_tab(6) := 'SYS.SATURDAY_WINDOW';
  --l_tab(7) := 'SYS.SUNDAY_WINDOW';

  -- Adjust as required.
  l_repeat_interval := 'freq=weekly; byday=mon; byhour=12; byminute=0; bysecond=0;';
  l_duration        := 120; -- minutes
  
  FOR i IN l_tab.FIRST .. l_tab.LAST LOOP
    DBMS_SCHEDULER.disable(name => l_tab(i), force => TRUE);

    DBMS_SCHEDULER.set_attribute(
      name      => l_tab(i),
      attribute => 'REPEAT_INTERVAL',
      value     => l_repeat_interval);

    DBMS_SCHEDULER.set_attribute(
      name      => l_tab(i),
      attribute => 'DURATION',
      value     => numtodsinterval(l_duration, 'minute'));

    DBMS_SCHEDULER.enable(name => l_tab(i));
  END LOOP;
END;
/
