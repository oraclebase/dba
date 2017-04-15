-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/segment_advisor.sql
-- Author       : Tim Hall
-- Description  : Displays segment advice for the specified segment.
-- Requirements : Access to the DBMS_ADVISOR package.
-- Call Syntax  : Object-type = "tablespace":
--                  @segment_advisor.sql tablespace (tablespace-name) null
--                Object-type = "table" or "index":
--                  @segment_advisor.sql (object-type) (object-owner) (object-name)
-- Last Modified: 08-APR-2005
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON SIZE 1000000
SET LINESIZE 200
SET VERIFY OFF

DECLARE
  l_object_id     NUMBER;
  l_task_name     VARCHAR2(32767) := 'SEGMENT_ADVISOR_TASK';
  l_object_type   VARCHAR2(32767) := UPPER('&1');
  l_attr1         VARCHAR2(32767) := UPPER('&2');
  l_attr2         VARCHAR2(32767) := UPPER('&3');
BEGIN
  IF l_attr2 = 'NULL' THEN
    l_attr2 := NULL;
  END IF;

  DBMS_ADVISOR.create_task (
    advisor_name      => 'Segment Advisor',
    task_name         => l_task_name);

  DBMS_ADVISOR.create_object (
    task_name   => l_task_name,
    object_type => l_object_type,
    attr1       => l_attr1,
    attr2       => l_attr2,
    attr3       => NULL,
    attr4       => 'null',
    attr5       => NULL,
    object_id   => l_object_id);

  DBMS_ADVISOR.set_task_parameter (
    task_name => l_task_name,
    parameter => 'RECOMMEND_ALL',
    value     => 'TRUE');

  DBMS_ADVISOR.execute_task(task_name => l_task_name);


  FOR cur_rec IN (SELECT f.impact,
                         o.type,
                         o.attr1,
                         o.attr2,
                         f.message,
                         f.more_info
                  FROM   dba_advisor_findings f
                         JOIN dba_advisor_objects o ON f.object_id = o.object_id AND f.task_name = o.task_name
                  WHERE  f.task_name = l_task_name
                  ORDER BY f.impact DESC)
  LOOP
    DBMS_OUTPUT.put_line('..');
    DBMS_OUTPUT.put_line('Type             : ' || cur_rec.type);
    DBMS_OUTPUT.put_line('Attr1            : ' || cur_rec.attr1);
    DBMS_OUTPUT.put_line('Attr2            : ' || cur_rec.attr2);
    DBMS_OUTPUT.put_line('Message          : ' || cur_rec.message);
    DBMS_OUTPUT.put_line('More info        : ' || cur_rec.more_info);
  END LOOP;

  DBMS_ADVISOR.delete_task(task_name => l_task_name);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('Error            : ' || DBMS_UTILITY.format_error_backtrace);
    DBMS_ADVISOR.delete_task(task_name => l_task_name);
END;
/
