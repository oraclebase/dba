CREATE OR REPLACE PACKAGE smart_quotes_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/smart_quotes_api.sql
-- Author       : Tim Hall
-- Description  : Routines to help deal with smart quotes..
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   07-JUN-2017  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

FUNCTION contains_smart_quote_bool (p_clob IN CLOB) RETURN BOOLEAN;
FUNCTION contains_smart_quote_bool (p_text IN VARCHAR2) RETURN BOOLEAN;
FUNCTION contains_smart_quote_num (p_clob IN CLOB) RETURN NUMBER;
FUNCTION contains_smart_quote_num (p_text IN VARCHAR2) RETURN NUMBER;

PROCEDURE remove_smart_quotes (p_clob IN OUT NOCOPY CLOB);
PROCEDURE remove_smart_quotes (p_text IN OUT VARCHAR2);
FUNCTION  remove_smart_quotes (p_clob IN CLOB) RETURN CLOB;
FUNCTION  remove_smart_quotes (p_text IN VARCHAR2) RETURN VARCHAR2;

END smart_quotes_api;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY smart_quotes_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/smart_quotes_api.sql
-- Author       : Tim Hall
-- Description  : Routines to help deal with smart quotes..
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   07-JUN-2017  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

TYPE t_sq_arr IS TABLE OF VARCHAR2(10)
  INDEX BY VARCHAR2 (10);

g_sq_arr t_sq_arr;


-- --------------------------------------------------------------------------
FUNCTION contains_smart_quote_bool (p_clob IN CLOB) RETURN BOOLEAN AS
  l_idx VARCHAR2(10);
BEGIN
  l_idx := g_sq_arr.FIRST;

  WHILE l_idx IS NOT NULL LOOP
    IF INSTR(p_clob, l_idx) > 0 THEN
      RETURN TRUE;
    END IF;
    l_idx := g_sq_arr.NEXT(l_idx);
  END LOOP display_loop;

  RETURN FALSE;
END contains_smart_quote_bool;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
FUNCTION contains_smart_quote_bool (p_text IN VARCHAR2) RETURN BOOLEAN AS
  l_idx VARCHAR2(10);
BEGIN
  l_idx := g_sq_arr.FIRST;

  WHILE l_idx IS NOT NULL LOOP
    IF INSTR(p_text, l_idx) > 0 THEN
      RETURN TRUE;
    END IF;
    l_idx := g_sq_arr.NEXT(l_idx);
  END LOOP display_loop;

  RETURN FALSE;
END contains_smart_quote_bool;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
FUNCTION contains_smart_quote_num (p_clob IN CLOB) RETURN NUMBER AS
BEGIN
  IF contains_smart_quote_bool (p_clob => p_clob) = TRUE THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END contains_smart_quote_num;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
FUNCTION contains_smart_quote_num (p_text IN VARCHAR2) RETURN NUMBER AS
BEGIN
  IF contains_smart_quote_bool (p_text => p_text) = TRUE THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END contains_smart_quote_num;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
PROCEDURE remove_smart_quotes (p_clob IN OUT NOCOPY CLOB) AS
-- --------------------------------------------------------------------------
  l_idx VARCHAR2(10);
BEGIN
  l_idx := g_sq_arr.FIRST;

  WHILE l_idx IS NOT NULL LOOP
    p_clob := REPLACE(p_clob, l_idx, g_sq_arr(l_idx));
    l_idx := g_sq_arr.NEXT(l_idx);
  END LOOP display_loop;
END remove_smart_quotes;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
PROCEDURE remove_smart_quotes (p_text IN OUT VARCHAR2) AS
-- --------------------------------------------------------------------------
  l_idx VARCHAR2(10);
BEGIN
  l_idx := g_sq_arr.FIRST;

  WHILE l_idx IS NOT NULL LOOP
    p_text := REPLACE(p_text, l_idx, g_sq_arr(l_idx));
    l_idx := g_sq_arr.NEXT(l_idx);
  END LOOP display_loop;
END remove_smart_quotes;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
FUNCTION remove_smart_quotes (p_clob IN CLOB) RETURN CLOB AS
-- --------------------------------------------------------------------------
  l_clob CLOB;
BEGIN
  l_clob := p_clob;
  remove_smart_quotes (p_clob => l_clob);
  RETURN l_clob;
END remove_smart_quotes;
-- --------------------------------------------------------------------------



-- --------------------------------------------------------------------------
FUNCTION remove_smart_quotes (p_text IN VARCHAR2) RETURN VARCHAR2 AS
-- --------------------------------------------------------------------------
  l_text VARCHAR2(32767);
BEGIN
  l_text := p_text;
  remove_smart_quotes (p_text => l_text);
  RETURN l_text;
END remove_smart_quotes;
-- --------------------------------------------------------------------------


BEGIN
  -- Initialise Array of Smart Quotes.
  -- Array Index = Smart Quote.
  -- Array Value = Replacement Value.
  g_sq_arr(CHR(145)) := '''';
  g_sq_arr(CHR(146)) := '''';
  --g_sq_arr(CHR(8216)) := '''';
  --g_sq_arr(CHR(8217)) := '''';

  g_sq_arr(CHR(147)) := '"';
  g_sq_arr(CHR(148)) := '"';
  g_sq_arr(CHR(8220)) := '"';
  g_sq_arr(CHR(8221)) := '"';

  g_sq_arr(CHR(151)) := '--';
  g_sq_arr(CHR(150)) := '-';
  g_sq_arr(CHR(133)) := '...';
  g_sq_arr(CHR(149)) := CHR(38)||'bull;';

  g_sq_arr(CHR(49855)) := '-';
  g_sq_arr(CHR(50578)) := CHR(38)||'OElig;';
  g_sq_arr(CHR(50579)) := CHR(38)||'oelig;';
  g_sq_arr(CHR(50592)) := 'S';
  g_sq_arr(CHR(50593)) := 's';
  g_sq_arr(CHR(50616)) := 'Y';
  g_sq_arr(CHR(50834)) := 'f';
  g_sq_arr(CHR(52102)) := '^';
  g_sq_arr(CHR(52124)) := '~';
  g_sq_arr(CHR(14844051)) := '-';
  g_sq_arr(CHR(14844052)) := '-';
  g_sq_arr(CHR(14844053)) := '-';
  g_sq_arr(CHR(14844056)) := '''';
  g_sq_arr(CHR(14844057)) := '''';
  g_sq_arr(CHR(14844058)) := ',';
  g_sq_arr(CHR(14844060)) := '"';
  g_sq_arr(CHR(14844061)) := '"';
  g_sq_arr(CHR(14844062)) := '"';
  g_sq_arr(CHR(14844064)) := CHR(38)||'dagger;';
  g_sq_arr(CHR(14844064)) := CHR(38)||'Dagger;';
  g_sq_arr(CHR(14844066)) := '.';
  g_sq_arr(CHR(14844070)) := '...';
  g_sq_arr(CHR(14844080)) := CHR(38)||'permil;';
  g_sq_arr(CHR(14844089)) := '<';
  g_sq_arr(CHR(14844090)) := '>';
  g_sq_arr(CHR(14845090)) := CHR(38)||'trade;';

END smart_quotes_api;
/
SHOW ERRORS
