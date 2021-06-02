SELECT
  INST_ID,NAME,
  CASE  WHEN name <> 'cache hit percentage' THEN trim(to_char(VALUE / 1024 / 1024, '999,999,999,999')) ELSE trim(to_char(VALUE, '999,999,999,999')) END SIZE_MB
  FROM gv$pgastat
 WHERE NAME IN ('aggregate PGA target parameter',
                'total PGA allocated',
                'total PGA inuse',
                'maximum PGA allocated',
                'cache hit percentage')
ORDER BY inst_id,value desc;

SELECT
  INST_ID,
  TO_CHAR(PGA_TARGET_FACTOR) PGA_TARGET_FACTOR,
  TRIM(TO_CHAR(PGA_TARGET_FOR_ESTIMATE / 1024 / 1024, '999,999,999,999')) ESTD_SIZE_MB,
  TRIM(TO_CHAR(BYTES_PROCESSED / 1024 / 1024, '999,999,999,999')) MB_PROCESSED,
  TRIM(TO_CHAR(ESTD_TIME, '999,999,999,999')) ESTD_TIME,
  TO_CHAR(ESTD_PGA_CACHE_HIT_PERCENTAGE) PGA_HIT,
  TO_CHAR(ESTD_OVERALLOC_COUNT) PGA_SHORTAGE
FROM GV$PGA_TARGET_ADVICE
ORDER BY INST_ID,PGA_TARGET_FACTOR;
