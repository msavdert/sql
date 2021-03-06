SELECT INST_ID,NVL(component,'TOTAL SGA') component , trim(to_char(SUM( current_size / 1024 / 1024), '999,999,999,999')) current_size
  FROM gv$sga_dynamic_components
 WHERE current_size <> 0
GROUP BY INST_ID,ROLLUP (COMPONENT)
ORDER BY INST_ID, current_size DESC;

SELECT 
  INST_ID,  
  TRIM(TO_CHAR(SGA_SIZE, '999,999,999,999'))  SGA_SIZE,
  to_char(SGA_SIZE_FACTOR) SGA_SIZE_FACTOR,
  TRIM(TO_CHAR(ESTD_DB_TIME, '999,999,999,999')) ESTD_DB_TIME,
  TO_CHAR(ESTD_DB_TIME_FACTOR) ESTD_DB_TIME_FACTOR,
  TRIM(TO_CHAR(ESTD_PHYSICAL_READS, '999,999,999,999')) ESTD_PHYSICAL_READS
FROM GV$SGA_TARGET_ADVICE
ORDER BY INST_ID,SGA_SIZE_FACTOR;
