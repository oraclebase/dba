CREATE OR REPLACE PACKAGE date_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/date_api.sql
-- Author       : Tim Hall
-- Description  : A package to hold date utilities.
-- Requirements : 
-- Amendments   :
--   When         Who       What
--   ===========  ========  =================================================
--   04-FEB-2015  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

FUNCTION oracle_to_unix (p_date IN DATE) RETURN NUMBER;
FUNCTION unix_to_oracle (p_unix IN NUMBER) RETURN DATE;

END date_api;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY date_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/date_api.sql
-- Author       : Tim Hall
-- Description  : A package to hold date utilities.
-- Requirements : 
-- Amendments   :
--   When         Who       What
--   ===========  ========  =================================================
--   04-FEB-2015  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

FUNCTION oracle_to_unix (p_date IN DATE) RETURN NUMBER AS
  l_number NUMBER;
BEGIN
  l_number := (p_date - TO_DATE('01/01/1970', 'DD/MM/YYYY'));
  RETURN  l_number * 86400000;
END oracle_to_unix;

FUNCTION unix_to_oracle (p_unix IN NUMBER) RETURN DATE AS
BEGIN
  RETURN TO_DATE('01/01/1970', 'DD/MM/YYYY') + (p_unix * 86400000);
END unix_to_oracle;

END date_api;
/
SHOW ERRORS
