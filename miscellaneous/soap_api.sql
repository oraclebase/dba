CREATE OR REPLACE PACKAGE soap_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/soap_api.sql
-- Author       : Tim Hall
-- Description  : SOAP related functions for consuming web services.
-- License      : Free for personal and commercial use.
--                You can amend the code, but leave existing the headers, current
--                amendments history and links intact.
--                Copyright and disclaimer available here:
--                https://oracle-base.com/misc/site-info.php#copyright
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   04-OCT-2003  Tim Hall  Initial Creation
--   23-FEB-2006  Tim Hall  Parameterized the "soap" envelope tags.
--   25-MAY-2012  Tim Hall  Added debug switch.
--   29-MAY-2012  Tim Hall  Allow parameters to have no type definition.
--                          Change the default envelope tag to "soap".
--                          add_complex_parameter: Include parameter XML manually.
--   24-MAY-2014  Tim Hall  Added license information.
-- --------------------------------------------------------------------------

TYPE t_request IS RECORD (
  method        VARCHAR2(256),
  namespace     VARCHAR2(256),
  body          VARCHAR2(32767),
  envelope_tag  VARCHAR2(30)
);

TYPE t_response IS RECORD
(
  doc           XMLTYPE,
  envelope_tag  VARCHAR2(30)
);

FUNCTION new_request(p_method        IN  VARCHAR2,
                     p_namespace     IN  VARCHAR2,
                     p_envelope_tag  IN  VARCHAR2 DEFAULT 'soap')
  RETURN t_request;


PROCEDURE add_parameter(p_request  IN OUT NOCOPY  t_request,
                        p_name     IN             VARCHAR2,
                        p_value    IN             VARCHAR2,
                        p_type     IN             VARCHAR2 := NULL);

PROCEDURE add_complex_parameter(p_request  IN OUT NOCOPY  t_request,
                                p_xml      IN             VARCHAR2);

FUNCTION invoke(p_request  IN OUT NOCOPY  t_request,
                p_url      IN             VARCHAR2,
                p_action   IN             VARCHAR2)
  RETURN t_response;

FUNCTION get_return_value(p_response   IN OUT NOCOPY  t_response,
                          p_name       IN             VARCHAR2,
                          p_namespace  IN             VARCHAR2)
  RETURN VARCHAR2;

PROCEDURE debug_on;
PROCEDURE debug_off;

END soap_api;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY soap_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/soap_api.sql
-- Author       : Tim Hall
-- Description  : SOAP related functions for consuming web services.
-- License      : Free for personal and commercial use.
--                You can amend the code, but leave existing the headers, current
--                amendments history and links intact.
--                Copyright and disclaimer available here:
--                https://oracle-base.com/misc/site-info.php#copyright
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   04-OCT-2003  Tim Hall  Initial Creation
--   23-FEB-2006  Tim Hall  Parameterized the "soap" envelope tags.
--   25-MAY-2012  Tim Hall  Added debug switch.
--   29-MAY-2012  Tim Hall  Allow parameters to have no type definition.
--                          Change the default envelope tag to "soap".
--                          add_complex_parameter: Include parameter XML manually.
--   24-MAY-2014  Tim Hall  Added license information.
-- --------------------------------------------------------------------------

g_debug  BOOLEAN := FALSE;

PROCEDURE show_envelope(p_env     IN  VARCHAR2,
                        p_heading IN  VARCHAR2 DEFAULT NULL);



-- ---------------------------------------------------------------------
FUNCTION new_request(p_method        IN  VARCHAR2,
                     p_namespace     IN  VARCHAR2,
                     p_envelope_tag  IN  VARCHAR2 DEFAULT 'soap')
  RETURN t_request AS
-- ---------------------------------------------------------------------
  l_request  t_request;
BEGIN
  l_request.method       := p_method;
  l_request.namespace    := p_namespace;
  l_request.envelope_tag := p_envelope_tag;
  RETURN l_request;
END;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
PROCEDURE add_parameter(p_request  IN OUT NOCOPY  t_request,
                        p_name     IN             VARCHAR2,
                        p_value    IN             VARCHAR2,
                        p_type     IN             VARCHAR2 := NULL) AS
-- ---------------------------------------------------------------------
BEGIN
  IF p_type IS NULL THEN
    p_request.body := p_request.body||'<'||p_name||'>'||p_value||'</'||p_name||'>';
  ELSE
    p_request.body := p_request.body||'<'||p_name||' xsi:type="'||p_type||'">'||p_value||'</'||p_name||'>';
  END IF;
END;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
PROCEDURE add_complex_parameter(p_request  IN OUT NOCOPY  t_request,
                                p_xml      IN             VARCHAR2) AS
-- ---------------------------------------------------------------------
BEGIN
  p_request.body := p_request.body||p_xml;
END;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
PROCEDURE generate_envelope(p_request  IN OUT NOCOPY  t_request,
		                        p_env      IN OUT NOCOPY  VARCHAR2) AS
-- ---------------------------------------------------------------------
BEGIN
  p_env := '<'||p_request.envelope_tag||':Envelope xmlns:'||p_request.envelope_tag||'="http://schemas.xmlsoap.org/soap/envelope/" ' ||
               'xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance" xmlns:xsd="http://www.w3.org/1999/XMLSchema">' ||
             '<'||p_request.envelope_tag||':Body>' ||
               '<'||p_request.method||' '||p_request.namespace||' '||p_request.envelope_tag||':encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' ||
                   p_request.body ||
               '</'||p_request.method||'>' ||
             '</'||p_request.envelope_tag||':Body>' ||
           '</'||p_request.envelope_tag||':Envelope>';
END;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
PROCEDURE show_envelope(p_env     IN  VARCHAR2,
                        p_heading IN  VARCHAR2 DEFAULT NULL) AS
-- ---------------------------------------------------------------------
  i      PLS_INTEGER;
  l_len  PLS_INTEGER;
BEGIN
  IF g_debug THEN
    IF p_heading IS NOT NULL THEN
      DBMS_OUTPUT.put_line('*****' || p_heading || '*****');
    END IF;

    i := 1; l_len := LENGTH(p_env);
    WHILE (i <= l_len) LOOP
      DBMS_OUTPUT.put_line(SUBSTR(p_env, i, 60));
      i := i + 60;
    END LOOP;
  END IF;
END;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
PROCEDURE check_fault(p_response IN OUT NOCOPY  t_response) AS
-- ---------------------------------------------------------------------
  l_fault_node    XMLTYPE;
  l_fault_code    VARCHAR2(256);
  l_fault_string  VARCHAR2(32767);
BEGIN
  l_fault_node := p_response.doc.extract('/'||p_response.envelope_tag||':Fault',
                                         'xmlns:'||p_response.envelope_tag||'="http://schemas.xmlsoap.org/soap/envelope/');
  IF (l_fault_node IS NOT NULL) THEN
    l_fault_code   := l_fault_node.extract('/'||p_response.envelope_tag||':Fault/faultcode/child::text()',
                                           'xmlns:'||p_response.envelope_tag||'="http://schemas.xmlsoap.org/soap/envelope/').getstringval();
    l_fault_string := l_fault_node.extract('/'||p_response.envelope_tag||':Fault/faultstring/child::text()',
                                           'xmlns:'||p_response.envelope_tag||'="http://schemas.xmlsoap.org/soap/envelope/').getstringval();
    RAISE_APPLICATION_ERROR(-20000, l_fault_code || ' - ' || l_fault_string);
  END IF;
END;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
FUNCTION invoke(p_request IN OUT NOCOPY  t_request,
                p_url     IN             VARCHAR2,
                p_action  IN             VARCHAR2)
  RETURN t_response AS
-- ---------------------------------------------------------------------
  l_envelope       VARCHAR2(32767);
  l_http_request   UTL_HTTP.req;
  l_http_response  UTL_HTTP.resp;
  l_response       t_response;
BEGIN
  generate_envelope(p_request, l_envelope);
  show_envelope(l_envelope, 'Request');
  l_http_request := UTL_HTTP.begin_request(p_url, 'POST','HTTP/1.1');
  UTL_HTTP.set_header(l_http_request, 'Content-Type', 'text/xml');
  UTL_HTTP.set_header(l_http_request, 'Content-Length', LENGTH(l_envelope));
  UTL_HTTP.set_header(l_http_request, 'SOAPAction', p_action);
  UTL_HTTP.write_text(l_http_request, l_envelope);
  l_http_response := UTL_HTTP.get_response(l_http_request);
  UTL_HTTP.read_text(l_http_response, l_envelope);
  UTL_HTTP.end_response(l_http_response);
  show_envelope(l_envelope, 'Response');
  l_response.doc := XMLTYPE.createxml(l_envelope);
  l_response.envelope_tag := p_request.envelope_tag;
  l_response.doc := l_response.doc.extract('/'||l_response.envelope_tag||':Envelope/'||l_response.envelope_tag||':Body/child::node()',
                                           'xmlns:'||l_response.envelope_tag||'="http://schemas.xmlsoap.org/soap/envelope/"');
  check_fault(l_response);
  RETURN l_response;
END;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
FUNCTION get_return_value(p_response   IN OUT NOCOPY  t_response,
                          p_name       IN             VARCHAR2,
                          p_namespace  IN             VARCHAR2)
  RETURN VARCHAR2 AS
-- ---------------------------------------------------------------------
BEGIN
  RETURN p_response.doc.extract('//'||p_name||'/child::text()',p_namespace).getstringval();
END;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
PROCEDURE debug_on AS
-- ---------------------------------------------------------------------
BEGIN
  g_debug := TRUE;
END;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
PROCEDURE debug_off AS
-- ---------------------------------------------------------------------
BEGIN
  g_debug := FALSE;
END;
-- ---------------------------------------------------------------------

END soap_api;
/
SHOW ERRORS