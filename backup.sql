SELECT 
         TO_CHAR (start_time, 'DD-MM-YYYY hh24:mi:ss') start_time,
         TO_CHAR (end_time, 'DD-MM-YYYY hh24:mi:ss') end_time,
         output_device_type device_type,
         status,
         time_taken_display time_taken,
         ROUND (elapsed_seconds / 60, 0) elaps_min,
         ROUND(compression_ratio,1) comp_ratio,
         input_bytes_display input_size,
         output_bytes_display output_size,
         output_bytes_per_sec_display "OutBytesPerSec"
    FROM V$RMAN_BACKUP_JOB_DETAILS
   WHERE start_time > TRUNC (SYSDATE-:DAY)
ORDER BY start_time DESC;
