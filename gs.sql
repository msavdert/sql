SET sqlformat
SELECT sql_fulltext FROM gv$sqlarea WHERE sql_id=:sql_id AND rownum=1;
SET sqlformat ansiconsole
