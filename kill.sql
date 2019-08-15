SELECT
  'ALTER SYSTEM KILL SESSION '''
  ||sid
  ||','
  ||serial#
  ||',@'
  ||inst_id
  || ''' IMMEDIATE;' Kill_Script 
FROM gv$session
WHERE sid=:sid
  AND serial#=:serial
  AND inst_id=:inst_id;
