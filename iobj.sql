SELECT object_type, COUNT (object_type)
    FROM dba_objects
   WHERE     status <> 'VALID'
         AND (owner LIKE 'USR%' OR LOWER (owner) = LOWER (:1))
GROUP BY object_type
ORDER BY object_type;

SELECT    'create or replace synonym '
       || owner
       || '.'
       || object_name
       || ' for '
       || 'sch_dmall'
       || '.'
       || object_name
       || ';'
           AS cmd
  FROM dba_objects
 WHERE     object_type = 'SYNONYM'
       AND (owner LIKE 'USR%' OR LOWER (owner) = LOWER (&&1))
       AND status = 'INVALID';

SELECT    'alter '
       || object_type
       || ' '
       || owner
       || '.'
       || object_name
       || ' compile;'
           AS script
  FROM dba_objects
 WHERE     object_type IN ('PROCEDURE',
                           'MATERIALIZED VIEW',
                           'VIEW',
                           'FUNCTION',
                           'TRIGGER',
                           'TYPE',
                           'PACKAGE')
       AND status = 'INVALID'
       AND (owner LIKE 'USR%' OR LOWER (owner) = LOWER (&&1));
       

SELECT    'alter package '
       || owner
       || '.'
       || object_name
       || ' compile body;'
           AS script
  FROM dba_objects
 WHERE     object_type IN ('TYPE BODY', 'PACKAGE BODY')
       AND status = 'INVALID'
       AND (owner LIKE 'USR%' OR LOWER (owner) = LOWER (&&1));
