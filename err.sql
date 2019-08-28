select * from SYS.INS_ERROR_SUMMARY where error_date > sysdate-:1/1440 order by error_date desc;
