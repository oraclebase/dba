-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/rbs_structure.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for specified segment, or all segments.
-- Call Syntax  : @rbs_structure (segment-name or all)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET LINESIZE 100
SET VERIFY OFF
SET FEEDBACK OFF
PROMPT

DECLARE

    CURSOR cu_rs IS
        SELECT a.segment_name,
               a.tablespace_name,
               a.initial_extent,
               a.next_extent,
               a.min_extents,
               a.max_extents,
               a.pct_increase,
               b.bytes
        FROM   dba_rollback_segs a,
               dba_segments      b
        WHERE  a.segment_name = b.segment_name
        AND    a.segment_name  = Decode(Upper('&&1'), 'ALL',a.segment_name, Upper('&&1'))
        ORDER BY a.segment_name;
 
BEGIN

    DBMS_Output.Disable;
    DBMS_Output.Enable(1000000);

    FOR cur_rs IN cu_rs LOOP
        DBMS_Output.Put_Line('PROMPT');
        DBMS_Output.Put_Line('PROMPT Creating Rollback Segment ' || cur_rs.segment_name);
        DBMS_Output.Put_Line('CREATE ROLLBACK SEGMENT ' || Lower(cur_rs.segment_name));
        DBMS_Output.Put_Line('TABLESPACE ' || Lower(cur_rs.tablespace_name));        
        DBMS_Output.Put_Line('STORAGE	(');
        DBMS_Output.Put_Line('		INITIAL     ' || Trunc(cur_rs.initial_extent/1024) || 'K');
        DBMS_Output.Put_Line('		NEXT        ' || Trunc(cur_rs.next_extent/1024) || 'K');
        DBMS_Output.Put_Line('		MINEXTENTS  ' || cur_rs.min_extents);
        DBMS_Output.Put_Line('		MAXEXTENTS  ' || cur_rs.max_extents);
        DBMS_Output.Put_Line('		PCTINCREASE ' || cur_rs.pct_increase);
        DBMS_Output.Put_Line('	)');
        DBMS_Output.Put_Line('/');        
        DBMS_Output.Put_Line('	');        
    END LOOP;

    DBMS_Output.Put_Line('	');

END;
/

SET VERIFY ON
SET FEEDBACK ON