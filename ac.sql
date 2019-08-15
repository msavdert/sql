SELECT inst_id,
  sid,
  serial#,
  username,
  machine,
  program,
  sql_id,
  sql_exec_id,
SQL_HASH_VALUE,
  event,
  wait_class
FROM gv$session
WHERE type NOT LIKE 'BACKGROUND'
AND STATUS LIKE 'ACTIVE'
ORDER BY username;
