-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/network_acls_ddl.sql
-- Author       : Tim Hall
-- Description  : Displays DDL for all network ACLs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @network_acls_ddl
-- Last Modified: 28-JUL-2017
-- -----------------------------------------------------------------------------------

SET SERVEROUTPUT ON FORMAT WRAPPED LINESIZE 300
DECLARE
  l_last_acl       dba_network_acls.acl%TYPE                 := '~';
  l_last_principal dba_network_acl_privileges.principal%TYPE := '~';
  l_last_privilege dba_network_acl_privileges.privilege%TYPE := '~';
  l_last_host      dba_network_acls.host%TYPE                := '~';

  FUNCTION get_timestamp (p_timestamp IN TIMESTAMP WITH TIME ZONE)
    RETURN VARCHAR2
  AS
    l_return  VARCHAR2(32767);
  BEGIN
    IF p_timestamp IS NULL THEN
      RETURN 'NULL';
    END IF;
    RETURN 'TO_TIMESTAMP_TZ(''' || TO_CHAR(p_timestamp, 'DD-MON-YYYY HH24:MI:SS.FF TZH:TZM') || ''',''DD-MON-YYYY HH24:MI:SS.FF TZH:TZM'')';
  END;
BEGIN
  FOR i IN (SELECT a.acl,
                   a.host,
                   a.lower_port,
                   a.upper_port,
                   b.principal,
                   b.privilege,
                   b.is_grant,
                   b.start_date,
                   b.end_date
            FROM   dba_network_acls a
                   JOIN dba_network_acl_privileges b ON a.acl = b.acl
            ORDER BY a.acl, a.host, a.lower_port, a.upper_port)
  LOOP
    IF l_last_acl <> i.acl THEN
      -- First time we've seen this ACL, so create a new one.
      l_last_host := '~';

      DBMS_OUTPUT.put_line('-- -------------------------------------------------');
      DBMS_OUTPUT.put_line('-- ' || i.acl);
      DBMS_OUTPUT.put_line('-- -------------------------------------------------');
      DBMS_OUTPUT.put_line('BEGIN');
      DBMS_OUTPUT.put_line('  DBMS_NETWORK_ACL_ADMIN.drop_acl (');
      DBMS_OUTPUT.put_line('    acl          => ''' || i.acl || ''');');
      DBMS_OUTPUT.put_line('  COMMIT;');
      DBMS_OUTPUT.put_line('END;');
      DBMS_OUTPUT.put_line('/');
      DBMS_OUTPUT.put_line(' ');
      DBMS_OUTPUT.put_line('BEGIN');
      DBMS_OUTPUT.put_line('  DBMS_NETWORK_ACL_ADMIN.create_acl (');
      DBMS_OUTPUT.put_line('    acl          => ''' || i.acl || ''',');
      DBMS_OUTPUT.put_line('    description  => ''' || i.acl || ''',');
      DBMS_OUTPUT.put_line('    principal    => ''' || i.principal || ''',');
      DBMS_OUTPUT.put_line('    is_grant     => ' || i.is_grant || ',');
      DBMS_OUTPUT.put_line('    privilege    => ''' || i.privilege || ''',');
      DBMS_OUTPUT.put_line('    start_date   => ' || get_timestamp(i.start_date) || ',');
      DBMS_OUTPUT.put_line('    end_date     => ' || get_timestamp(i.end_date) || ');');
      DBMS_OUTPUT.put_line('  COMMIT;');
      DBMS_OUTPUT.put_line('END;');
      DBMS_OUTPUT.put_line('/');
      DBMS_OUTPUT.put_line(' ');
      l_last_acl := i.acl;
      l_last_principal := i.principal;
      l_last_privilege := i.privilege;
    END IF;

    IF l_last_principal <> i.principal 
    OR (l_last_principal = i.principal AND l_last_privilege <> i.privilege) THEN
      -- Add another principal to an existing ACL.
      DBMS_OUTPUT.put_line('BEGIN');
      DBMS_OUTPUT.put_line('  DBMS_NETWORK_ACL_ADMIN.add_privilege (');
      DBMS_OUTPUT.put_line('    acl       => ''' || i.acl || ''',');
      DBMS_OUTPUT.put_line('    principal => ''' || i.principal || ''',');
      DBMS_OUTPUT.put_line('    is_grant  => ' || i.is_grant || ',');
      DBMS_OUTPUT.put_line('    privilege => ''' || i.privilege || ''',');
      DBMS_OUTPUT.put_line('    start_date   => ' || get_timestamp(i.start_date) || ',');
      DBMS_OUTPUT.put_line('    end_date     => ' || get_timestamp(i.end_date) || ');');
      DBMS_OUTPUT.put_line('  COMMIT;');
      DBMS_OUTPUT.put_line('END;');
      DBMS_OUTPUT.put_line('/');
      DBMS_OUTPUT.put_line(' ');
      l_last_principal := i.principal;
      l_last_privilege := i.privilege;
    END IF;

    IF l_last_host <> i.host||':'||i.lower_port||':'||i.upper_port THEN
      DBMS_OUTPUT.put_line('BEGIN');
      DBMS_OUTPUT.put_line('  DBMS_NETWORK_ACL_ADMIN.assign_acl (');
      DBMS_OUTPUT.put_line('    acl         => ''' || i.acl || ''',');
      DBMS_OUTPUT.put_line('    host        => ''' || i.host || ''',');
      DBMS_OUTPUT.put_line('    lower_port  => ' || NVL(TO_CHAR(i.lower_port),'NULL') || ',');
      DBMS_OUTPUT.put_line('    upper_port  => ' || NVL(TO_CHAR(i.upper_port),'NULL') || ');');
      DBMS_OUTPUT.put_line('  COMMIT;');
      DBMS_OUTPUT.put_line('END;');
      DBMS_OUTPUT.put_line('/');
      DBMS_OUTPUT.put_line(' ');
      l_last_host := i.host||':'||i.lower_port||':'||i.upper_port;
    END IF;
  END LOOP;
END;
/
