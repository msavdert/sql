SET SERVEROUTPUT ON
declare
stmt_task VARCHAR2(40);
begin
stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(sql_id => '&sql_id', time_limit => 3600);
DBMS_OUTPUT.put_line('task_id: ' || stmt_task );
dbms_output.new_line();
DBMS_OUTPUT.put_line('You can execute task using below syntax');
DBMS_OUTPUT.put_line('begin DBMS_SQLTUNE.EXECUTE_TUNING_TASK(task_name => '''||stmt_task||''') end;');
dbms_output.new_line();
DBMS_OUTPUT.put_line('You can monitor task status using below syntax');
DBMS_OUTPUT.put_line('SELECT task_name, status, pct_completion_time FROM dba_advisor_log WHERE task_name = '''||stmt_task||''');');
dbms_output.new_line();
DBMS_OUTPUT.put_line('You can check advisor recommendations using below syntax');
DBMS_OUTPUT.put_line('SELECT DBMS_SQLTUNE.report_tuning_task( '''||stmt_task||''') AS recommendations FROM dual;');
end;
/
