SET sqlprompt "_user'@'_connect_identifier>"
SET sqlformat ansiconsole
-- 1 rows selected.
SET FEEDBACK OFF
--old value > new value
SET VERIFY OFF
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET NLS_LANGUAGE='AMERICAN';
--@https://raw.githubusercontent.com/msavdert/sql/master/i.sql
--Define
define r=https://raw.githubusercontent.com/msavdert/sql/master

-- aliases.xml
alias ac=@&r\ac;
alias desc ac Active Sessions
alias backup=@&r\backup :DAY;
alias desc backup backup <DAY> - show last N DAY Backup 
