SELECT sl.thread#,
         sl.group#,
         l.MEMBER,
         TRUNC (sl.bytes / 1024 / 1024) AS size_mb,
         sl.status,
         sl.archived,
         l.TYPE,
         l.is_recovery_dest_file AS rdf,
         sl.sequence#,
         sl.first_change#,
         sl.next_change#
    FROM v$standby_log sl JOIN v$logfile l ON l.group# = sl.group#
ORDER BY thread#, group#;
