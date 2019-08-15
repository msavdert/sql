SELECT a.dest_id DEST_ID,
       a.name DEST_NAME,
       a.thread# THREAD#,
       b.last_seq LAST_SEQ_PRMY,
       a.applied_seq APPLIED_SEQ_STBY,
       TO_CHAR (a.last_app_timestamp, 'YYYY-MM-DD HH24:MI:SS') LAST_APP_TIMESTAMP,
       b.last_seq - a.applied_seq ARCH_DIFF
  FROM ( SELECT thread#,
                 MAX (sequence#) applied_seq,
                 MAX (next_time) last_app_timestamp,
                 dest_id,
                 name
            FROM gv$archived_log
           WHERE applied = 'YES'
             AND dest_id in (select dest_id from gv$archive_dest where status='VALID')
             AND first_change# > (SELECT resetlogs_change# FROM v$database)
             AND resetlogs_time = (SELECT resetlogs_time FROM v$database)
        GROUP BY thread#, dest_id, name) a,
       ( SELECT thread#, MAX (sequence#) last_seq
            FROM gv$archived_log
           WHERE resetlogs_time = (SELECT resetlogs_time FROM v$database)
           AND first_change# > (SELECT resetlogs_change# FROM v$database)
        GROUP BY thread#) b
 WHERE a.thread# = b.thread#
 ORDER BY DEST_NAME, THREAD#;
