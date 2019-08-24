SET sqlprompt "@|cyan _date _user'@'_connect_identifier> |@"
SET sqlformat ansiconsole -config=https://raw.githubusercontent.com/msavdert/sql/master/highlight.json
-- 1 rows selected.
SET FEEDBACK OFF
--old value > new value
SET VERIFY OFF
-- tek satırda kısıtlama - default 80
SET LONG 9999
SET LONGCHUNKSIZE 250
SET LINES 999 PAGES 999
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET NLS_LANGUAGE='AMERICAN';

alias load https://raw.githubusercontent.com/msavdert/sql/master/aliases.xml

@https://raw.githubusercontent.com/msavdert/sql/master/i.sql

SET FEEDBACK ON
