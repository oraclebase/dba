-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/table_differences.sql
-- Author       : Tim Hall
-- Description  : Checks column differences between a specified table or ALL tables.
--              : The comparison is done both ways so datatype/size mismatches will
--              : be listed twice per column.
--              : Log into the first schema-owner. Make sure a DB Link is set up to
--              : the second schema owner. Use this DB Link in the definition of 
--              : the c_table2 cursor and amend v_owner1 and v_owner2 accordingly
--              : to make output messages sensible.
--              : The result is spooled to the Tab_Diffs.txt file in the working directory.
-- Call Syntax  : @table_differences (table-name or all)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET LINESIZE 500
SET VERIFY OFF
SET FEEDBACK OFF
PROMPT

SPOOL Tab_Diffs.txt

DECLARE

  CURSOR c_tables IS
    SELECT a.table_name
    FROM   user_tables a
    WHERE  a.table_name = Decode(Upper('&&1'),'ALL',a.table_name,Upper('&&1'));
    
  CURSOR c_table1 (p_table_name   IN  VARCHAR2,
                   p_column_name  IN  VARCHAR2) IS
    SELECT a.column_name,
           a.data_type,
           a.data_length,
           a.data_precision,
           a.data_scale,
           a.nullable
    FROM   user_tab_columns a
    WHERE  a.table_name  = p_table_name
    AND    a.column_name = NVL(p_column_name,a.column_name);

  CURSOR c_table2 (p_table_name   IN  VARCHAR2,
                   p_column_name  IN  VARCHAR2) IS
    SELECT a.column_name,
           a.data_type,
           a.data_length,
           a.data_precision,
           a.data_scale,
           a.nullable
    FROM   user_tab_columns@pdds a
    WHERE  a.table_name  = p_table_name
    AND    a.column_name = NVL(p_column_name,a.column_name);

  v_owner1  VARCHAR2(10) := 'DDDS2';
  v_owner2  VARCHAR2(10) := 'PDDS';
  v_data    c_table1%ROWTYPE;
  v_work    BOOLEAN := FALSE;
  
BEGIN

  Dbms_Output.Disable;
  Dbms_Output.Enable(1000000);
  
  FOR cur_tab IN c_tables LOOP
    v_work := FALSE;
    FOR cur_rec IN c_table1 (cur_tab.table_name, NULL) LOOP
      v_work := TRUE;
      
      OPEN  c_table2 (cur_tab.table_name, cur_rec.column_name);
      FETCH c_table2
      INTO  v_data;
      IF c_table2%NOTFOUND THEN
        Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : Present in ' || v_owner1 || ' but not in ' || v_owner2);
      ELSE
        IF cur_rec.data_type != v_data.data_type THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : DATA_TYPE differs between ' || v_owner1 || ' and ' || v_owner2);
        END IF;
        IF cur_rec.data_length != v_data.data_length THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : DATA_LENGTH differs between ' || v_owner1 || ' and ' || v_owner2);
        END IF;
        IF cur_rec.data_precision != v_data.data_precision THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : DATA_PRECISION differs between ' || v_owner1 || ' and ' || v_owner2);
        END IF;
        IF cur_rec.data_scale != v_data.data_scale THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : DATA_SCALE differs between ' || v_owner1 || ' and ' || v_owner2);
        END IF;
        IF cur_rec.nullable != v_data.nullable THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : NULLABLE differs between ' || v_owner1 || ' and ' || v_owner2);
        END IF;
      END IF;
      CLOSE c_table2; 
    END LOOP;
    
    FOR cur_rec IN c_table2 (cur_tab.table_name, NULL) LOOP
      v_work := TRUE;
      
      OPEN  c_table1 (cur_tab.table_name, cur_rec.column_name);
      FETCH c_table1
      INTO  v_data;
      IF c_table1%NOTFOUND THEN
        Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : Present in ' || v_owner2 || ' but not in ' || v_owner1);
      ELSE
        IF cur_rec.data_type != v_data.data_type THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : DATA_TYPE differs between ' || v_owner2 || ' and ' || v_owner1);
        END IF;
        IF cur_rec.data_length != v_data.data_length THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : DATA_LENGTH differs between ' || v_owner2 || ' and ' || v_owner1);
        END IF;
        IF cur_rec.data_precision != v_data.data_precision THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : DATA_PRECISION differs between ' || v_owner2 || ' and ' || v_owner1);
        END IF;
        IF cur_rec.data_scale != v_data.data_scale THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : DATA_SCALE differs between ' || v_owner2 || ' and ' || v_owner1);
        END IF;
        IF cur_rec.nullable != v_data.nullable THEN
          Dbms_Output.Put_Line(cur_tab.table_name || '.' || cur_rec.column_name || ' : NULLABLE differs between ' || v_owner2 || ' and ' || v_owner1);
        END IF;
      END IF;
      CLOSE c_table1; 
    END LOOP;
    
    IF v_work = FALSE THEN
      Dbms_Output.Put_Line(cur_tab.table_name || ' does not exist!');
    END IF;  
  END LOOP;
END;
/

SPOOL OFF

PROMPT
SET FEEDBACK ON
