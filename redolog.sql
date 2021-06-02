SELECT l.thread#,
       lf.group#,
       lf.member,
       TRUNC(l.bytes/1024/1024) AS size_mb,
       l.status,
       l.archived,
       lf.type,
       lf.is_recovery_dest_file AS rdf,
       l.sequence#,
       l.first_change#,
       l.next_change#   
FROM   v$logfile lf
       JOIN v$log l ON l.group# = lf.group#
ORDER BY l.thread#,lf.group#, lf.member;

SELECT sl.thread#,
         sl.group#,
         l.MEMBER,
         TRUNC (sl.bytes / 1024 / 1024) AS size_mb,
         sl.status,
         sl.archived,
         l.TYPE,
         l.is_recovery_dest_file AS rdf,
         sl.sequence#
    FROM v$standby_log sl JOIN v$logfile l ON l.group# = sl.group#
ORDER BY thread#, group#;
