SELECT object_type, COUNT (object_type)
    FROM dba_objects
   WHERE     status <> 'VALID'
         AND (owner LIKE 'USR%' OR LOWER (owner) = LOWER ('&1'))
GROUP BY object_type
ORDER BY object_type;
