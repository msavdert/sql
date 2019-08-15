SELECT owner owner,
       object_type,
       object_name,
       status,
       TO_CHAR (created, 'YYYY-MM-DD HH24:MI:SS') created,
       TO_CHAR (last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') last_ddl_time,
       TO_CHAR (TO_DATE (timestamp, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') timestamp
    FROM dba_objects
   WHERE status != 'VALID' --AND LAST_DDL_TIME >= SYSDATE - 1
ORDER BY last_ddl_time DESC;
