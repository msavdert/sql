SELECT ss.snap_id,
       ss.instance_number node,
       begin_interval_time,
       sql_id,
       plan_hash_value,
       NVL (executions_delta, 0) execs,
       (elapsed_time_delta/ DECODE (NVL (executions_delta, 0), 0, 1, executions_delta))/ 1000000 avg_etime,
       (buffer_gets_delta/ DECODE (NVL (buffer_gets_delta, 0), 0, 1, executions_delta)) avg_lio
    FROM DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
   WHERE sql_id = (:1)
     AND ss.snap_id = S.snap_id
     AND ss.instance_number = S.instance_number
     AND executions_delta > 0
ORDER BY 1 DESC, 2, 3;
