SET sqlprompt "_user'@'_connect_identifier >"
SET sqlformat ansiconsole
-- 1 rows selected.
SET FEEDBACK OFF
--old value > new value
SET VERIFY OFF
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET NLS_LANGUAGE='AMERICAN';
@https://raw.githubusercontent.com/msavdert/sql/master/i.sql
--Define
define r=https://raw.githubusercontent.com/msavdert/sql/master
alias ac=@&r\ac;
alias bck2=@&r\backup :DAY;
