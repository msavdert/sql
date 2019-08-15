SELECT
  'ALTER SYSTEM KILL SESSION '''
  ||:sid
  ||','
  ||:serial
  ||',@'
  ||:inst_id
  || ''' IMMEDIATE;' Kill_Script
FROM gv$session;
