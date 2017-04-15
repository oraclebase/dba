-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/drop_cons_on_table.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL to drop the UK & PK constraints on the specified table, or all tables.
-- Call Syntax  : @drop_cons_on_table (table-name or all) (schema)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET LINESIZE 100
SET VERIFY OFF
SET FEEDBACK OFF
PROMPT

DECLARE

    CURSOR cu_cons IS
        SELECT *
        FROM   all_constraints a
        WHERE  a.table_name = Decode(Upper('&&1'),'ALL',a.table_name,Upper('&&1'))
        AND    a.owner      = Upper('&&2')
        AND    a.constraint_type IN ('P','U');

    -- ----------------------------------------------------------------------------------------
    FUNCTION Con_Columns(p_tab  IN  VARCHAR2,
                         p_con  IN  VARCHAR2)
        RETURN VARCHAR2 IS
    -- ----------------------------------------------------------------------------------------    
        CURSOR cu_col_cursor IS
            SELECT  a.column_name
            FROM    all_cons_columns a
            WHERE   a.table_name      = p_tab
            AND     a.constraint_name = p_con
            AND     a.owner           = Upper('&&2')
            ORDER BY a.position;
     
        l_result    VARCHAR2(1000);        
    BEGIN    
        FOR cur_rec IN cu_col_cursor LOOP
            IF cu_col_cursor%ROWCOUNT = 1 THEN
                l_result   := cur_rec.column_name;
            ELSE
                l_result   := l_result || ',' || cur_rec.column_name;
            END IF;
        END LOOP;
        RETURN Lower(l_result);        
    END;
    -- ----------------------------------------------------------------------------------------

BEGIN

    DBMS_Output.Disable;
    DBMS_Output.Enable(1000000);
    DBMS_Output.Put_Line('PROMPT');
    DBMS_Output.Put_Line('PROMPT Droping Constraints on ' || Upper('&&1'));
    FOR cur_rec IN cu_cons LOOP
        IF    cur_rec.constraint_type = 'P' THEN
            DBMS_Output.Put_Line('ALTER TABLE ' || Lower(cur_rec.table_name) || ' DROP PRIMARY KEY;');
        ELSIF cur_rec.constraint_type = 'R' THEN
            DBMS_Output.Put_Line('ALTER TABLE ' || Lower(cur_rec.table_name) || ' DROP CONSTRAINT ' || Lower(cur_rec.constraint_name) || ';');
        ELSIF cur_rec.constraint_type = 'U' THEN
            DBMS_Output.Put_Line('ALTER TABLE ' || Lower(cur_rec.table_name) || ' DROP UNIQUE (' || Con_Columns(cur_rec.table_name, cur_rec.constraint_name) || ');');
        END IF;
    END LOOP; 
 
END;
/

PROMPT
SET VERIFY ON
SET FEEDBACK ON



	

