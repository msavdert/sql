SET sqlprompt "_user'@'_connect_identifier >"
SET sqlformat ansiconsole
SET FEEDBACK OFF
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET NLS_LANGUAGE='AMERICAN';
SET FEEDBACK ON
define r=https://raw.githubusercontent.com/msavdert/sql/master
alias ac=@&r\ac;
alias ac2=@&r\ac2;
alias ts=@&r\ts;
alias smon=@&r\smon;
alias fra=@&r\fra;
alias asm=@&r\asm;
alias ash=@&r\ash;
@https://raw.githubusercontent.com/msavdert/sql/master/i.sql
