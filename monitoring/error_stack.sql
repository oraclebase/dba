-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/error_stack.sql
-- Author       : Tim Hall
-- Description  : Displays contents of the error stack.
-- Call Syntax  : @error_stack
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
DECLARE
  v_stack  VARCHAR2(2000);
BEGIN
  v_stack := Dbms_Utility.Format_Error_Stack;
  Dbms_Output.Put_Line(v_stack);
END;
/
