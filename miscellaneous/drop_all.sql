-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/drop_all.sql
-- Author       : Tim Hall
-- Description  : Drops all objects within the current schema.
-- Call Syntax  : @drop_all
-- Last Modified: 20/01/2006
-- Notes        : Loops a maximum of 5 times, allowing for failed drops due to dependencies.
--                Quits outer loop if no drops were atempted.
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
DECLARE
  l_count    NUMBER;
  l_cascade  VARCHAR2(20);
BEGIN
  << dependency_failure_loop >>
  FOR i IN 1 .. 5 LOOP
    EXIT dependency_failure_loop WHEN l_count = 0;
    l_count := 0;
    
    FOR cur_rec IN (SELECT object_name, object_type 
                    FROM   user_objects) LOOP
      BEGIN
        l_count := l_count + 1;
        l_cascade := NULL;
        IF cur_rec.object_type = 'TABLE' THEN
          l_cascade := ' CASCADE CONSTRAINTS';
        END IF;
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"' || l_cascade;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
    -- Comment out the following line if you are pre-10g, or want to preserve the recyclebin contents. 
    EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';
    DBMS_OUTPUT.put_line('Pass: ' || i || '  Drops: ' || l_count);
  END LOOP;
END;
/
