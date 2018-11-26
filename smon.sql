set linesize 300
set pagesize 9999
set feedback on
set longchunksize 999999
set long 999999
set trimout on
set space 1
set tab off

col sql_exec_start format a25
col username format a25
col status format a20
col sess_serial format 99999
col Kill_Script format a55
col SQL_OPNAME format a10
col sid format 999999

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
            ELSE ROUN((last_refresh_time-sql_exec_start) * 3600*24,0)
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
	 
	-- sysdate-sql_exec_start ///execute ise değilse;
	-- last refresh-sql_exec_start
	 
	-- case status='EXECUTING'
	-- (sysdate-sql_exec_start) * 3600*24
	--else 
	-- (last_refresh_time-sql_exec_start* 3600*24
