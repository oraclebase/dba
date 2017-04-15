CREATE OR REPLACE PACKAGE csv AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/cvs.sql
-- Author       : Tim Hall
-- Description  : Basic CSV API. For usage notes see:
--                  https://oracle-base.com/articles/9i/GeneratingCSVFiles.php
--
--                  CREATE OR REPLACE DIRECTORY dba_dir AS '/u01/app/oracle/dba/';
--                  ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS';
--
--                  EXEC csv.generate('DBA_DIR', 'generate.csv', p_query => 'SELECT * FROM emp');
--
-- Requirements : UTL_FILE, DBMS_SQL
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   14-MAY-2005  Tim Hall  Initial Creation
--   19-MAY-2016  Tim Hall  Add REF CURSOR support.
-- --------------------------------------------------------------------------

PROCEDURE generate (p_dir        IN  VARCHAR2,
                    p_file       IN  VARCHAR2,
                    p_query      IN  VARCHAR2);

PROCEDURE generate_rc (p_dir        IN  VARCHAR2,
                       p_file       IN  VARCHAR2,
                       p_refcursor  IN OUT SYS_REFCURSOR);

PROCEDURE set_separator (p_sep  IN  VARCHAR2);

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
--                  ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS';
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
-- --------------------------------------------------------------------------

g_sep         VARCHAR2(5)  := ',';

-- Prototype for hidden procedure.
PROCEDURE generate_all (p_dir        IN  VARCHAR2,
                        p_file       IN  VARCHAR2,
                        p_query      IN  VARCHAR2,
                        p_refcursor  IN OUT SYS_REFCURSOR);


-- Stub to generate a CSV from a query.
PROCEDURE generate (p_dir        IN  VARCHAR2,
                    p_file       IN  VARCHAR2,
                    p_query      IN  VARCHAR2) AS
  l_cursor  SYS_REFCURSOR;
BEGIN
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
  generate_all (p_dir        => p_dir,
                p_file       => p_file,
                p_query      => NULL,
                p_refcursor  => p_refcursor);
END generate_rc;


-- Do the actual work.
PROCEDURE generate_all (p_dir        IN  VARCHAR2,
                        p_file       IN  VARCHAR2,
                        p_query      IN  VARCHAR2,
                        p_refcursor  IN OUT  SYS_REFCURSOR) AS
  l_cursor    PLS_INTEGER;
  l_rows      PLS_INTEGER;
  l_col_cnt   PLS_INTEGER;
  l_desc_tab  DBMS_SQL.desc_tab;
  l_buffer    VARCHAR2(32767);

  l_file      UTL_FILE.file_type;
BEGIN
  IF p_query IS NOT NULL THEN
    l_cursor := DBMS_SQL.open_cursor;
    DBMS_SQL.parse(l_cursor, p_query, DBMS_SQL.native);
  ELSIF p_refcursor%ISOPEN THEN
     l_cursor := DBMS_SQL.to_cursor_number(p_refcursor);
  ELSE
    RAISE_APPLICATION_ERROR(-20000, 'You must specify a query or a REF CURSOR.');
  END IF;
  
  DBMS_SQL.describe_columns (l_cursor, l_col_cnt, l_desc_tab);

  FOR i IN 1 .. l_col_cnt LOOP
    DBMS_SQL.define_column(l_cursor, i, l_buffer, 32767 );
  END LOOP;

  IF p_query IS NOT NULL THEN
    l_rows := DBMS_SQL.execute(l_cursor);
  END IF;
  
  l_file := UTL_FILE.fopen(p_dir, p_file, 'w', 32767);

  -- Output the column names.
  FOR i IN 1 .. l_col_cnt LOOP
    IF i > 1 THEN
      UTL_FILE.put(l_file, g_sep);
    END IF;
    UTL_FILE.put(l_file, l_desc_tab(i).col_name);
  END LOOP;
  UTL_FILE.new_line(l_file);

  -- Output the data.
  LOOP
    EXIT WHEN DBMS_SQL.fetch_rows(l_cursor) = 0;

    FOR i IN 1 .. l_col_cnt LOOP
      IF i > 1 THEN
        UTL_FILE.put(l_file, g_sep);
      END IF;

      DBMS_SQL.COLUMN_VALUE(l_cursor, i, l_buffer);
      UTL_FILE.put(l_file, l_buffer);
    END LOOP;
    UTL_FILE.new_line(l_file);
  END LOOP;

  UTL_FILE.fclose(l_file);
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

END csv;
/
SHOW ERRORS
