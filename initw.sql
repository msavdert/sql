--
--  Copyright (c) Oracle Corporation 1988, 1999.  All Rights Reserved.
--
--  SQL*Plus Global Login startup file.
--
--  Add any sqlplus commands here that are to be executed when a user
--  starts SQL*Plus on your system

--set timing on

-- Used by Trusted Oracle
column ROWLABEL format A15

-- Used for the SHOW ERRORS command
column LINE/COL format A8
column ERROR    format A65  WORD_WRAPPED

-- Used for the SHOW SGA command
column name_col_plus_show_sga format a24

-- Defaults for SHOW PARAMETERS
column name_col_plus_show_param format a36 heading NAME
column type_col_plus_show_param format a36 heading TYPE
column value_col_plus_show_param format a60 heading VALUE

-- For backward compatibility
set pagesize 14
--SET SQLPLUSCOMPATIBILITY 10.1.0

-- Defaults for SET AUTOTRACE EXPLAIN report
column id_plus_exp format 990 heading i
column parent_id_plus_exp format 990 heading p
column plan_plus_exp format a60
column object_node_plus_exp format a8
column other_tag_plus_exp format a29
column other_plus_exp format a44
set numwidth 9
set linesize 1024
set pagesize 40
set arraysize 1
set termout off
set verify off
set feedback on
serveroutput on
set feedback off

SET sqlformat ansiconsole

set termout off
define new_prompt='nolog'
define_editor = "C:\Windows\System32\notepad.exe"
column value new_value new_prompt
select username || '@' ||
  substr(instance_name,
    1,
    DECODE(instr(instance_name, '.'), 0, LENGTH(instance_name), instr(instance_name,'.') - 1)
  )
  value
from  v$instance, user_users;
set sqlprompt "&new_prompt> "
set termout on
ALTER SESSION SET NLS_DATE_FORMAT='YYY-MM-DD HH24:MI:SS'; 
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS.FF'; 
set feedback on

@https://raw.githubusercontent.com/msavdert/sql/master/i.sql
