-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/get_pivot.sql
-- Author       : Tim Hall
-- Description  : Creates a function to produce a virtual pivot table with the specific values.
-- Requirements : CREATE TYPE, CREATE PROCEDURE
-- Call Syntax  : @get_pivot.sql
-- Last Modified: 13/08/2003
-- -----------------------------------------------------------------------------------

CREATE OR REPLACE TYPE t_pivot AS TABLE OF NUMBER;
/

CREATE OR REPLACE FUNCTION get_pivot(p_max   IN  NUMBER,
                                     p_step  IN  NUMBER DEFAULT 1) 
  RETURN t_pivot AS
  l_pivot t_pivot := t_pivot();
BEGIN
  FOR i IN 0 .. TRUNC(p_max/p_step) LOOP
    l_pivot.extend;
    l_pivot(l_pivot.last) := 1 + (i * p_step);
  END LOOP;
  RETURN l_pivot;
END;
/
SHOW ERRORS

SELECT column_value
FROM   TABLE(get_pivot(17,2));
                            
