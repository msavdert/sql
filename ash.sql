SELECT u.username, ash.inst_id,ash.sample_time,ash.session_id,ash.session_serial#,ash.sql_id
  FROM gv$active_session_history ash, dba_users u
 WHERE     U.USER_ID = ASH.USER_ID
       AND ash.sample_time BETWEEN TO_DATE ('26.10.2016 10:30:00',
                                            'dd.mm.yyyy hh24:mi:ss')
                               AND TO_DATE ('26.10.2016 12:00:00',
                                            'dd.mm.yyyy hh24:mi:ss')
       AND u.username not in ('SYS','DBSNMP')
       FETCH FIRST 50 ROWS ONLY;
