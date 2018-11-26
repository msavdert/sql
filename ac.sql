set linesize 300
set pagesize 9999
set feedback on
set longchunksize 999999
set long 999999
set trimout on
set tab off

col machine for a35
col program for a40
col event for a40
col username for a20
col Kill_Script for a60
col wait_class for a15
col sql_id for a15
col inst_id for 99999
col sid for 99999
col SQL_HASH_VALUE for 9999999999

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
  wait_class, 
  'ALTER SYSTEM KILL SESSION '''
  ||sid
  ||','
  ||serial#
  ||',@'
  ||inst_id
  || ''' IMMEDIATE;' Kill_Script 
FROM gv$session
WHERE type NOT LIKE 'BACKGROUND'
AND STATUS LIKE 'ACTIVE'
ORDER BY username;
