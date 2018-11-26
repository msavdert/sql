SELECT blocking_instance inst_id,
       blocking_session sid,
        (SELECT serial# FROM gv$session WHERE sid = s.blocking_session AND inst_id = s.blocking_instance) serial,
        (SELECT username FROM gv$session WHERE sid = s.blocking_session AND inst_id = s.blocking_instance) username,
        (SELECT sql_id FROM gv$session WHERE sid = s.blocking_session AND inst_id = s.blocking_instance) sql_id,
        (SELECT program FROM gv$session WHERE sid = s.blocking_session AND inst_id = s.blocking_instance) program,
        (SELECT machine FROM gv$session WHERE sid = s.blocking_session AND inst_id = s.blocking_instance) machine,
        (SELECT wait_class FROM gv$session WHERE sid = s.blocking_session AND inst_id = s.blocking_instance) wait_class,
        (SELECT event FROM gv$session WHERE sid = s.blocking_session AND inst_id = s.blocking_instance) event,
        inst_id blocked_inst_id,
        sid blocked_sid,
        serial# blkd_serial,
        username blkd_username,
        sql_id blkd_sql_id,
        program blkd_program,
        machine blkd_machine,
        wait_class blkd_wait_class,
        event blkd_event,
        seconds_in_wait scnds_wait,
        'alter system kill session '''
          || blocking_session
          || ','
          || (SELECT serial#
                FROM gv$session
               WHERE sid = s.blocking_session AND inst_id = s.blocking_instance)
          || ',@'
          || blocking_instance
          || ''' immediate;'
             KILL_SCRIPT
   FROM gv$session s
  WHERE blocking_session IS NOT NULL
ORDER BY seconds_in_wait DESC;
