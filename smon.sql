WITH sql_monitor_stats AS (
    SELECT
        m.sql_id,
        m.sql_exec_id,
        m.base_sid,
        m.sql_exec_start,
        m.last_refresh_time,
        CASE
            WHEN m.last_refresh_time > m.sql_exec_start THEN
                round(24 * 60 * 60 * 1000000 *(m.last_refresh_time - m.sql_exec_start), 0)
            ELSE
                m.elapsed_time
        END AS elapsed_time,
        m.cpu_time,
        m.fetches,
        m.buffer_gets,
        m.physical_read_requests,
        m.physical_read_bytes,
        m.database_time,
        m.application_wait_time,
        m.concurrency_wait_time,
        m.cluster_wait_time,
        m.user_io_wait_time,
        m.plsql_exec_time,
        m.java_exec_time,
        m.queuing_time
    FROM
        (
            SELECT
                sql_id,
                sql_exec_id,
                nvl(px_qcsid, sid) AS base_sid,
                MIN(sql_exec_start) AS sql_exec_start,
                MAX(last_refresh_time) AS last_refresh_time,
                SUM(elapsed_time) AS elapsed_time,
                SUM(cpu_time) AS cpu_time,
                SUM(fetches) AS fetches,
                SUM(buffer_gets) AS buffer_gets,
                SUM(physical_read_requests) AS physical_read_requests,
                SUM(physical_read_bytes) AS physical_read_bytes,
                SUM(cpu_time + application_wait_time + concurrency_wait_time + cluster_wait_time + user_io_wait_time + plsql_exec_time
                + java_exec_time + queuing_time) AS database_time,
                SUM(application_wait_time) AS application_wait_time,
                SUM(concurrency_wait_time) AS concurrency_wait_time,
                SUM(cluster_wait_time) AS cluster_wait_time,
                SUM(user_io_wait_time) AS user_io_wait_time,
                SUM(plsql_exec_time) AS plsql_exec_time,
                SUM(java_exec_time) AS java_exec_time,
                SUM(queuing_time) AS queuing_time
            FROM
                gv$sql_monitor
            GROUP BY
                sql_id,
                sql_exec_id,
                nvl(px_qcsid, sid)
        ) m
), sql_monitor_limits AS (
    SELECT
        MAX(database_time) AS max_database_time,
        MAX(elapsed_time) AS max_elapsed_time,
        MAX(physical_read_requests) AS max_physical_read_requests,
        MAX(physical_read_bytes) AS max_physical_read_bytes,
        MAX(buffer_gets) AS max_buffer_gets
    FROM
        sql_monitor_stats
), sql_monitor AS (
    SELECT
        m.sql_id,
        m.sql_exec_id,
        m.inst_id,
        m.sid,
        m.key,
        m.status,
        m.user#,
        m.username,
        m.session_serial#,
        m.module,
        m.action,
        m.service_name,
        m.program,
        m.plsql_object_id,
        m.first_refresh_time,
        m.last_refresh_time,
        CASE
            WHEN m.is_full_sqltext = 'N' THEN
                m.sql_text || ' ...'
            ELSE
                m.sql_text
        END AS sql_text,
        m.sql_exec_start,
        m.sql_plan_hash_value,
        m.sql_child_address,
        m.px_maxdop,
        s.elapsed_time,
        s.fetches,
        s.buffer_gets,
        s.physical_read_requests,
        s.physical_read_bytes,
        s.database_time,
        s.cpu_time,
        s.application_wait_time,
        s.concurrency_wait_time,
        s.cluster_wait_time,
        s.user_io_wait_time,
        s.plsql_exec_time,
        s.java_exec_time,
        s.queuing_time
    FROM
        gv$sql_monitor      m,
        sql_monitor_stats   s
    WHERE
        m.px_qcsid IS NULL
        AND m.sql_id = s.sql_id
        AND m.sql_exec_id = s.sql_exec_id
        AND m.sid = s.base_sid
)
SELECT /*+NO_MONITOR*/
    decode(m.status, 'QUEUED', 'EXECUTING', 'EXECUTING', 'EXECUTING',
           'DONE (ERROR)', 'ERROR', 'DONE') AS status,
    CASE
        WHEN m.elapsed_time < 10       THEN
            '< 0.1 ms'
        WHEN m.elapsed_time < 1000000  THEN
            to_char(round(m.elapsed_time / 1000, 1))
            || ' ms'
        WHEN m.elapsed_time < 60000000 THEN
            to_char(round(m.elapsed_time / 1000000, 1))
            || ' s'
        ELSE
            to_char(round(m.elapsed_time / 60000000, 1))
            || ' m'
    END AS duration,
    decode(m.plsql_object_id, NULL, 'SQL', 'PL/SQL') AS type,
    m.sql_id                   AS sql_id,
    m.sql_plan_hash_value      AS plan_hash_value,
    nvl(m.username, ' ') AS username,
    m.inst_id                  AS inst_id,
    decode(m.px_maxdop, NULL, ' ', to_char(m.px_maxdop)) AS parallel,
    CASE
        WHEN m.database_time < 1000000  THEN
            to_char(round(m.database_time / 1000, 1))
            || ' ms'
        WHEN m.database_time < 60000000 THEN
            to_char(round(m.database_time / 1000000, 1))
            || ' s'
        ELSE
            to_char(round(m.database_time / 60000000, 1))
            || ' m'
    END AS database_time,
    CASE
        WHEN m.cpu_time < 1000000  THEN
            to_char(round(m.cpu_time / 1000, 1))
            || ' ms'
        WHEN m.cpu_time < 60000000 THEN
            to_char(round(m.cpu_time / 1000000, 1))
            || ' s'
        ELSE
            to_char(round(m.cpu_time / 60000000, 1))
            || ' m'
    END AS cpu_time,
    CASE
        WHEN m.physical_read_requests < 1000 THEN
            to_char(m.physical_read_requests)
        ELSE
            to_char(round(m.physical_read_requests / 1000, 1))
            || 'K'
    END AS "I/O Requests",
    CASE
        WHEN m.physical_read_bytes < 10240           THEN
            to_char(m.physical_read_bytes)
            || 'B'
        WHEN m.physical_read_bytes < 10240 * 1024      THEN
            to_char(round(m.physical_read_bytes / 1024, 0))
            || 'KB'
        WHEN m.physical_read_bytes < 10240 * 1024 * 1024 THEN
            to_char(round(m.physical_read_bytes /(1024 * 1024), 0))
            || 'MB'
        ELSE
            to_char(round(m.physical_read_bytes /(1024 * 1024 * 1024), 0))
            || 'GB'
    END AS "I/O Bytes",
    CASE
        WHEN ( m.buffer_gets ) < 10000       THEN
            to_char(m.buffer_gets)
        WHEN ( m.buffer_gets ) < 10000000    THEN
            to_char(round((m.buffer_gets) / 1000, 0))
            || 'K'
        WHEN ( m.buffer_gets ) < 10000000000 THEN
            to_char(round((m.buffer_gets) / 1000000, 0))
            || 'M'
        ELSE
            to_char(round((m.buffer_gets) / 1000000000, 0))
            || 'G'
    END AS "Buffer Gets",
    to_char(m.sql_exec_start, 'DD-Mon-YYYY HH24:MI:SS') AS "Start Time",
    to_char(m.last_refresh_time, 'DD-Mon-YYYY HH24:MI:SS') AS "End Time",
    SUBSTR(m.sql_text,1,50)    AS sql_text
--  m.sid                      AS session_id,
--  m.session_serial#          AS session_serial_no,
--  m.user#                    AS user_no,
--  m.module                   AS module,
--  m.service_name             AS service_name,
--  m.program                  AS program,
--  m.sql_exec_id              AS sql_exec_id,
--  m.sql_exec_start           AS sql_exec_start
FROM
    sql_monitor          m,
    sql_monitor_limits   l
ORDER BY m.sql_exec_start DESC;
