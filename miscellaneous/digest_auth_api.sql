CREATE OR REPLACE PACKAGE digest_auth_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/digest_auth_api.sql
-- Author       : Tim Hall
-- Description  : API to allow digest authentication when using UTL_HTTP.
--                The aim is this only replaces UTL_HTTP.BEGIN_REQUEST.
--                All other coding (wallet handling and processing the response)
--                are still done by you, in the normal way.
--
-- References   : This is heavily inspired by the blog post by Gary Myers.
--                http://blog.sydoracle.com/2014/03/plsql-utlhttp-and-digest-authentication.html
--                I make liberal use of the ideas, and in some cases the code, he discussed in
--                that blog post!
--                For setting up certificates and wallets, see this article.
--                https://oracle-base.com/articles/misc/utl_http-and-ssl
--
-- License      : Free for personal and commercial use.
--                You can amend the code, but leave existing the headers, current
--                amendments history and links intact.
--                Copyright and disclaimer available here:
--                https://oracle-base.com/misc/site-info.php#copyright
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   11-DEC-2015  Tim Hall  Initial Creation
--   30-JUN-2016  Tim Hall  Add debug_on and debug_off procedures.
-- --------------------------------------------------------------------------

/*
Example call.

SET SERVEROUTPUT ON
DECLARE
  l_url            VARCHAR2(32767) := 'https://example.com/ws/get-something';
  l_http_request   UTL_HTTP.req;
  l_http_response  UTL_HTTP.resp;
  l_text           VARCHAR2(32767);
BEGIN
  -- Set wallet credentials.
  UTL_HTTP.set_wallet('file:/path/to/wallet', 'wallet-password');

  -- Make a HTTP request and get the response.
  l_http_request  := digest_auth_api.begin_request(p_url          => l_url,
                                                   p_username     => 'my-username',
                                                   p_password     => 'my-password',
                                                   p_method       => 'GET');

  l_http_response := UTL_HTTP.get_response(l_http_request);

  -- Loop through the response.
  BEGIN
    LOOP
      UTL_HTTP.read_text(l_http_response, l_text, 32767);
      DBMS_OUTPUT.put_line (l_text);
    END LOOP;
  EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(l_http_response);
  END;

EXCEPTION
  WHEN OTHERS THEN
    UTL_HTTP.end_response(l_http_response);
    RAISE;
END;

*/
-- --------------------------------------------------------------------------

PROCEDURE debug_on;

PROCEDURE debug_off;

FUNCTION begin_request(p_url          IN VARCHAR2,
                       p_username     IN VARCHAR2,
                       p_password     IN VARCHAR2,
                       p_method       IN VARCHAR2 DEFAULT 'GET',
                       p_http_version IN VARCHAR2 DEFAULT 'HTTP/1.1',
                       p_req_cnt      IN PLS_INTEGER DEFAULT 1)
  RETURN UTL_HTTP.req;

END digest_auth_api;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY digest_auth_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/digest_auth_api.sql
-- Author       : Tim Hall
-- Description  : API to allow digest authentication when using UTL_HTTP.
--                The aim is this only replaces UTL_HTTP.BEGIN_REQUEST.
--                All other coding (wallet handling and processing the response)
--                are still done by you, in the normal way.
--
-- References   : This is heavily inspired by the blog post by Gary Myers.
--                http://blog.sydoracle.com/2014/03/plsql-utlhttp-and-digest-authentication.html
--                I make liberal use of the ideas, and in some cases the code, he discussed in
--                that blog post!
--                For setting up certificates and wallets, see this article.
--                https://oracle-base.com/articles/misc/utl_http-and-ssl
--
-- License      : Free for personal and commercial use.
--                You can amend the code, but leave existing the headers, current
--                amendments history and links intact.
--                Copyright and disclaimer available here:
--                https://oracle-base.com/misc/site-info.php#copyright
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   11-DEC-2015  Tim Hall  Initial Creation
--   30-JUN-2016  Tim Hall  Add debug_on and debug_off procedures.
-- --------------------------------------------------------------------------

-- Package variables.
g_debug   BOOLEAN := FALSE;

-- Set by call to get_header_info.
g_server  VARCHAR2(32767);
g_realm   VARCHAR2(32767);
g_qop     VARCHAR2(32767);
g_nonce   VARCHAR2(32767);
g_opaque  VARCHAR2(32767);
g_cnonce  VARCHAR2(32767);

-- Prototypes.
PROCEDURE debug (p_text IN VARCHAR2);

PROCEDURE init;

PROCEDURE get_header_info (p_http_response IN OUT NOCOPY UTL_HTTP.resp);

FUNCTION get_response (p_username IN VARCHAR2,
                       p_password IN VARCHAR2,
                       p_uri      IN VARCHAR2,
                       p_method   IN VARCHAR2 DEFAULT 'GET',
                       p_req_cnt  IN NUMBER DEFAULT 1)
RETURN VARCHAR2;



-- Real stuff starts here.

-- -----------------------------------------------------------------------------
PROCEDURE debug_on AS
BEGIN
  g_debug := TRUE;
END debug_on;
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
PROCEDURE debug_off AS
BEGIN
  g_debug := FALSE;
END debug_off;
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
PROCEDURE debug (p_text IN VARCHAR2) AS
BEGIN
  IF g_debug THEN
    DBMS_OUTPUT.put_line(p_text);
  END IF;
END debug;
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
PROCEDURE init IS
BEGIN
  g_server  := NULL;
  g_realm   := NULL;
  g_qop     := NULL;
  g_nonce   := NULL;
  g_opaque  := NULL;
  g_cnonce  := NULL;
END init;
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
PROCEDURE get_header_info (p_http_response IN OUT NOCOPY UTL_HTTP.resp) IS

  l_name            VARCHAR2(256);
  l_value           VARCHAR2(1024);
BEGIN
  FOR i IN 1..UTL_HTTP.get_header_count(p_http_response) LOOP
    UTL_HTTP.get_header(p_http_response, i, l_name, l_value);
    debug('------ Header (' || i || ') ------');
    debug('l_name=' || l_name);
    debug('l_value=' || l_value);
    IF l_name = 'Server' THEN
      g_server := l_value;
      debug('g_server=' || g_server);
    END IF;

    IF l_name = 'WWW-Authenticate' THEN
      g_realm  := SUBSTR(REGEXP_SUBSTR(l_value, 'realm="[^"]+' ),8);
      g_qop    := SUBSTR(REGEXP_SUBSTR(l_value, 'qop="[^"]+'   ),6);
      g_nonce  := SUBSTR(REGEXP_SUBSTR(l_value, 'nonce="[^"]+' ),8);
      g_opaque := SUBSTR(REGEXP_SUBSTR(l_value, 'opaque="[^"]+'),9);

      debug('g_realm=' || g_realm);
      debug('g_qop=' || g_qop);
      debug('g_nonce=' || g_nonce);
      debug('g_opaque=' || g_opaque);
    END IF;
  END LOOP;

  g_cnonce := LOWER(UTL_RAW.cast_to_raw(DBMS_OBFUSCATION_TOOLKIT.md5(input_string => DBMS_RANDOM.value)));
  debug('g_cnonce=' || g_cnonce);
END get_header_info;
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
FUNCTION get_response (p_username IN VARCHAR2,
                       p_password IN VARCHAR2,
                       p_uri      IN VARCHAR2,
                       p_method   IN VARCHAR2 DEFAULT 'GET',
                       p_req_cnt  IN NUMBER DEFAULT 1)
RETURN VARCHAR2 IS
  l_text      VARCHAR2(2000);
  l_raw       RAW(2000);
  l_out       VARCHAR2(60);
  l_ha1       VARCHAR2(40);
  l_ha2       VARCHAR2(40);
BEGIN
  l_text := p_username || ':' || g_realm || ':' || p_password;
  l_raw  := UTL_RAW.cast_to_raw(l_text);
  l_out  := DBMS_OBFUSCATION_TOOLKIT.md5(input => l_raw);
  l_ha1  := LOWER(l_out);

  l_text := p_method || ':' || p_uri;
  l_raw  := UTL_RAW.cast_to_raw(l_text);
  l_out  := DBMS_OBFUSCATION_TOOLKIT.md5(input => l_raw);
  l_ha2  := LOWER(l_out);

  l_text := l_ha1 || ':' || g_nonce || ':' || LPAD(p_req_cnt,8,0) || ':' || g_cnonce || ':' || g_qop || ':' || l_ha2;
  l_raw  := UTL_RAW.cast_to_raw(l_text);
  l_out  := DBMS_OBFUSCATION_TOOLKIT.md5(input => l_raw);

  RETURN LOWER(l_out);
END get_response;
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
FUNCTION begin_request(p_url          IN VARCHAR2,
                       p_username     IN VARCHAR2,
                       p_password     IN VARCHAR2,
                       p_method       IN VARCHAR2 DEFAULT 'GET',
                       p_http_version IN VARCHAR2 DEFAULT 'HTTP/1.1',
                       p_req_cnt      IN PLS_INTEGER DEFAULT 1)
  RETURN UTL_HTTP.req
AS
  l_http_request   UTL_HTTP.req;
  l_http_response  UTL_HTTP.resp;
  l_text           VARCHAR2(32767);
  l_uri            VARCHAR2(32767);
  l_response       VARCHAR2(32767);
BEGIN
  init;

  -- Make a request that will fail to get the header information.
  -- This will be used to build up the pieces for the digest authentication
  -- using a call to get_header_info.
  l_http_request  := UTL_HTTP.begin_request(p_url, p_method);
  l_http_response := UTL_HTTP.get_response(l_http_request);
  get_header_info (l_http_response);
  UTL_HTTP.end_response(l_http_response);

  -- Get everything after the domain as the URI.
  l_uri := SUBSTR(p_url, INSTR(p_url, '/', 1, 3));

  l_response := get_response(p_username => p_username,
                             p_password => p_password,
                             p_uri      => l_uri,
                             p_method   => p_method,
                             p_req_cnt  => p_req_cnt);

  -- Build the final digest string.
  l_text := 'Digest username="' || p_username ||'",'||
            ' realm="'          || g_realm ||'",'||
            ' nonce="'          || g_nonce ||'",'||
            ' uri="'            || l_uri ||'",'||
            ' response="'       || l_response ||'",'||
            ' qop='             || g_qop ||',' ||
            ' nc='              || LPAD(p_req_cnt,8,0) ||',' ||
            ' cnonce="'         || g_cnonce      ||'"';

  IF g_opaque IS NOT NULL THEN
    l_text := l_text || ',opaque="'||g_opaque||'"';
  END IF;
  debug(l_text);

  -- Make the new request and set the digest authorization.
  l_http_request  := UTL_HTTP.begin_request(p_url, p_method);
  UTL_HTTP.SET_HEADER(l_http_request, 'Authorization', l_text);

  RETURN l_http_request;
EXCEPTION
  WHEN OTHERS THEN
    UTL_HTTP.end_response(l_http_response);
    RAISE;
END begin_request;
-- -----------------------------------------------------------------------------

END digest_auth_api;
/
SHOW ERRORS
