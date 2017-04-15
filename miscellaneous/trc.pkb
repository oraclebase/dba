CREATE OR REPLACE PACKAGE BODY trc AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/trc.pkb
-- Author       : Tim Hall
-- Description  : A simple mechanism for tracing information to a table.
-- Requirements : trc.pks, dsp.pks, dsp.pkb and schema definied in trc.pks
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   08-JAN-2002  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

  -- Package Variables
  g_trace_on     BOOLEAN      := FALSE;
  g_date_format  VARCHAR2(50) := 'DD-MON-YYYY HH24:MI:SS';

  -- Exposed Methods

  -- --------------------------------------------------------------------------
  PROCEDURE reset_defaults IS         
  -- --------------------------------------------------------------------------
  BEGIN
    g_trace_on     := FALSE;
    g_date_format  := 'DD-MON-YYYY HH24:MI:SS';
  END;
  -- --------------------------------------------------------------------------


  -- --------------------------------------------------------------------------
  PROCEDURE trace_on IS
  -- --------------------------------------------------------------------------
  BEGIN
    g_trace_on := TRUE;
  END;
  -- --------------------------------------------------------------------------

  
  -- --------------------------------------------------------------------------
  PROCEDURE trace_off IS
  -- --------------------------------------------------------------------------
  BEGIN
    g_trace_on := FALSE;
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
  PROCEDURE line (p_prefix     IN  VARCHAR2,
                  p_data       IN  VARCHAR2,
                  p_trc_level  IN  NUMBER   DEFAULT 5,
                  p_trc_user   IN  VARCHAR2 DEFAULT USER) IS
  -- --------------------------------------------------------------------------
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    IF g_trace_on THEN
      INSERT INTO trace_data
      (id,
       prefix,
       data,
       trc_level,
       created_date,
       created_by)
      VALUES
      (trc_seq.nextval,
       p_prefix,
       p_data,
       p_trc_level,
       Sysdate,
       p_trc_user);
       
      COMMIT;
    END IF;
  END;
  -- --------------------------------------------------------------------------
    

  -- --------------------------------------------------------------------------
  PROCEDURE display (p_trc_level  IN  NUMBER   DEFAULT NULL,
                     p_trc_user   IN  VARCHAR2 DEFAULT NULL,
                     p_from_date  IN  DATE     DEFAULT NULL,
                     p_to_date    IN  DATE     DEFAULT NUll) IS
  -- --------------------------------------------------------------------------
    CURSOR c_trace IS
      SELECT *
      FROM   trace_data
      WHERE  trc_level     = NVL(p_trc_level, trc_level)
      AND    created_by    = NVL(p_trc_user, created_by)
      AND    created_date >= NVL(p_from_date, created_date)
      AND    created_date <= NVL(p_to_date, created_date)
      ORDER BY id;
  BEGIN
    FOR cur_rec IN c_trace LOOP
      dsp.line(cur_rec.prefix, cur_rec.data);
    END LOOP;
  END;
  -- --------------------------------------------------------------------------
  
END trc;
/

SHOW ERRORS

