SELECT *
     FROM
       (SELECT 
                     inst_id,
                               sid,
                               session_serial# sess_serial,
                               status,
         username,
		 substr(sql_text,1,7) SQL_OPNAME,
         sql_id,
         sql_exec_id,
         TO_CHAR(sql_exec_start,'dd-mm-yyyy hh24:mi:ss')  AS sql_exec_start,
         CASE 
            WHEN (STATUS = 'EXECUTING')
                THEN ROUND((sysdate-sql_exec_start) * 3600*24,0)
            ELSE ROUND((last_refresh_time-sql_exec_start) * 3600*24,0)
         END AS "Elapsed (s)",
--       ROUND(elapsed_time/1000000)                      AS "Elapsed (s)",
         ROUND(cpu_time    /1000000)                      AS "CPU (s)",
         buffer_gets,
         ROUND(physical_read_bytes /(1024*1024)) AS "Phys reads (MB)",
         ROUND(physical_write_bytes/(1024*1024)) AS "Phys writes (MB)",
                               'ALTER SYSTEM KILL SESSION '''
                               ||sid
                               ||','
                               ||session_serial#
                               ||',@'
                               ||inst_id
                               || ''' IMMEDIATE;' Kill_Script
       FROM gv$sql_monitor
       ORDER BY  sql_exec_start DESC
       )
     WHERE STATUS = 'EXECUTING'
	 UNION ALL
	 SELECT *
     FROM
       (SELECT 
                     inst_id,
                               sid,
                               session_serial# sess_serial,
                               status,
         username,
		 substr(sql_text,1,7) SQL_OPNAME,
         sql_id,
         sql_exec_id,
         TO_CHAR(sql_exec_start,'dd-mm-yyyy hh24:mi:ss')  AS sql_exec_start,
         CASE 
            WHEN (STATUS = 'EXECUTING')
                THEN ROUND((sysdate-sql_exec_start) * 3600*24,0)
            ELSE ROUND((last_refresh_time-sql_exec_start) * 3600*24,0)
         END AS "Elapsed (s)",
--       ROUND(elapsed_time/1000000)                      AS "Elapsed (s)",
         ROUND(cpu_time    /1000000)                      AS "CPU (s)",
         buffer_gets,
         ROUND(physical_read_bytes /(1024*1024)) AS "Phys reads (MB)",
         ROUND(physical_write_bytes/(1024*1024)) AS "Phys writes (MB)",
                               'ALTER SYSTEM KILL SESSION '''
                               ||sid
                               ||','
                               ||session_serial#
                               ||',@'
                               ||inst_id
                               || ''' IMMEDIATE;' Kill_Script
       FROM gv$sql_monitor
       ORDER BY  sql_exec_start DESC
       )
     WHERE STATUS <> 'EXECUTING'
	 AND rownum < 15;
