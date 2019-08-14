select tablespace_name,tablespace_size,used_space,
    case 
        when used_percent > 95 then '@|bg_red '||round(used_percent)||'|@'
        else ''||round(used_percent)||''
    end as ts_usage_percentage
from dba_tablespace_usage_metrics order by 4 desc;
