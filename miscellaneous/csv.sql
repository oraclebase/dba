CREATE OR REPLACE PACKAGE csv AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/cvs.sql
-- Author       : Tim Hall
-- Description  : Basic CSV API. For usage notes see:
--                  https://oracle-base.com/articles/9i/GeneratingCSVFiles.php
--
--                  CREATE OR REPLACE DIRECTORY dba_dir AS '/u01/app/oracle/dba/';
--
--                  EXEC csv.generate('DBA_DIR', 'generate.csv', p_query => 'SELECT * FROM emp');
--
-- Requirements : UTL_FILE, DBMS_SQL
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   14-MAY-2005  Tim Hall  Initial Creation
--   19-MAY-2016  Tim Hall  Add REF CURSOR support.
--   15-JAN-2019  Tim Hall  Add DBMS_OUTPUT support.
--   31-JAN-2019  Tim Hall  Add set_quotes procedure.
--   22-NOV-2020  Tim Hall  Amend set_quotes to allow control of string escaping.
--   16-MAY-2021  Tim Hall  Add set_date_format procedure.
--   23-NOV-2021  Tim Hall  Add timestamp support.
-- --------------------------------------------------------------------------

PROCEDURE generate (p_dir        IN  VARCHAR2,
                    p_file       IN  VARCHAR2,
                    p_query      IN  VARCHAR2);

PROCEDURE generate_rc (p_dir        IN  VARCHAR2,
                       p_file       IN  VARCHAR2,
                       p_refcursor  IN OUT SYS_REFCURSOR);

PROCEDURE output (p_query  IN  VARCHAR2);

PROCEDURE output_rc (p_refcursor  IN OUT SYS_REFCURSOR);

PROCEDURE set_separator (p_sep  IN  VARCHAR2);

PROCEDURE set_date_format (p_date_format  IN  VARCHAR2);

PROCEDURE set_ts_format (p_ts_format  IN  VARCHAR2);

PROCEDURE set_ts_ltz_format (p_ts_ltz_format  IN  VARCHAR2);

PROCEDURE set_ts_tz_format (p_ts_tz_format  IN  VARCHAR2);

PROCEDURE set_quotes (p_add_quotes  IN  BOOLEAN := TRUE,
                      p_quote_char  IN  VARCHAR2 := '"',
                      p_escape      IN  BOOLEAN := TRUE);

END csv;
/
SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY csv AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/cvs.sql
-- Author       : Tim Hall
-- Description  : Basic CSV API. For usage notes see:
--                  https://oracle-base.com/articles/9i/GeneratingCSVFiles.php
--
--                  CREATE OR REPLACE DIRECTORY dba_dir AS '/u01/app/oracle/dba/';
--
--                  -- Query
--                  EXEC csv.generate('DBA_DIR', 'generate.csv', p_query => 'SELECT * FROM emp');
--
--                  -- Ref Cursor
--                  DECLARE
--                    l_refcursor  SYS_REFCURSOR;
--                  BEGIN
--                    OPEN l_refcursor FOR
--                      SELECT * FROM emp;
--                     
--                    csv.generate_rc('DBA_DIR','generate.csv', l_refcursor);
--                  END;
--                  /
--
--
-- Requirements : UTL_FILE, DBMS_SQL
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   14-MAY-2005  Tim Hall  Initial Creation
--   19-MAY-2016  Tim Hall  Add REF CURSOR support.
--   15-JAN-2019  Tim Hall  Add DBMS_OUTPUT support.
--   31-JAN-2019  Tim Hall  Add quotes to strings. Code suggested by Moose T.
--   22-NOV-2020  Tim Hall  Amend set_quotes to allow control of string escaping.
--                          Amend generate_all to include optional string escapes.
--                          Suggested by Anssi Kanninen.
--   02-MAR-2021  Tim Hall  Amend generate_all to also escape the escape character
--                          when present in the string.
--                          Suggested by Anssi Kanninen.
--   16-MAY-2021  Tim Hall  Add set_date_format procedure.
--                          Alter generate_all to use the date format.
--   23-NOV-2021  Tim Hall  Add timestamp support.
-- --------------------------------------------------------------------------

g_out_type         VARCHAR2(1)   := 'F';
g_sep              VARCHAR2(5)   := ',';
g_date_format      VARCHAR2(100) := 'yyyy-mm-dd hh24:mi:ss';
g_ts_format        VARCHAR2(100) := 'yyyy-mm-dd hh24:mi:ss.xff';
g_ts_ltz_format    VARCHAR2(100) := 'yyyy-mm-dd hh24:mi:ss.Xff am tzr';
g_ts_tz_format     VARCHAR2(100) := 'yyyy-mm-dd hh24:mi:ss.Xff am tzr';
g_add_quotes       BOOLEAN       := TRUE;
g_quote_char       VARCHAR2(1)   := '"';
g_escape           BOOLEAN       := TRUE;

-- Prototype for hidden procedures.
PROCEDURE generate_all (p_dir        IN  VARCHAR2,
                        p_file       IN  VARCHAR2,
                        p_query      IN  VARCHAR2,
                        p_refcursor  IN OUT SYS_REFCURSOR);

PROCEDURE put (p_file  IN  UTL_FILE.file_type,
               p_text  IN  VARCHAR2);

PROCEDURE new_line (p_file  IN  UTL_FILE.file_type);



-- Stub to generate a CSV from a query.
PROCEDURE generate (p_dir        IN  VARCHAR2,
                    p_file       IN  VARCHAR2,
                    p_query      IN  VARCHAR2) AS
  l_cursor  SYS_REFCURSOR;
BEGIN
  g_out_type := 'F';

  generate_all (p_dir        => p_dir,
                p_file       => p_file,
                p_query      => p_query,
                p_refcursor  => l_cursor);
END generate;


-- Stub to generate a CVS from a REF CURSOR.
PROCEDURE generate_rc (p_dir        IN  VARCHAR2,
                       p_file       IN  VARCHAR2,
                       p_refcursor  IN OUT SYS_REFCURSOR) AS
BEGIN
  g_out_type := 'F';

  generate_all (p_dir        => p_dir,
                p_file       => p_file,
                p_query      => NULL,
                p_refcursor  => p_refcursor);
END generate_rc;


-- Stub to output a CSV from a query.
PROCEDURE output (p_query  IN  VARCHAR2) AS
  l_cursor  SYS_REFCURSOR;
BEGIN
  g_out_type := 'D';

  generate_all (p_dir        => NULL,
                p_file       => NULL,
                p_query      => p_query,
                p_refcursor  => l_cursor);
END output;


-- Stub to output a CVS from a REF CURSOR.
PROCEDURE output_rc (p_refcursor  IN OUT SYS_REFCURSOR) AS
BEGIN
  g_out_type := 'D';

  generate_all (p_dir        => NULL,
                p_file       => NULL,
                p_query      => NULL,
                p_refcursor  => p_refcursor);
END output_rc;


-- Do the actual work.
PROCEDURE generate_all (p_dir        IN  VARCHAR2,
                        p_file       IN  VARCHAR2,
                        p_query      IN  VARCHAR2,
                        p_refcursor  IN OUT  SYS_REFCURSOR) AS
  l_cursor        PLS_INTEGER;
  l_rows          PLS_INTEGER;
  l_col_cnt       PLS_INTEGER;
  l_desc_tab      DBMS_SQL.desc_tab2;
  l_buffer        VARCHAR2(32767);
  l_date          DATE;
  l_ts            TIMESTAMP;
  l_ts_ltz        TIMESTAMP WITH LOCAL TIME ZONE;
  l_ts_tz         TIMESTAMP WITH TIME ZONE;
  l_is_str        BOOLEAN;
  l_is_date       BOOLEAN;
  l_is_ts         BOOLEAN;
  l_is_ts_ltz     BOOLEAN;
  l_is_ts_tz      BOOLEAN;

  l_file          UTL_FILE.file_type;
BEGIN
  IF p_query IS NOT NULL THEN
    l_cursor := DBMS_SQL.open_cursor;
    DBMS_SQL.parse(l_cursor, p_query, DBMS_SQL.native);
  ELSIF p_refcursor%ISOPEN THEN
     l_cursor := DBMS_SQL.to_cursor_number(p_refcursor);
  ELSE
    RAISE_APPLICATION_ERROR(-20000, 'You must specify a query or a REF CURSOR.');
  END IF;
  
  DBMS_SQL.describe_columns2 (l_cursor, l_col_cnt, l_desc_tab);

  FOR i IN 1 .. l_col_cnt LOOP
    CASE
      WHEN l_desc_tab(i).col_type = DBMS_TYPES.typecode_date THEN
        DBMS_SQL.define_column(l_cursor, i, l_date);
      WHEN l_desc_tab(i).col_type = 180 THEN
        DBMS_SQL.define_column(l_cursor, i, l_ts);
      WHEN l_desc_tab(i).col_type = 231 THEN
        DBMS_SQL.define_column(l_cursor, i, l_ts_ltz);
      WHEN l_desc_tab(i).col_type = 181 THEN
        DBMS_SQL.define_column(l_cursor, i, l_ts_tz);
      ELSE
        DBMS_SQL.define_column(l_cursor, i, l_buffer, 32767);
    END CASE;
  END LOOP;

  IF p_query IS NOT NULL THEN
    l_rows := DBMS_SQL.execute(l_cursor);
  END IF;
  
  IF g_out_type = 'F' THEN
    l_file := UTL_FILE.fopen(p_dir, p_file, 'w', 32767);
  END IF;

  -- Output the column names.
  FOR i IN 1 .. l_col_cnt LOOP
    IF i > 1 THEN
      put(l_file, g_sep);
    END IF;
    put(l_file, l_desc_tab(i).col_name);
  END LOOP;
  new_line(l_file);

  -- Output the data.
  LOOP
    EXIT WHEN DBMS_SQL.fetch_rows(l_cursor) = 0;

    FOR i IN 1 .. l_col_cnt LOOP
      IF i > 1 THEN
        put(l_file, g_sep);
      END IF;

      -- Reset flags.
      l_is_date   := FALSE;
      l_is_ts     := FALSE;
      l_is_ts_ltz := FALSE;
      l_is_ts_tz  := FALSE;
      l_is_str    := FALSE;

      dbms_output.put_line('Before : ' || l_desc_tab(i).col_type);

      -- Check if this is a date column.
      IF l_desc_tab(i).col_type = DBMS_TYPES.typecode_date THEN
        dbms_output.put_line('DATE : ' || l_desc_tab(i).col_type);
        l_is_date := TRUE;
        l_is_str := TRUE;
      END IF;

      -- Check if this is a timestamp column.
      IF l_desc_tab(i).col_type = 180  THEN
        dbms_output.put_line('TIMESTAMP : ' || l_desc_tab(i).col_type);
        l_is_ts := TRUE;
        l_is_str := TRUE;
      END IF;

      -- Check if this is a timestamp with local time zone column.
      IF l_desc_tab(i).col_type = 231  THEN
        dbms_output.put_line('TIMESTAMP WITH LOCAL TIME ZONE: ' || l_desc_tab(i).col_type);
        l_is_ts_ltz := TRUE;
        l_is_str := TRUE;
      END IF;

      -- Check if this is a timestamp with time zone column.
      IF l_desc_tab(i).col_type = 181  THEN
        dbms_output.put_line('TIMESTAMP WITH TIME ZONE: ' || l_desc_tab(i).col_type);
        l_is_ts_tz := TRUE;
        l_is_str := TRUE;
      END IF;

      -- Check if this is a string column.
      IF l_desc_tab(i).col_type IN (DBMS_TYPES.typecode_varchar,
                                    DBMS_TYPES.typecode_varchar2,
                                    DBMS_TYPES.typecode_char,
                                    DBMS_TYPES.typecode_clob,
                                    DBMS_TYPES.typecode_nvarchar2,
                                    DBMS_TYPES.typecode_nchar,
                                    DBMS_TYPES.typecode_nclob) THEN
        dbms_output.put_line('STRING : ' || l_desc_tab(i).col_type);
        l_is_str := TRUE;
      END IF;

      -- Get the value into the buffer in the correct format.
      CASE
        WHEN l_is_date THEN
          DBMS_SQL.COLUMN_VALUE(l_cursor, i, l_date);
          l_buffer := to_char(l_date, g_date_format);
        WHEN l_is_ts THEN
          DBMS_SQL.COLUMN_VALUE(l_cursor, i, l_ts);
          l_buffer := to_char(l_ts, g_ts_format);
        WHEN l_is_ts_ltz THEN
          DBMS_SQL.COLUMN_VALUE(l_cursor, i, l_ts_ltz);
          l_buffer := to_char(l_ts_ltz, g_ts_ltz_format);
        WHEN l_is_ts_tz THEN
          DBMS_SQL.COLUMN_VALUE(l_cursor, i, l_ts_tz);
          l_buffer := to_char(l_ts_tz, g_ts_tz_format);
        ELSE
          DBMS_SQL.COLUMN_VALUE(l_cursor, i, l_buffer);
      END CASE;

      -- Optionally add quotes for strings.
      IF g_add_quotes AND l_is_str THEN
        -- Optionally escape the quote character and the escape character in the string.
        IF g_escape THEN
          l_buffer := replace(l_buffer, '\', '\\');
          l_buffer := replace(l_buffer, g_quote_char, '\'||g_quote_char);
        END IF;
        l_buffer := g_quote_char || l_buffer || g_quote_char;
      END IF;

      -- Write the buffer to the file.
      put(l_file, l_buffer);
    END LOOP;
    new_line(l_file);
  END LOOP;

  IF UTL_FILE.is_open(l_file) THEN
    UTL_FILE.fclose(l_file);
  END IF;
  DBMS_SQL.close_cursor(l_cursor);
EXCEPTION
  WHEN OTHERS THEN
    IF UTL_FILE.is_open(l_file) THEN
      UTL_FILE.fclose(l_file);
    END IF;
    IF DBMS_SQL.is_open(l_cursor) THEN
      DBMS_SQL.close_cursor(l_cursor);
    END IF;
    DBMS_OUTPUT.put_line('ERROR: ' || DBMS_UTILITY.format_error_backtrace);
    RAISE;
END generate_all;


-- Alter separator from default.
PROCEDURE set_separator (p_sep  IN  VARCHAR2) AS
BEGIN
  g_sep := p_sep;
END set_separator;


-- Alter date format from default.
PROCEDURE set_date_format (p_date_format  IN  VARCHAR2) AS
BEGIN
  g_date_format := p_date_format;
END set_date_format;


-- Alter timestamp format from default.
PROCEDURE set_ts_format (p_ts_format  IN  VARCHAR2) AS
BEGIN
  g_ts_format := p_ts_format;
END set_ts_format;


-- Alter timestamp with local timezone format from default.
PROCEDURE set_ts_ltz_format (p_ts_ltz_format  IN  VARCHAR2) AS
BEGIN
  g_ts_ltz_format := p_ts_ltz_format;
END set_ts_ltz_format;


-- Alter timestamp with timezone format from default.
PROCEDURE set_ts_tz_format (p_ts_tz_format  IN  VARCHAR2) AS
BEGIN
  g_ts_tz_format := p_ts_tz_format;
END set_ts_tz_format;


-- Alter separator from default.
PROCEDURE set_quotes (p_add_quotes  IN  BOOLEAN := TRUE,
                      p_quote_char  IN  VARCHAR2 := '"',
                      p_escape      IN  BOOLEAN := TRUE) AS
BEGIN
  g_add_quotes := NVL(p_add_quotes, TRUE);
  g_quote_char := NVL(SUBSTR(p_quote_char,1,1), '"');
  g_escape     := NVL(p_escape, TRUE);
END set_quotes;


-- Handle put to file or screen.
PROCEDURE put (p_file  IN  UTL_FILE.file_type,
               p_text  IN  VARCHAR2) AS
BEGIN
  IF g_out_type = 'F' THEN
    UTL_FILE.put(p_file, p_text);
  ELSE
    DBMS_OUTPUT.put(p_text);
  END IF;
END put;


-- Handle newline to file or screen.
PROCEDURE new_line (p_file  IN  UTL_FILE.file_type) AS
BEGIN
  IF g_out_type = 'F' THEN
    UTL_FILE.new_line(p_file);
  ELSE
    DBMS_OUTPUT.new_line;
  END IF;
END new_line;

END csv;
/
SHOW ERRORS