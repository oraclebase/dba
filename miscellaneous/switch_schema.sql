-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/switch_schema.sql
-- Author       : Tim Hall
-- Description  : Allows developers to switch synonyms between schemas where a single instance
--              : contains multiple discrete schemas.
-- Requirements : Must be loaded into privileged user such as SYS.
-- Usage        : Create the package in a user that has the appropriate privileges to perform the actions (SYS)
--              : Amend the list of schemas in the "reset_grants" FOR LOOP as necessary.
--              : Call SWITCH_SCHEMA.RESET_GRANTS once to grant privileges to the developer role.
--              : Assign the developer role to all developers.
--              : Tell developers to use EXEC SWITCH_SCHEMA.RESET_SCHEMA_SYNONYMS ('SCHEMA-NAME'); to switch
--              : there synonyms between schemas.
-- Call Syntax  : EXEC SWITCH_SCHEMA.RESET_SCHEMA_SYNONYMS ('SCHEMA-NAME');
-- Last Modified: 02/06/2003
-- -----------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE switch_schema AS

PROCEDURE reset_grants;
PROCEDURE reset_schema_synonyms (p_schema  IN  VARCHAR2);

END;
/

SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY switch_schema AS

PROCEDURE reset_grants IS
BEGIN
  FOR cur_obj IN (SELECT owner, object_name, object_type
                  FROM   all_objects
                  WHERE  owner IN ('SCHEMA1','SCHEMA2','SCHEMA3','SCHEMA4')
                  AND    object_type IN ('TABLE','VIEW','SEQUENCE', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'TYPE'))
  LOOP
    CASE 
      WHEN cur_obj.object_type IN ('TABLE','VIEW') THEN
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ' || cur_obj.owner || '."' || cur_obj.object_name || '" TO developer';
      WHEN cur_obj.object_type IN ('SEQUENCE') THEN
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || cur_obj.owner || '."' || cur_obj.object_name || '" TO developer';
      WHEN cur_obj.object_type IN ('PACKAGE', 'PROCEDURE', 'FUNCTION', 'TYPE') THEN
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON ' || cur_obj.owner || '."' || cur_obj.object_name || '" TO developer';
    END CASE;
  END LOOP;
END;

PROCEDURE reset_schema_synonyms (p_schema  IN  VARCHAR2) IS
  v_user  VARCHAR2(30) := USER;
BEGIN
  -- Drop all existing synonyms
  FOR cur_obj IN (SELECT synonym_name
                  FROM   all_synonyms
                  WHERE  owner = v_user)
  LOOP
    EXECUTE IMMEDIATE 'DROP SYNONYM ' || v_user || '."' || cur_obj.synonym_name || '"';
  END LOOP;

  -- Create new synonyms
  FOR cur_obj IN (SELECT object_name, object_type
                  FROM   all_objects
                  WHERE  owner = p_schema
                  AND    object_type IN ('TABLE','VIEW','SEQUENCE'))
  LOOP
    EXECUTE IMMEDIATE 'CREATE SYNONYM ' || v_user || '."' || cur_obj.object_name || '" FOR ' || p_schema || '."' || cur_obj.object_name || '"';
  END LOOP;
END;

END;
/

SHOW ERRORS

CREATE PUBLIC SYNONYM switch_schema FOR switch_schema;
GRANT EXECUTE ON switch_schema TO PUBLIC;

CREATE ROLE developer;
