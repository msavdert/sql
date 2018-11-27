SELECT s.username,
  osuser,
  s.inst_id||'.'||
  s.sid instid_sid,
  s.serial#,
  sl.sql_id,
  opname,
  sl.message,
  target,
  start_time,
  elapsed_seconds elapsed,
  ROUND((time_remaining/60),1) rem_minutes,
  ROUND((elapsed_seconds/(elapsed_seconds+time_remaining)*100),2) ||'%' AS PCT
FROM gv$session_longops sl
INNER JOIN gv$session s
ON sl.SID            = s.SID
AND sl.SERIAL#       = s.SERIAL#
AND sl.INST_ID       = s.INST_ID
WHERE time_remaining > 0
ORDER BY PCT DESC;
