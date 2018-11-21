CREATE OR REPLACE PACKAGE BODY dsp AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/dsp.pkb
-- Author       : Tim Hall
-- Description  : An extension of the DBMS_OUTPUT package.
-- Requirements : https://oracle-base.com/dba/miscellaneous/dsp.pks
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   08-JAN-2002  Tim Hall  Initial Creation.
--   04-APR-2005  Tim Hall  Store last call. Add get_last_prefix and
--                          get_last_data to allow retrieval.
--                          Switch from date to timestamp for greater accuracy.
--   01-MAR-2013  Tim Hall  Add RAISE to output procedure.
--                          Force upper case on directory object names.
--   02-MAR-2013  Tim Hall  Fix wrap_line. ORA-21780: Maximum number of object durations exceeded.
--                          Added file_contents pipelined table function.
--                          Added delete_file.
--   02-DEC-2013  Tim Hall  Add p_trace_level parameter to most code to
--                          limit amount of trace produced.
--                          Prefixed UTL_FILE references with "SYS.".
--   21-NOV-2018  Tim Hall  Add CLOB overloads to LINE.
-- --------------------------------------------------------------------------

-- Package Variables
g_show_output     BOOLEAN         := FALSE;
g_show_date       BOOLEAN         := FALSE;
g_line_wrap       BOOLEAN         := TRUE;
g_max_width       PLS_INTEGER     := 255;
g_date_format     VARCHAR2(32767) := 'DD-MON-YYYY HH24:MI:SS.FF';
g_file_dir        VARCHAR2(32767) := NULL;
g_file_name       VARCHAR2(32767) := NULL;
g_last_prefix     VARCHAR2(32767) := NULL;
g_last_data       VARCHAR2(32767) := NULL;
g_trace_level     PLS_INTEGER     := DSP.trace_level_all;

-- Hidden Methods
PROCEDURE display (p_prefix       IN  VARCHAR2,
                   p_data         IN  VARCHAR2,
                   p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info,
                   p_wrap         IN  BOOLEAN := FALSE);

PROCEDURE display_clob (p_prefix       IN  VARCHAR2,
                        p_data         IN  CLOB,
                        p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

PROCEDURE wrap_line (p_data         IN  VARCHAR2,
                     p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

PROCEDURE wrap_line_clob (p_data         IN  CLOB,
                          p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

PROCEDURE output (p_data  IN  VARCHAR2);


-- Exposed Methods

-- --------------------------------------------------------------------------
PROCEDURE reset_defaults IS
-- --------------------------------------------------------------------------
BEGIN
  g_show_output  := FALSE;
  g_show_date    := FALSE;
  g_line_wrap    := TRUE;
  g_max_width    := 255;
  g_date_format  := 'DD-MON-YYYY HH24:MI:SS.FF';
  g_trace_level  := DSP.trace_level_all;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE show_output_on(p_trace_level  IN  PLS_INTEGER := DSP.trace_level_all) IS
-- --------------------------------------------------------------------------
BEGIN
  g_show_output := TRUE;
  g_trace_level := p_trace_level;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE show_output_off IS
-- --------------------------------------------------------------------------
BEGIN
  g_show_output := FALSE;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE show_date_on IS
-- --------------------------------------------------------------------------
BEGIN
  g_show_date := TRUE;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE show_date_off IS
-- --------------------------------------------------------------------------
BEGIN
  g_show_date := FALSE;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line_wrap_on IS
-- --------------------------------------------------------------------------
BEGIN
  g_line_wrap := TRUE;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line_wrap_off IS
-- --------------------------------------------------------------------------
BEGIN
  g_line_wrap := FALSE;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE set_max_width (p_width  IN  PLS_INTEGER) IS
-- --------------------------------------------------------------------------
BEGIN
  g_max_width := p_width;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE set_date_format (p_date_format  IN  VARCHAR2) IS
-- --------------------------------------------------------------------------
BEGIN
  g_date_format := p_date_format;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE file_output_on (p_file_dir   IN  VARCHAR2 DEFAULT NULL,
                          p_file_name  IN  VARCHAR2 DEFAULT NULL) IS
-- --------------------------------------------------------------------------
BEGIN
  g_file_dir  := UPPER(p_file_dir);
  g_file_name := p_file_name;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE file_output_off IS
-- --------------------------------------------------------------------------
BEGIN
  g_file_dir  := NULL;
  g_file_name := NULL;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
FUNCTION get_last_prefix
  RETURN VARCHAR2 IS
-- --------------------------------------------------------------------------
BEGIN
  RETURN g_last_prefix;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
FUNCTION get_last_data
  RETURN VARCHAR2 IS
-- --------------------------------------------------------------------------
BEGIN
  RETURN g_last_data;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_data         IN  VARCHAR2,
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  display (NULL, p_data, p_trace_level);
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_data         IN  CLOB,
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  display_clob (NULL, p_data, p_trace_level);
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_data         IN  NUMBER,
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  display (NULL, p_data, p_trace_level);
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_data         IN  BOOLEAN,
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  line (NULL, p_data, p_trace_level);
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_data         IN  DATE,
                p_format       IN  VARCHAR2 DEFAULT 'DD-MON-YYYY HH24:MI:SS.FF',
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  line (NULL, p_data, p_format, p_trace_level);
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_prefix       IN  VARCHAR2,
                p_data         IN  VARCHAR2,
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  display (p_prefix, p_data, p_trace_level);
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_prefix       IN  VARCHAR2,
                p_data         IN  CLOB,
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  display_clob (p_prefix, p_data, p_trace_level);
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_prefix       IN  VARCHAR2,
                p_data         IN  NUMBER,
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  display (p_prefix, TO_CHAR(p_data), p_trace_level);
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_prefix       IN  VARCHAR2,
                p_data         IN  BOOLEAN,
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  IF p_data THEN
    display (p_prefix, 'TRUE', p_trace_level);
  ELSE
    display (p_prefix, 'FALSE', p_trace_level);
  END IF;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE line (p_prefix       IN  VARCHAR2,
                p_data         IN  DATE,
                p_format       IN  VARCHAR2 DEFAULT 'DD-MON-YYYY HH24:MI:SS.FF',
                p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
BEGIN
  display (p_prefix, TO_CHAR(p_data, p_format), p_trace_level);
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE display (p_prefix       IN  VARCHAR2,
                   p_data         IN  VARCHAR2,
                   p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info,
                   p_wrap         IN  BOOLEAN := FALSE) IS
-- --------------------------------------------------------------------------
  l_data  VARCHAR2(32767) := p_data;
BEGIN
  g_last_prefix := p_prefix;
  g_last_data   := p_data;

  IF g_show_output AND p_trace_level <= g_trace_level THEN
    IF l_data IS NULL THEN
      l_data := '<NULL>';
    END IF;

    IF p_prefix IS NOT NULL AND p_wrap = FALSE THEN
      l_data := p_prefix || ' : ' || l_data;
    END IF;

    IF g_show_date AND p_wrap = FALSE THEN
      l_data := TO_CHAR(SYSTIMESTAMP, g_date_format) || ' : ' || l_data;
    END IF;

    IF LENGTH(l_data) > g_max_width THEN
      IF g_line_wrap THEN
        wrap_line (l_data);
      ELSE
        l_data := SUBSTR(l_data, 1, g_max_width);
        output (l_data);
      END IF;
    ELSE
      output (l_data);
    END IF;
  END IF;
END;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
PROCEDURE display_clob (p_prefix       IN  VARCHAR2,
                        p_data         IN  CLOB,
                        p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
  l_data  CLOB := p_data;
BEGIN
  g_last_prefix := p_prefix;

  IF g_show_output AND p_trace_level <= g_trace_level THEN
    IF l_data IS NULL THEN
      l_data := '<NULL>';
    END IF;

    IF p_prefix IS NOT NULL THEN
      l_data := p_prefix || ' : ' || l_data;
    END IF;

    IF g_show_date THEN
      l_data := TO_CHAR(SYSTIMESTAMP, g_date_format) || ' : ' || l_data;
    END IF;

    wrap_line_clob (l_data);
  END IF;
END;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
PROCEDURE wrap_line (p_data         IN  VARCHAR2,
                     p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
  l_offset NUMBER := 1;
BEGIN
  LOOP
    EXIT WHEN l_offset > LENGTH(p_data);
    display (NULL, SUBSTR(p_data, l_offset, g_max_width), p_trace_level, TRUE);
    l_offset := l_offset + g_max_width;
  END LOOP;
END;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
PROCEDURE wrap_line_clob (p_data         IN  CLOB,
                          p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info) IS
-- --------------------------------------------------------------------------
  l_offset NUMBER := 1;
BEGIN
  LOOP
    EXIT WHEN l_offset > LENGTH(p_data);
    display (NULL, SUBSTR(p_data, l_offset, g_max_width), p_trace_level, TRUE);
    l_offset := l_offset + g_max_width;
  END LOOP;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE output (p_data  IN  VARCHAR2) IS
-- --------------------------------------------------------------------------
BEGIN
  IF g_file_dir IS NULL OR g_file_name IS NULL THEN
    DBMS_OUTPUT.put_line(p_data);
  ELSE
    DECLARE
      l_file  SYS.UTL_FILE.file_type;
    BEGIN
      l_file := SYS.UTL_FILE.fopen (g_file_dir, g_file_name, 'A', 32767);
      SYS.UTL_FILE.put_line(l_file, p_data);
      SYS.UTL_FILE.fclose (l_file);
    EXCEPTION
      WHEN OTHERS THEN
        SYS.UTL_FILE.fclose (l_file);
        RAISE;
    END;
  END IF;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
FUNCTION file_contents (p_dir  IN VARCHAR2,
                        p_file IN VARCHAR2)
  RETURN DBMSOUTPUT_LINESARRAY PIPELINED IS
-- --------------------------------------------------------------------------
  l_file SYS.UTL_FILE.file_type;
  l_text VARCHAR2(32767);
BEGIN
  l_file := SYS.UTL_FILE.fopen(UPPER(p_dir), p_file, 'r', 32767);
  BEGIN
    LOOP
      SYS.UTL_FILE.get_line(l_file, l_text);
      PIPE ROW (l_text);
    END LOOP;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
  UTL_FILE.fclose(l_file);
  RETURN;
EXCEPTION
  WHEN OTHERS THEN
    PIPE ROW ('ERROR: ' || SQLERRM);
    IF SYS.UTL_FILE.is_open(l_file) THEN
      SYS.UTL_FILE.fclose(l_file);
    END IF;
    RETURN;
END;
-- --------------------------------------------------------------------------


-- --------------------------------------------------------------------------
PROCEDURE delete_file (p_dir  IN VARCHAR2,
                       p_file IN VARCHAR2) IS
-- --------------------------------------------------------------------------
BEGIN
  SYS.UTL_FILE.fremove(UPPER(p_dir), p_file);
END;
-- --------------------------------------------------------------------------

END dsp;
/

SHOW ERRORS
