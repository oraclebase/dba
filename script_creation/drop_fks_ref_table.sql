-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/drop_fks_ref_table.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL to drop the foreign keys that referenece the specified table.
-- Call Syntax  : @drop_fks_ref_table (table-name) (schema)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET LINESIZE 100
SET VERIFY OFF
SET FEEDBACK OFF
PROMPT

DECLARE

    CURSOR cu_fks IS
        SELECT *
        FROM   all_constraints a
        WHERE  a.owner      = Upper('&&2')
        AND    a.constraint_type = 'R'
        AND    a.r_constraint_name IN (SELECT a1.constraint_name
                                       FROM   all_constraints a1
                                       WHERE  a1.table_name = Upper('&&1')
                                       AND    a1.owner      = Upper('&&2'));

BEGIN

    DBMS_Output.Put_Line('PROMPT');
    DBMS_Output.Put_Line('PROMPT Droping Foreign Keys to ' || Upper('&&1'));
    FOR cur_rec IN cu_fks LOOP
        DBMS_Output.Put_Line('ALTER TABLE ' || Lower(cur_rec.table_name) || ' DROP CONSTRAINT ' || Lower(cur_rec.constraint_name) || ';');
    END LOOP; 

END;
/

PROMPT
SET VERIFY ON
SET FEEDBACK ON



	

