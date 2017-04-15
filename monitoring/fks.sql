-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/fks.sql
-- Author       : Tim Hall
-- Description  : Displays the constraints on a specific table and those referencing it.
-- Call Syntax  : @fks (table-name) (schema)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
PROMPT
SET VERIFY OFF
SET FEEDBACK OFF
SET LINESIZE 255
SET PAGESIZE 1000

PROMPT
PROMPT Constraints Owned By Table
PROMPT ==========================
SELECT c.constraint_name "Constraint",
       Decode(c.constraint_type,'P','Primary Key',
                                'U','Unique Key',
                                'C','Check',
                                'R','Foreign Key',
                                c.constraint_type) "Type",
       c.r_owner "Ref Table",
       c.r_constraint_name "Ref Constraint"
FROM   all_constraints c
WHERE  c.table_name = Upper('&&1')
AND    c.owner      = Upper('&&2');


PROMPT
PROMPT Constraints Referencing Table
PROMPT =============================
SELECT c1.table_name "Table",
       c1.constraint_name "Foreign Key",
       c1.r_constraint_name "References"
FROM   all_constraints c1 
WHERE  c1.owner      = Upper('&&2')
AND    c1.r_constraint_name IN (SELECT c2.constraint_name
                                FROM   all_constraints c2
                                WHERE  c2.table_name = Upper('&&1')
                                AND    c2.owner      = Upper('&&2')
                                AND    c2.constraint_type IN ('P','U'));

SET VERIFY ON
SET FEEDBACK ON
SET PAGESIZE 1000
PROMPT
