-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/create_data.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL to repopulate the specified table.
-- Call Syntax  : @create_data (table-name) (schema)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET LINESIZE 1000
SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET PAGESIZE 0
SET VERIFY OFF
SET TRIMSPOOL ON
SET TRIMOUT ON

ALTER SESSION SET nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
 
SPOOL temp.sql

DECLARE

  CURSOR c_columns (p_table_name  IN  VARCHAR2,
                    p_owner       IN  VARCHAR2) IS
    SELECT Lower(a.column_name) column_name,
           a.data_type
    FROM   all_tab_columns a
    WHERE  a.table_name = p_table_name
    AND    a.owner      = p_owner
    AND    a.data_type  IN ('CHAR','VARCHAR2','DATE','NUMBER','INTEGER');
    
  v_table_name  VARCHAR2(30) := Upper('&&1');
  v_owner       VARCHAR2(30) := Upper('&&2');
  
  
  FUNCTION Format_Col(p_column    IN  VARCHAR2,
                      p_datatype  IN  VARCHAR2) 
    RETURN VARCHAR2 IS
  BEGIN
    IF p_datatype IN ('CHAR','VARCHAR2','DATE') THEN
      RETURN ''' || Decode(' || p_column || ',NULL,''NULL'','''''''' || ' || p_column || ' || '''''''') || ''';
    ELSE 
      RETURN ''' || Decode(' || p_column || ',NULL,''NULL'',' || p_column || ') || ''';
    END IF;
  END;
    
BEGIN

  Dbms_Output.Disable;
  Dbms_Output.Enable(1000000);
  
  Dbms_Output.Put_Line('SELECT ''INSERT INTO ' || Lower(v_owner) || '.' || Lower(v_table_name));
  Dbms_Output.Put_Line('(');
  << Columns_Loop >>
  FOR cur_rec IN c_columns (v_table_name, v_owner) LOOP
    IF c_columns%ROWCOUNT != 1 THEN
      Dbms_Output.Put_Line(',');
    END IF;
    Dbms_Output.Put(cur_rec.column_name);
  END LOOP Columns_Loop;
  Dbms_Output.New_Line;
  Dbms_Output.Put_Line(')');
  Dbms_Output.Put_Line('VALUES');
  Dbms_Output.Put_Line('(');
  
  << Data_Loop >>
  FOR cur_rec IN c_columns (v_table_name, v_owner) LOOP
    IF c_columns%ROWCOUNT != 1 THEN
      Dbms_Output.Put_Line(',');
    END IF;
    Dbms_Output.Put(Format_Col(cur_rec.column_name, cur_rec.data_type));
  END LOOP Data_Loop;
  Dbms_Output.New_Line;
  Dbms_Output.Put_Line(');''');
  Dbms_Output.Put_Line('FROM ' || Lower(v_owner) || '.' || Lower(v_table_name) );
  Dbms_Output.Put_Line('/');

END;
/

SPOOL OFF

SET LINESIZE 1000
SPOOL table_data.sql

@temp.sql

SPOOL OFF

SET PAGESIZE 14
SET FEEDBACK ON