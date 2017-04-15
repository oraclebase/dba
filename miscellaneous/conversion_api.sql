CREATE OR REPLACE PACKAGE conversion_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/conversion_api.sql
-- Author       : Tim Hall
-- Description  : Provides some base conversion functions.
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   10-SEP-2003  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

FUNCTION to_base(p_dec   IN  NUMBER,
                 p_base  IN  NUMBER) RETURN VARCHAR2;

FUNCTION to_dec (p_str        IN  VARCHAR2,
                 p_from_base  IN  NUMBER DEFAULT 16) RETURN NUMBER;

FUNCTION to_hex(p_dec  IN  NUMBER) RETURN VARCHAR2;

FUNCTION to_bin(p_dec  IN  NUMBER) RETURN VARCHAR2;

FUNCTION to_oct(p_dec  IN  NUMBER) RETURN VARCHAR2;

END conversion_api;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY conversion_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/conversion_api.sql
-- Author       : Tim Hall
-- Description  : Provides some base conversion functions.
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   10-SEP-2003  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
FUNCTION to_base(p_dec   IN  NUMBER,
                 p_base  IN  NUMBER) RETURN VARCHAR2 IS
-- ----------------------------------------------------------------------------
	l_str	VARCHAR2(255) DEFAULT NULL;
	l_num	NUMBER	      DEFAULT p_dec;
	l_hex	VARCHAR2(16)  DEFAULT '0123456789ABCDEF';
BEGIN
	IF (TRUNC(p_dec) <> p_dec OR p_dec < 0) THEN
		RAISE PROGRAM_ERROR;
	END IF;
	LOOP
		l_str := SUBSTR(l_hex, MOD(l_num,p_base)+1, 1) || l_str;
		l_num := TRUNC(l_num/p_base);
		EXIT WHEN (l_num = 0);
	END LOOP;
	RETURN l_str;
END to_base;
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
FUNCTION to_dec (p_str        IN  VARCHAR2,
                 p_from_base  IN  NUMBER DEFAULT 16) RETURN NUMBER IS
-- ----------------------------------------------------------------------------
	l_num   NUMBER       DEFAULT 0;
	l_hex   VARCHAR2(16) DEFAULT '0123456789ABCDEF';
BEGIN
	FOR i IN 1 .. LENGTH(p_str) LOOP
		l_num := l_num * p_from_base + INSTR(l_hex,UPPER(SUBSTR(p_str,i,1)))-1;
	END LOOP;
	RETURN l_num;
END to_dec;
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
FUNCTION to_hex(p_dec  IN  NUMBER) RETURN VARCHAR2 IS
-- ----------------------------------------------------------------------------
BEGIN
	RETURN to_base(p_dec, 16);
END to_hex;
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
FUNCTION to_bin(p_dec  IN  NUMBER) RETURN VARCHAR2 IS
-- ----------------------------------------------------------------------------
BEGIN
	RETURN to_base(p_dec, 2);
END to_bin;
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
FUNCTION to_oct(p_dec  IN  NUMBER) RETURN VARCHAR2 IS
-- ----------------------------------------------------------------------------
BEGIN
	RETURN to_base(p_dec, 8);
END to_oct;
-- ----------------------------------------------------------------------------

END conversion_api;
/
SHOW ERRORS
