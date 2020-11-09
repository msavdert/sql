SELECT p.inst_id, p.spid,
       p.pid,
       s.sid,
       s.serial#,
       s.status,
       p.pga_alloc_mem,
       p.pga_used_mem,
       s.username,
       s.osuser,
       s.program, s.machine, s.sql_id
FROM gv$process p, gv$session s
WHERE p.inst_id=s.inst_id
and s.paddr( + ) = p.addr
AND p.background is null /* Remove if need to monitor background processes */
ORDER BY p.pga_alloc_mem DESC;
