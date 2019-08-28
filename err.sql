SELECT
    username,
    error_number,
    substr(error_text, 1,30) error_text,
    instance_number inst_id,
    substr(sql_text, 1,6) sql_text,
    session_user,
    current_user,
    current_schema,
    host,
    ip_address,
    os_user,
    terminal,
    service_name,
    to_char(error_date, 'DD/MON/YY HH24:MI:SS') error_date
FROM
    sys.ins_error_summary
WHERE
    error_date > sysdate - :1 / 1440
ORDER BY
    error_date DESC;
