--http://www.kursatonsoz.com/2015/10/30/oracle-database-fast-tuning/

WITH t1
        AS (  SELECT pool "MEMORY_TYPE",
                     Total_Mem "ALLOCATION_K",
                     Free_Mem "FREE_K",
                     '|||' "A",
                     RUBRIQUE "MEMORY_RATIOS",
                     TO_CHAR (ROUND (RATIO * 100, 1), '999.9') "RATIO_PERCENT",
                     TRIM (IDEAL) "IDEAL"
                FROM
                     (SELECT rownum0,
                             A.pool,
                             A.Total_Mem,
                             B.Free_Mem
                        FROM (SELECT (ROWNUM) rownum0, A.*
                                FROM (  SELECT pool,
                                               ROUND (SUM (bytes) / 1024, 0)
                                                  Total_Mem
                                          FROM v$sgastat
                                         WHERE pool IS NOT NULL
                                      GROUP BY pool
                                      UNION
                                      SELECT name, ROUND (bytes / 1024)
                                        FROM v$sgastat
                                       WHERE     pool IS NULL
                                             AND name != 'fixed_sga') A
                              UNION ALL
                              SELECT 6,
                                     'Sort Area Size',
                                     ROUND (VALUE / 1024, 0)
                                FROM v$parameter
                               WHERE name IN ('sort_area_size')
                              UNION ALL
                              SELECT 7,
                                     'Hash Area Size',
                                     ROUND (VALUE / 1024, 0)
                                FROM v$parameter
                               WHERE name IN ('hash_area_size')) A,
                             (SELECT pool, ROUND (bytes / 1024, 0) Free_Mem
                                FROM v$sgastat
                               WHERE name = 'free memory'
                              UNION ALL
                              SELECT 'db_block_buffers',
                                       (SELECT COUNT (*)
                                          FROM v$bh
                                         WHERE status = 'free')
                                     * (SELECT (ROUND (VALUE / 1024, 0))
                                          FROM v$parameter
                                         WHERE name = 'db_block_size')
                                FROM DUAL) B
                       WHERE A.pool = B.pool(+)) SGA,
                     (SELECT 6 rownum0,
                             'DATA DICTIONARY CACHE' "RUBRIQUE",
                             SUM (getmisses) / SUM (gets) "RATIO",
                             ' < 150' "IDEAL"
                        FROM v$rowcache
                      UNION ALL
                      SELECT 3,
                             'SHARED POOL HIT RATIO',
                             SUM (pinhits - reloads) / SUM (pins),
                             ' > 850'
                        FROM v$librarycache
                      UNION ALL
                      SELECT 4,
                             'SHARED POOL RELOAD %',
                             SUM (reloads) / SUM (pins),
                             ' <  020'
                        FROM v$librarycache
                      UNION ALL
                      SELECT 2,
                             'BUFFER CACHE Hit Ratio',
                             (  1
                              - (  SUM (
                                      DECODE (name, 'physical reads', VALUE, 0))
                                 / (  SUM (
                                         DECODE (name,
                                                 'db block gets', VALUE,
                                                 0))
                                    + (SUM (
                                          DECODE (name,
                                                  'consistent gets', VALUE,
                                                  0)))))),
                             ' > 950'
                        FROM v$sysstat
                      UNION ALL
                      SELECT 1,
                             'BUFFER CACHE MISS RATIO',
                             ( (G - F) / (G - F + C + E)),
                             ' < 150'
                        FROM (SELECT SUM (VALUE) C
                                FROM v$sysstat
                               WHERE name LIKE '%- consistent read gets') c,
                             (SELECT VALUE E
                                FROM v$sysstat
                               WHERE name = 'db block gets') e,
                             (SELECT VALUE F
                                FROM v$sysstat
                               WHERE name = 'physical reads direct') f,
                             (SELECT VALUE G
                                FROM v$sysstat
                               WHERE name = 'physical reads') g
                      UNION ALL
                      SELECT 5,
                             'LOG BUFFER REQUESTS Ratio',
                             ( (req.VALUE * 50) / entries.VALUE),
                             ' < 002'
                        FROM v$sysstat req, v$sysstat entries
                       WHERE     req.name = 'redo log space requests'
                             AND entries.name = 'redo entries'
                      UNION ALL
                      SELECT 7,
                             'MEM SORTS/TOTAL SORTS',
                             mem.VALUE / (mem.VALUE + disk.VALUE),
                             ' > 950'
                        FROM v$sysstat mem, v$sysstat disk
                       WHERE     mem.name = 'sorts (memory)'
                             AND disk.name = 'sorts (disk)') RATIOS
               WHERE SGA.rownum0(+) = RATIOS.ROWNUM0
            ORDER BY SGA.rownum0 ASC)
   SELECT memory_type,
          allocation_k,
          free_k,
          memory_ratios,
          TRUNC (
               CAST (REGEXP_REPLACE (RATIO_PERCENT, '[^0-9]+', '') AS NUMBER)
             / 10,
             2)
             ratio,
          TRUNC (
               CAST (
                  REGEXP_REPLACE (TRIM (SUBSTR (ideal, -4, 4)),
                                  '[^0-9]+',
                                  '') AS NUMBER)
             / 10,
             2)
             optimum,
          SUBSTR (TRIM (ideal), 0, 1) SIGN,
          DECODE (
             (SUBSTR (TRIM (ideal), 0, 1)),
             '<', (DECODE (
                      SIGN (
                           (TRUNC (
                                 CAST (
                                    REGEXP_REPLACE (RATIO_PERCENT,
                                                    '[^0-9]+',
                                                    '') AS NUMBER)
                               / 10,
                               2))
                         - (TRUNC (
                                 CAST (
                                    REGEXP_REPLACE (
                                       TRIM (SUBSTR (ideal, -4, 4)),
                                       '[^0-9]+',
                                       '') AS NUMBER)
                               / 10,
                               2))),
                      -1, 'SUPER',
                      0, 'KRITIK',
                      1, 'KOTU')),
             '>', (DECODE (
                      SIGN (
                           (TRUNC (
                                 CAST (
                                    REGEXP_REPLACE (RATIO_PERCENT,
                                                    '[^0-9]+',
                                                    '') AS NUMBER)
                               / 10,
                               2))
                         - (TRUNC (
                                 CAST (
                                    REGEXP_REPLACE (
                                       TRIM (SUBSTR (ideal, -4, 4)),
                                       '[^0-9]+',
                                       '') AS NUMBER)
                               / 10,
                               2))),
                      -1, 'KOTU',
                      0, 'KRITIK',
                      1, 'SUPER')))
             durum
     FROM t1;
