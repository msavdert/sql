select tablespace_name,round(tablespace_size*8/1024) tablespace_size,round(used_space*8/1024) used_space,
    case 
        when used_percent > 95 then '@|red '||round(used_percent)||'|@'
        else ''||round(used_percent)||''
    end as used_pct
from dba_tablespace_usage_metrics order by round(used_percent) desc;
