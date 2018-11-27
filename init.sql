SET sqlprompt "_user'@'_connect_identifier >"
SET sqlformat ansiconsole
-- 1 rows selected.
SET FEEDBACK OFF
--old value > new value
SET VERIFY OFF
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET NLS_LANGUAGE='AMERICAN';
define r=https://raw.githubusercontent.com/msavdert/sql/master
alias ac=@&r\ac;
alias ac2=@&r\ac2;
alias ts=@&r\ts;
alias smon=@&r\smon;
alias fra=@&r\fra;
alias asm=@&r\asm;
alias ash=@&r\ash;
alias whoami=@&r\whoami;
alias block=@&r\block;
alias dbsize=@&r\dbsize;
alias lops=@&r\lops;
alias rl=@&r\rl;
alias rls=@&r\rls;
alias topsql=@&r\topsql;
@https://raw.githubusercontent.com/msavdert/sql/master/i.sql
