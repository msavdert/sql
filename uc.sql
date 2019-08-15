SELECT
	s.inst_id			   inst_id
  , s.sid                  sid
  , s.serial#			   serial#
  , s.program              session_program
  , lpad(s.machine,15)     session_machine
  , lpad(s.osuser,12)      os_username
  , lpad(s.status,9)       session_status
  , s.username		       username
  , s.sql_id			   sql_id
  , p.spid		   	       os_pid
  , b.used_urec            number_of_undo_records
  , b.used_ublk * d.value  used_undo_size
  , b.start_time		   
  , 'ALTER SYSTEM KILL SESSION '''
  ||s.sid
  ||','
  ||s.serial#
  ||',@'
  ||s.inst_id
  || ''' IMMEDIATE;' Kill_Script
FROM
    gv$process      p
  , gv$session      s
  , gv$transaction  b
  , gv$parameter    d
WHERE
      b.ses_addr =  s.saddr
  AND p.addr (+) =  s.paddr
  AND s.audsid   <> userenv('SESSIONID')
  AND d.name     =  'db_block_size'
  AND p.inst_id  =  s.inst_id
  AND s.inst_id  =  b.inst_id
  AND d.inst_id  =  s.inst_id
ORDER BY b.start_time;
