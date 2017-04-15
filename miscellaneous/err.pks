CREATE OR REPLACE PACKAGE err AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/err.pks
-- Author       : Tim Hall
-- Description  : A simple mechanism for logging error information to a table.
-- Requirements : err.pkb, dsp.pks, dsp.pkb and:
--
-- CREATE TABLE error_logs (
-- id           NUMBER(10)      NOT NULL,
-- prefix       VARCHAR2(50),
-- data         VARCHAR2(2000)  NOT NULL,
-- error_level  NUMBER(2)       NOT NULL,
-- created_date DATE            NOT NULL,
-- created_by   VARCHAR2(50)    NOT NULL);
--
-- ALTER TABLE error_logs ADD (CONSTRAINT error_logs_pk PRIMARY KEY (id));
--
-- CREATE SEQUENCE error_logs_seq;
--
-- Ammedments  :
--   When         Who       What
--   ===========  ========  =================================================
--   17-JUL-2003  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

  PROCEDURE reset_defaults;

  PROCEDURE logs_on;
  PROCEDURE logs_off;

  PROCEDURE set_date_format (p_date_format IN VARCHAR2 DEFAULT 'DD-MON-YYYY HH24:MI:SS');

  PROCEDURE line (p_prefix       IN  VARCHAR2,
                  p_data         IN  VARCHAR2,
                  p_error_level  IN  NUMBER   DEFAULT 5,
                  p_error_user   IN  VARCHAR2 DEFAULT USER);

  PROCEDURE line (p_data         IN  VARCHAR2,
                  p_error_level  IN  NUMBER   DEFAULT 5,
                  p_error_user   IN  VARCHAR2 DEFAULT USER);

  PROCEDURE display (p_error_level  IN  NUMBER   DEFAULT NULL,
                     p_error_user   IN  VARCHAR2 DEFAULT NULL,
                     p_from_date    IN  DATE     DEFAULT NULL,
                     p_to_date      IN  DATE     DEFAULT NUll);
END err;
/

SHOW ERRORS

