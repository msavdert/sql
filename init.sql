SET sqlprompt "_user'@'_connect_identifier>"
SET sqlformat ansiconsole
-- 1 rows selected.
SET FEEDBACK OFF
--old value > new value
SET VERIFY OFF
SET LINES 999 PAGES 999
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET NLS_LANGUAGE='AMERICAN';

alias load https://raw.githubusercontent.com/msavdert/sql/master/aliases.xml

@https://raw.githubusercontent.com/msavdert/sql/master/whoami.sql

--Define
--define r=https://raw.githubusercontent.com/msavdert/sql/master
-- aliases.xml
--alias ac=@&r\ac;
--alias desc ac Active Sessions
--alias backup=@&r\backup :DAY;
--alias desc backup backup <DAY> - show last N DAY Backup 
