break on report on disk_group_name skip 1
compute sum label "Grand Total: " of "Total|GB" "Free|GB" on report

prompt
prompt ASM Disk Groups
prompt ===============
SELECT g.group_number  "Group"
,      g.name          "Group Name"
,      g.state         "State"
,      g.type          "Type"
--,      g.total_mb/1024 "Total GB"
--,      g.free_mb/1024  "Free GB"
,      (g.total_mb/decode(g.type,'NORMAL',2,'HIGH',3,'EXTERN',1)/1024) Total_GB
,      (g.free_mb/decode(g.type,'NORMAL',2,'HIGH',3,'EXTERN',1)/1024) Free_GB
--,      ROUND(((g.free_mb/decode(g.type,'NORMAL',2,'HIGH',3,'EXTERN',1))/(g.total_mb/decode(g.type,'NORMAL',2,'HIGH',3,'EXTERN',1)))*100,2) ||'%' PCT
,      100*(max((d.total_mb-d.free_mb)/d.total_mb)-min((d.total_mb-d.free_mb)/d.total_mb))/max((d.total_mb-d.free_mb)/d.total_mb) "Imbalance"
,      100*(max(d.total_mb)-min(d.total_mb))/max(d.total_mb) "Variance"
,      100*(min(d.free_mb/d.total_mb)) "MinFree"
,      100*(max(d.free_mb/d.total_mb)) "MaxFree"
,      count(*)        "DiskCnt"
FROM v$asm_disk d, v$asm_diskgroup g
WHERE d.group_number = g.group_number and
d.group_number <> 0 and
d.state = 'NORMAL' and
d.mount_status = 'CACHED'
GROUP BY g.group_number, g.name, g.state, g.type, g.total_mb, g.free_mb
ORDER BY 1;

prompt ASM Disks In Use
prompt ================

select group_number  "Group"
,      disk_number   "Disk"
,      header_status "Header"
,      mode_status   "Mode"
,      state         "State"
,      create_date   "Created"
,      redundancy    "Redundancy"
,      total_mb/1024 "Total GB"
,      free_mb/1024  "Free GB"
,      name          "Disk Name"
--,      failgroup     "Failure Group"
,      path          "Path"
--,      read_time     "ReadTime"
--,      write_time    "WriteTime"
--,      bytes_read/1073741824    "BytesRead"
--,      bytes_written/1073741824 "BytesWrite"
--,      read_time/reads "SecsPerRead"
--,      write_time/writes "SecsPerWrite"
from   v$asm_disk_stat
where header_status not in ('FORMER','CANDIDATE')
order by group_number
,        disk_number
/
 
Prompt File Types in Diskgroups
Prompt ========================

 
select g.name                                   "Group Name"
,      f.TYPE                                   "File Type"
,      f.BLOCK_SIZE/1024||'k'                   "Block Size"
,      f.STRIPED
,        count(*)                               "Files"
,      round(sum(f.BYTES)/(1024*1024*1024),2)   "Gb"
from   v$asm_file f,v$asm_diskgroup g
where  f.group_number=g.group_number
group by g.name,f.TYPE,f.BLOCK_SIZE,f.STRIPED
order by 1,2;
clear break
 
prompt Instances currently accessing these diskgroups
prompt ==============================================

select c.group_number  "Group"
,      g.name          "Group Name"
,      c.instance_name "Instance"
from   v$asm_client c
,      v$asm_diskgroup g
where  g.group_number=c.group_number
/
 
prompt Free ASM disks and their paths
prompt ==============================
select header_status                   "Header"
, mode_status                     "Mode"
, path                            "Path"
, lpad(round(os_mb/1024),7)||'Gb' "Disk Size"
from   v$asm_disk
where header_status in ('FORMER','CANDIDATE')
order by path
/
 
prompt Current ASM disk operations
prompt ===========================
select *
from   v$asm_operation
/
