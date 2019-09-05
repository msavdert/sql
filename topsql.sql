SELECT *
  FROM (  SELECT ash.INST_ID,
                 ash.session_id    sid,
                 ash.session_serial# serial,
                 ash.sql_id,
                 ash.SQL_OPNAME op_name,
                 sess.username     service,
                 COUNT (*)         AS db_time,
                 ROUND (COUNT (*) * 100 / SUM (COUNT (*)) OVER (), 2)
                    AS pct_activity,
                 sess.machine,
                 sess.program,
                 sess.event,
                 sess.wait_class
            FROM gv$active_session_history ash, gv$session sess
           WHERE sample_time >= SYSDATE - :1/1440
                 AND session_type <> 'BACKGROUND'
                 AND ash.INST_ID = sess.INST_ID
                 AND ash.SESSION_ID = sess.SID
                 AND ash.SESSION_SERIAL# = sess.SERIAL#
        GROUP BY ash.sql_id,
                 ash.SQL_OPNAME,
                 sess.username,
                 ash.INST_ID,
                 ash.session_id,
                 ash.session_serial#,
                 sess.program,
                 sess.machine,
                 sess.event,
                 sess.wait_class
        ORDER BY COUNT (*) DESC)
 WHERE ROWNUM <= 15;
