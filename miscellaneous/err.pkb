CREATE OR REPLACE PACKAGE BODY err AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/err.pkb
-- Author       : Tim Hall
-- Description  : A simple mechanism for logging error information to a table.
-- Requirements : err.pks, dsp.pks, dsp.pkb and schema definied in err.pks
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   17-JUL-2003  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

  -- Package Variables
  g_logs_on     BOOLEAN      := TRUE;
  g_date_format  VARCHAR2(50) := 'DD-MON-YYYY HH24:MI:SS';

  -- Exposed Methods

  -- --------------------------------------------------------------------------
  PROCEDURE reset_defaults IS
  -- --------------------------------------------------------------------------
  BEGIN
    g_logs_on      := TRUE;
    g_date_format  := 'DD-MON-YYYY HH24:MI:SS';
  END;
  -- --------------------------------------------------------------------------


  -- --------------------------------------------------------------------------
  PROCEDURE logs_on IS
  -- --------------------------------------------------------------------------
  BEGIN
    g_logs_on := TRUE;
  END;
  -- --------------------------------------------------------------------------


  -- --------------------------------------------------------------------------
  PROCEDURE logs_off IS
  -- --------------------------------------------------------------------------
  BEGIN
    g_logs_on := FALSE;
  END;
  -- --------------------------------------------------------------------------


  -- --------------------------------------------------------------------------
  PROCEDURE set_date_format (p_date_format IN VARCHAR2 DEFAULT 'DD-MON-YYYY HH24:MI:SS') IS
  -- --------------------------------------------------------------------------
  BEGIN
    g_date_format := p_date_format;
  END;
  -- --------------------------------------------------------------------------


  -- --------------------------------------------------------------------------
  PROCEDURE line (p_prefix       IN  VARCHAR2,
                  p_data         IN  VARCHAR2,
                  p_error_level  IN  NUMBER   DEFAULT 5,
                  p_error_user   IN  VARCHAR2 DEFAULT USER) IS
  -- --------------------------------------------------------------------------
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    IF g_logs_on THEN
      INSERT INTO error_logs
      (id,
       prefix,
       data,
       error_level,
       created_date,
       created_by)
      VALUES
      (error_logs_seq.NEXTVAL,
       p_prefix,
       p_data,
       p_error_level,
       SYSDATE,
       p_error_user);

      COMMIT;
    END IF;
  END;
  -- --------------------------------------------------------------------------


  -- --------------------------------------------------------------------------
  PROCEDURE line (p_data         IN  VARCHAR2,
                  p_error_level  IN  NUMBER   DEFAULT 5,
                  p_error_user   IN  VARCHAR2 DEFAULT USER) IS
  -- --------------------------------------------------------------------------
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    line (p_prefix       => NULL,
          p_data         => p_data,
          p_error_level  => p_error_level,
          p_error_user   => p_error_user);
  END;
  -- --------------------------------------------------------------------------


  -- --------------------------------------------------------------------------
  PROCEDURE display (p_error_level  IN  NUMBER   DEFAULT NULL,
                     p_error_user   IN  VARCHAR2 DEFAULT NULL,
                     p_from_date    IN  DATE     DEFAULT NULL,
                     p_to_date      IN  DATE     DEFAULT NUll) IS
  -- --------------------------------------------------------------------------
    CURSOR c_errors IS
      SELECT *
      FROM   error_logs
      WHERE  error_level   = NVL(p_error_level, error_level)
      AND    created_by    = NVL(p_error_user, created_by)
      AND    created_date >= NVL(p_from_date, created_date)
      AND    created_date <= NVL(p_to_date, created_date)
      ORDER BY id;
  BEGIN
    FOR cur_rec IN c_errors LOOP
      dsp.line(cur_rec.prefix, cur_rec.data);
    END LOOP;
  END;
  -- --------------------------------------------------------------------------

END err;
/

SHOW ERRORS

