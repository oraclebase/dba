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
--   19-JAN-2017  Tim Hall  Add get_uri_paramter_value function.
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

FUNCTION get_uri_paramter_value (p_uri         IN  VARCHAR2,
                                 p_param_name  IN  VARCHAR2)
  RETURN VARCHAR2;

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
--   31-AUG-2017  Tim Hall  SUBSTR parameters switched.
--   19-JAN-2017  Tim Hall  Add get_uri_paramter_value function.
--   20-NOV-2018  Tim Hall  Reduce the chunk sizes to allow for multibyte character sets.
-- --------------------------------------------------------------------------

-- Variables to support the URI functionality.
TYPE t_uri_array IS TABLE OF VARCHAR2(32767) INDEX BY VARCHAR2(32767);
g_last_uri VARCHAR2(32767) := 'initialized';
g_uri_tab  t_uri_array;



-- ----------------------------------------------------------------------------
FUNCTION split_text (p_text       IN  CLOB,
                     p_delimeter  IN  VARCHAR2 DEFAULT ',')
  RETURN t_split_array IS
-- ----------------------------------------------------------------------------
-- Could be replaced by APEX_UTIL.STRING_TO_TABLE.
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
    DBMS_OUTPUT.put_line(SUBSTR(p_clob, l_offset, l_chunk));
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
    DBMS_OUTPUT.put_line(DBMS_LOB.substr(p_clob, l_offset, l_chunk));
    l_offset := l_offset + l_chunk;
  END LOOP;
END print_clob_old;
-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
PROCEDURE print_clob_htp (p_clob IN CLOB) IS
-- ----------------------------------------------------------------------------
  l_offset NUMBER := 1;
  l_chunk  NUMBER := 3000;
BEGIN
  LOOP
    EXIT WHEN l_offset > LENGTH(p_clob);
    HTP.prn(SUBSTR(p_clob, l_offset, l_chunk));
    l_offset := l_offset + l_chunk;
  END LOOP;
END print_clob_htp;
-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
PROCEDURE print_clob_htp_old (p_clob IN CLOB) IS
-- ----------------------------------------------------------------------------
  l_offset NUMBER := 1;
  l_chunk  NUMBER := 3000;
BEGIN
  LOOP
    EXIT WHEN l_offset > DBMS_LOB.getlength(p_clob);
    HTP.prn(DBMS_LOB.substr(p_clob, l_offset, l_chunk));
    l_offset := l_offset + l_chunk;
  END LOOP;
END print_clob_htp_old;
-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
FUNCTION get_uri_paramter_value (p_uri         IN  VARCHAR2,
                                 p_param_name  IN  VARCHAR2)
  RETURN VARCHAR2 IS
-- ----------------------------------------------------------------------------
-- Example:
-- l_uri := 'https://localhost:8080/my_page.php?param1=value1&param2=value2&param3=value3';
-- l_value := string_api.get_uri_paramter_value(l_uri, 'param1')
-- ----------------------------------------------------------------------------
  l_uri    VARCHAR2(32767);
  l_array  t_split_array   := t_split_array();
  l_idx    NUMBER;
BEGIN
  IF p_uri IS NULL OR p_param_name IS NULL THEN
    RAISE_APPLICATION_ERROR(-20000, 'p_uri and p_param_name must be specified.');
  END IF;
  
  IF p_uri != g_last_uri THEN
    -- First time we've seen this URI, so build the key-value table.
    g_uri_tab.DELETE;
    g_last_uri := p_uri;
    l_uri      := TRANSLATE(g_last_uri, '&?', '^^');
    l_array    := split_text(l_uri, '^');
    FOR i IN 1 .. l_array.COUNT LOOP
      l_idx := INSTR(l_array(i), '=');
      IF l_idx != 0 THEN
        g_uri_tab(SUBSTR(l_array(i), 1, l_idx - 1)) := SUBSTR(l_array(i), l_idx + 1);
        --DBMS_OUTPUT.put_line('param_name=' || SUBSTR(l_array(i), 1, l_idx - 1) ||
        --                     ' | param_value=' || SUBSTR(l_array(i), l_idx + 1));
      END IF;
    END LOOP;
  END IF;
  
  RETURN g_uri_tab(p_param_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END get_uri_paramter_value;
-- ----------------------------------------------------------------------------

END string_api;
/
SHOW ERRORS
