-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/recreate_table.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL to recreate the specified table.
-- Comments     : Mostly used when dropping columns prior to Oracle 8i. Not updated since Oracle 7.3.4.
-- Requirements : Requires a number of the other creation scripts.
-- Call Syntax  : @recreate_table (table-name) (schema-name)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET LINESIZE 100
SET VERIFY OFF
SET FEEDBACK OFF
SET TERMOUT OFF
SPOOL ReCreate_&&1
PROMPT

-- ----------------------------------------------
-- Reset the buffer size and display script title
-- ----------------------------------------------
BEGIN
    DBMS_Output.Disable;
    DBMS_Output.Enable(1000000);
    DBMS_Output.Put_Line('-------------------------------------------------------------');
    DBMS_Output.Put_Line('-- Author        : Tim Hall');
    DBMS_Output.Put_Line('-- Creation Date : ' || To_Char(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));
    DBMS_Output.Put_Line('-- Description   : Re-creation script for ' ||  Upper('&&1'));
    DBMS_Output.Put_Line('-------------------------------------------------------------');
END;
/
       
-- ------------------------------------
-- Drop existing FKs to specified table
-- ------------------------------------
@Drop_FKs_Ref_Table &&1 &&2    

-- -----------------
-- Drop FKs on table
-- -----------------
@Drop_FKs_On_Table &&1 &&2  
    
-- -------------------------
-- Drop constraints on table
-- -------------------------
@Drop_Cons_On_Table &&1 &&2  
    
-- ---------------------
-- Drop indexes on table
-- ---------------------
@Drop_Indexes &&1 &&2 
    
-- -----------------------------------------
-- Rename existing table - prefix with 'tmp'
-- -----------------------------------------
SET VERIFY OFF
SET FEEDBACK OFF
BEGIN
    DBMS_Output.Put_Line('	');
    DBMS_Output.Put_Line('PROMPT');
    DBMS_Output.Put_Line('PROMPT Renaming ' || Upper('&&1') || ' to TMP_' || Upper('&&1'));
    DBMS_Output.Put_Line('RENAME ' || Lower('&&1') || ' TO tmp_' || Lower('&&1'));
    DBMS_Output.Put_Line('/');
END;
/
    
-- ---------------
-- Re-Create table
-- ---------------
@Table_Structure &&1 &&2

-- ---------------------
-- Re-Create constraints
-- ---------------------
@Table_Constraints &&1 &&2

-- ---------------------
-- Recreate FKs on table
-- ---------------------
@FKs_On_Table &&1 &&2

-- -----------------
-- Re-Create indexes
-- -----------------
@Table_Indexes &&1 &&2
    
-- --------------------------
-- Build up population insert
-- --------------------------
SET VERIFY OFF
SET FEEDBACK OFF
DECLARE

    CURSOR cu_columns IS
        SELECT Lower(column_name) column_name
        FROM   all_tab_columns atc
        WHERE  atc.table_name = Upper('&&1')
        AND    atc.owner      = Upper('&&2');

BEGIN

    DBMS_Output.Put_Line('	');
    DBMS_Output.Put_Line('PROMPT');
    DBMS_Output.Put_Line('PROMPT Populating ' || Upper('&&1') || ' from TPM_' || Upper('&&1'));
    DBMS_Output.Put_Line('INSERT INTO ' || Lower('&&1'));
    DBMS_Output.Put('SELECT ');
    FOR cur_rec IN cu_columns LOOP
        IF cu_columns%ROWCOUNT != 1 THEN
            DBMS_Output.Put_Line(',');
        END IF;
        DBMS_Output.Put('	a.' || cur_rec.column_name);
    END LOOP; 
    DBMS_Output.New_Line;
    DBMS_Output.Put_Line('FROM	tmp_' || Lower('&&1') || ' a');
    DBMS_Output.Put_Line('/');
      
    -- --------------
    -- Drop tmp table
    -- --------------
    DBMS_Output.Put_Line('	');
    DBMS_Output.Put_Line('PROMPT');
    DBMS_Output.Put_Line('PROMPT Droping TMP_' || Upper('&&1'));
    DBMS_Output.Put_Line('DROP TABLE tmp_' || Lower('&&1'));
    DBMS_Output.Put_Line('/');

END;
/

-- ---------------------
-- Recreate FKs to table
-- ---------------------
@FKs_Ref_Table &&1 &&2

SET VERIFY OFF
SET FEEDBACK OFF
BEGIN    
    DBMS_Output.Put_Line('	');
    DBMS_Output.Put_Line('-------------------------------------------------------------');
    DBMS_Output.Put_Line('-- END Re-creation script for ' || Upper('&&1'));
    DBMS_Output.Put_Line('-------------------------------------------------------------');
END;
/

SPOOL OFF
PROMPT
SET VERIFY ON
SET FEEDBACK ON
SET TERMOUT ON

