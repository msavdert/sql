col username noprint new_value user
col instance_name noprint new_value _instance_name
col inst noprint new_value _inst
col sid noprint new_value _sid
col serial noprint new_value _serial
col spid noprint new_value _spid

select
   s.username username,
-- i.instance_name instance_name,
   (CASE WHEN TO_NUMBER(SUBSTR(i.version, 1, instr(i.version,'.',1)-1)) >= 12 THEN (SELECT SYS_CONTEXT('userenv', 'con_name') FROM dual)||'-'||i.instance_name ELSE i.instance_name END) instance_name,
   i.host_name host_name,
   i.instance_number inst,
   to_char(s.sid) sid,
   to_char(s.serial#) serial,
   (select substr(banner, instr(banner, 'Release ')+8,10) from v$version where rownum = 1) release,
-- (select  substr(substr(banner, instr(banner, 'Release ')+8),1,instr(substr(banner, instr(banner, 'Release ')+8),'.')-1) from v$version where rownum = 1) myoraver,
   to_char(startup_time, 'DD-MON-YY') startup_day,
   trim(p.spid) spid,
   trim(to_char(p.pid)) opid,
   s.process cpid,
   sys_context('userenv', 'database_role') db_role
from
  v$session s,
  v$instance i,
  v$process p
where
  s.paddr = p.addr
and
  sid = (select sid from v$mystat where rownum = 1);

host title &user@&_instance_name [inst=&_inst sid=&_sid ser#=&_serial spid=&_spid]
