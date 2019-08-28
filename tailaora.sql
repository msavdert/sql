WITH oneday AS (
SELECT /*+ materialize */ * FROM TABLE(gv$(cursor(select inst_id, originating_timestamp, message_text FROM v$diag_alert_ext 
WHERE ORIGINATING_TIMESTAMP > SYSTIMESTAMP - 1 AND UPPER(filename) LIKE (select '%'||UPPER(name)||'%' from v$database)))))
SELECT INST_ID c1, TO_CHAR (ORIGINATING_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') c2, MESSAGE_TEXT c3 FROM oneday
 WHERE originating_timestamp > (SYSTIMESTAMP - INTERVAL :1 MINUTE)
               AND ( REGEXP_LIKE (MESSAGE_TEXT, '(ORA-)')
                    OR REGEXP_LIKE (MESSAGE_TEXT, '(Checkpoint not complete)')
                    OR REGEXP_LIKE (MESSAGE_TEXT, '(shutdown)')
                    OR REGEXP_LIKE (MESSAGE_TEXT, '(WARNING)'))
               AND NOT REGEXP_LIKE (MESSAGE_TEXT, '(ORA-3136)')
               AND NOT REGEXP_LIKE (MESSAGE_TEXT, '(ORA-609)')
               AND NOT REGEXP_LIKE (MESSAGE_TEXT, '(ORA-604)')
               AND NOT REGEXP_LIKE (MESSAGE_TEXT, '(ORA-01013)')
               AND NOT REGEXP_LIKE (MESSAGE_TEXT, '(ORA-28)')
               AND NOT REGEXP_LIKE (MESSAGE_TEXT, '(ORA-48913)')
               AND NOT REGEXP_LIKE (MESSAGE_TEXT, '(ORA-29904)')
               AND NOT REGEXP_LIKE (MESSAGE_TEXT, '(ORA-03135)')
               AND NOT REGEXP_LIKE (MESSAGE_TEXT, '(ORA-2396)')
               ORDER BY c2 DESC;
