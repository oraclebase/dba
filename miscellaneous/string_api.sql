CREATE OR REPLACE PACKAGE string_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/string_api.sql
-- Author       : Tim Hall
-- Description  : A package to hold string utilities.
-- Requirements : 
-- Amendments   :
--   When         Who       What
--   ===========  ========  =================================================
--   02-DEC-2004  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

-- Public types
TYPE t_split_array IS TABLE OF VARCHAR2(4000);

FUNCTION split_text (p_text       IN  CLOB,
                     p_delimeter  IN  VARCHAR2 DEFAULT ',')
  RETURN t_split_array;

PROCEDURE print_clob (p_clob  IN  CLOB);
PROCEDURE print_clob_old (p_clob  IN  CLOB);

PROCEDURE print_clob_htp (p_clob  IN  CLOB);
PROCEDURE print_clob_htp_old (p_clob  IN  CLOB);

END string_api;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY string_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/string_api.sql
-- Author       : Tim Hall
-- Description  : A package to hold string utilities.
-- Requirements : 
-- Amendments   :
--   When         Who       What
--   ===========  ========  =================================================
--   02-DEC-2004  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
FUNCTION split_text (p_text       IN  CLOB,
                     p_delimeter  IN  VARCHAR2 DEFAULT ',')
  RETURN t_split_array IS
-- ----------------------------------------------------------------------------
  l_array  t_split_array   := t_split_array();
  l_text   CLOB := p_text;
  l_idx    NUMBER;
BEGIN
  l_array.delete;

  IF l_text IS NULL THEN
    RAISE_APPLICATION_ERROR(-20000, 'P_TEXT parameter cannot be NULL');
  END IF;

  WHILE l_text IS NOT NULL LOOP
    l_idx := INSTR(l_text, p_delimeter);
    l_array.extend;
    IF l_idx > 0 THEN
      l_array(l_array.last) := SUBSTR(l_text, 1, l_idx - 1);
      l_text := SUBSTR(l_text, l_idx + 1);
    ELSE
      l_array(l_array.last) := l_text;
      l_text := NULL;
    END IF;
  END LOOP;
  RETURN l_array;
END split_text;
-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
PROCEDURE print_clob (p_clob IN CLOB) IS
-- ----------------------------------------------------------------------------
  l_offset NUMBER := 1;
  l_chunk  NUMBER := 255;
BEGIN
  LOOP
    EXIT WHEN l_offset > LENGTH(p_clob);
    DBMS_OUTPUT.put_line(SUBSTR(p_clob, l_chunk, l_offset));
    l_offset := l_offset + l_chunk;
  END LOOP;
END print_clob;
-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
PROCEDURE print_clob_old (p_clob IN CLOB) IS
-- ----------------------------------------------------------------------------
  l_offset NUMBER := 1;
  l_chunk  NUMBER := 255;
BEGIN
  LOOP
    EXIT WHEN l_offset > DBMS_LOB.getlength(p_clob);
    DBMS_OUTPUT.put_line(DBMS_LOB.substr(p_clob, l_chunk, l_offset));
    l_offset := l_offset + l_chunk;
  END LOOP;
END print_clob_old;
-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
PROCEDURE print_clob_htp (p_clob IN CLOB) IS
-- ----------------------------------------------------------------------------
  l_offset NUMBER := 1;
  l_chunk  NUMBER := 32767;
BEGIN
  LOOP
    EXIT WHEN l_offset > LENGTH(p_clob);
    HTP.prn(SUBSTR(p_clob, l_chunk, l_offset));
    l_offset := l_offset + l_chunk;
  END LOOP;
END print_clob_htp;
-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
PROCEDURE print_clob_htp_old (p_clob IN CLOB) IS
-- ----------------------------------------------------------------------------
  l_offset NUMBER := 1;
  l_chunk  NUMBER := 32767;
BEGIN
  LOOP
    EXIT WHEN l_offset > DBMS_LOB.getlength(p_clob);
    HTP.prn(DBMS_LOB.substr(p_clob, l_chunk, l_offset));
    l_offset := l_offset + l_chunk;
  END LOOP;
END print_clob_htp_old;
-- ----------------------------------------------------------------------------

END string_api;
/
SHOW ERRORS
