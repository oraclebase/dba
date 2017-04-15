-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/source.sql
-- Author       : Tim Hall
-- Description  : Displays the section of code specified. Prompts user for parameters.
-- Requirements : Access to the ALL views.
-- Call Syntax  : @source
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
PROMPT
ACCEPT a_name   PROMPT 'Enter Name: '
ACCEPT a_type   PROMPT 'Enter Type (S,B,P,F): '
ACCEPT a_from   PROMPT 'Enter Line From: '
ACCEPT a_to     PROMPT 'Enter Line To: '
ACCEPT a_owner  PROMPT 'Enter Owner: '
VARIABLE v_name   VARCHAR2(100)
VARIABLE v_type   VARCHAR2(100)
VARIABLE v_from   NUMBER
VARIABLE v_to     NUMBER
VARIABLE v_owner  VARCHAR2(100)
SET VERIFY OFF
SET FEEDBACK OFF
SET LINESIZE 300
SET PAGESIZE 0

BEGIN
  :v_name  := Upper('&a_name');
  :v_type  := Upper('&a_type');
  :v_from  := &a_from;
  :v_to    := &a_to;
  :v_owner := Upper('&a_owner');

  IF    :v_type = 'S' THEN
    :v_type := 'PACKAGE';
  ELSIF :v_type = 'B' THEN
    :v_type := 'PACKAGE BODY';
  ELSIF :v_type = 'P' THEN
    :v_type := 'PROCEDURE';
  ELSE
    :v_type := 'FUNCTION';
  END IF;
END;
/

SELECT a.line "Line",
       Substr(a.text,1,200) "Text"
FROM   all_source a
WHERE  a.name = :v_name
AND    a.type = :v_type
AND    a.line BETWEEN :v_from AND :v_to
AND    a.owner = :v_owner;

SET VERIFY ON
SET FEEDBACK ON
SET PAGESIZE 22
PROMPT
