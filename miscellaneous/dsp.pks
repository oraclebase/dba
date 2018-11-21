CREATE OR REPLACE PACKAGE dsp AUTHID CURRENT_USER AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/dsp.pks
-- Author       : Tim Hall
-- Description  : An extension of the DBMS_OUTPUT package.
-- Requirements : https://oracle-base.com/dba/miscellaneous/dsp.pkb
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   08-JAN-2002  Tim Hall  Initial Creation
--   04-APR-2005  Tim Hall  Store last call. Add get_last_prefix and
--                          get_last_data to allow retrieval.
--                          Switch from date to timestamp for greater accuracy.
--   02-MAR-2013  Tim Hall  Added file_contents pipelined table function.
--                          Added delete_file.
--                          Added example usage comments.
--   02-DEC-2013  Tim Hall  Add p_trace_level parameter to most code to
--                          limit amount of trace produced.
--                          Added "AUTHID CURRENT_USER".
--   21-NOV-2018  Tim Hall  Add CLOB overloads to LINE.
-- --------------------------------------------------------------------------
-- Example usage :
/*
-- Set up test directory object.
CREATE OR REPLACE DIRECTORY test_dir AS '/home/oracle/';
GRANT READ, WRITE ON DIRECTORY test_dir TO test;

-- Test DSP.
BEGIN
  -- Turn on tracing, redirecting it to a file.
  DSP.show_output_on;
  DSP.file_output_on('TEST_DIR', 'test.txt');
  DSP.show_date_on;
  DSP.line_wrap_on;
  DSP.set_max_width(200);

  -- Trace something.
  DSP.line('This is a test');
END;

-- Check the contents of the file.
SELECT * FROM TABLE(DSP.file_contents('TEST_DIR', 'test.txt'));

-- Delete the file.
EXEC DSP.delete_file('TEST_DIR', 'test.txt');
*/
-- --------------------------------------------------------------------------

  -- Constants to control tracing level.
  trace_level_all   CONSTANT PLS_INTEGER := 99;
  trace_level_info  CONSTANT PLS_INTEGER := 30;
  trace_level_warn  CONSTANT PLS_INTEGER := 20;
  trace_level_error CONSTANT PLS_INTEGER := 10;

  PROCEDURE reset_defaults;

  PROCEDURE show_output_on(p_trace_level  IN  PLS_INTEGER := DSP.trace_level_all);
  PROCEDURE show_output_off;

  PROCEDURE show_date_on;
  PROCEDURE show_date_off;

  PROCEDURE line_wrap_on;
  PROCEDURE line_wrap_off;

  PROCEDURE set_max_width (p_width  IN  PLS_INTEGER);

  PROCEDURE set_date_format (p_date_format  IN  VARCHAR2);

  PROCEDURE file_output_on (p_file_dir   IN  VARCHAR2 DEFAULT NULL,
                            p_file_name  IN  VARCHAR2 DEFAULT NULL);

  PROCEDURE file_output_off;

  FUNCTION get_last_prefix
    RETURN VARCHAR2;

  FUNCTION get_last_data
    RETURN VARCHAR2;

  PROCEDURE line (p_data         IN  VARCHAR2,
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  PROCEDURE line (p_data         IN  CLOB,
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  PROCEDURE line (p_data         IN  NUMBER,
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  PROCEDURE line (p_data         IN  BOOLEAN,
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  PROCEDURE line (p_data         IN  DATE,
                  p_format       IN  VARCHAR2 DEFAULT 'DD-MON-YYYY HH24:MI:SS.FF',
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  PROCEDURE line (p_prefix       IN  VARCHAR2,
                  p_data         IN  VARCHAR2,
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  PROCEDURE line (p_prefix       IN  VARCHAR2,
                  p_data         IN  CLOB,
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  PROCEDURE line (p_prefix       IN  VARCHAR2,
                  p_data         IN  NUMBER,
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  PROCEDURE line (p_prefix       IN  VARCHAR2,
                  p_data         IN  BOOLEAN,
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  PROCEDURE line (p_prefix       IN  VARCHAR2,
                  p_data         IN  DATE,
                  p_format       IN  VARCHAR2 DEFAULT 'DD-MON-YYYY HH24:MI:SS.FF',
                  p_trace_level  IN  PLS_INTEGER := DSP.trace_level_info);

  FUNCTION file_contents (p_dir  IN VARCHAR2,
                          p_file IN VARCHAR2)
    RETURN DBMSOUTPUT_LINESARRAY PIPELINED;

  PROCEDURE delete_file (p_dir  IN VARCHAR2,
                         p_file IN VARCHAR2);

END dsp;
/

SHOW ERRORS
