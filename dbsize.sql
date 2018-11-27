PROMPT Database_size

select
"Reserved_Space(GB)", "Reserved_Space(GB)" - "Free_Space(GB)" "Used_Space(GB)","Free_Space(GB)"
from(
select 
(select round((sum(bytes)/1048576/1024),2) from v$datafile ) "Reserved_Space(GB)",
(select round((sum(bytes)/1048576/1024),2) from dba_free_space) "Free_Space(GB)"
from dual
);
