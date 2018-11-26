SELECT ts.tablespace_name,
  NVL(s.count,0) objects,
  ts.files,
  (ts.files - ts.no_of_autoextend_files) AS "NONAUTOEXTENSIBLE_FILES",
  ts.allocated/1024/1024 allocated_mb,
  ROUND((ts.allocated -NVL(ts.free_size,0))/1024/1024,3) used_mb,
  ROUND(((ts.allocated/1024/1024)-((ts.allocated-NVL(ts.free_size,0))/1024/1024))*100/(ts.allocated/1024/1024),2) alloc_free_pct,
  ROUND(maxbytes/1024/1024,3) max_size_mb,
  ROUND((maxbytes-(ts.allocated-NVL(ts.free_size,0)))/1024/1024,3) max_free_mb,
  ROUND((maxbytes-(ts.allocated-NVL(ts.free_size,0)))*100/maxbytes,2) max_free_pct,
  'ALTER TABLESPACE ' ||ts.tablespace_name||' ADD DATAFILE ''+DATA'' SIZE 1M AUTOEXTEND ON NEXT 512M MAXSIZE UNLIMITED;' Script
FROM
  (SELECT dfs.tablespace_name,
    files,
    ddf.no_of_autoextend_files,
    allocated,
    free_size,
    maxbytes
  FROM
    (SELECT fs.tablespace_name,
      SUM(fs.bytes) free_size
    FROM dba_free_space fs
    GROUP BY fs.tablespace_name
    ) dfs,
    (SELECT df.tablespace_name,
      COUNT(*) files,
      SUM(df.bytes) allocated,
      SUM(decode(autoextensible, 'YES', 1, 0)) no_of_autoextend_files,
      SUM(DECODE(df.maxbytes,0,df.bytes,df.maxbytes)) maxbytes,
      MAX(autoextensible) autoextensible
    FROM dba_data_files df
    WHERE df.status = 'AVAILABLE'
    GROUP BY df.tablespace_name
    ) ddf
  WHERE dfs.tablespace_name = ddf.tablespace_name
  UNION
  SELECT dtf.tablespace_name,
    files,
    no_of_autoextend_files,
    allocated,
    free_size,
    maxbytes
  FROM
    (SELECT tf.tablespace_name,
      COUNT(*) files,
      SUM(tf.bytes) allocated,
      SUM(DECODE(tf.maxbytes,0,tf.bytes,tf.maxbytes)) maxbytes,
      MAX(autoextensible) autoextensible
    FROM dba_temp_files tf
    GROUP BY tf.tablespace_name
    ) dtf,
    (SELECT th.tablespace_name,
      0 as no_of_autoextend_files,
      SUM (th.bytes_free) free_size
    FROM v$temp_space_header th
    GROUP BY tablespace_name
    ) tsh
  WHERE dtf.tablespace_name = tsh.tablespace_name
  ) ts,
  (SELECT s.tablespace_name,
    COUNT(*) COUNT
  FROM dba_segments s
  GROUP BY s.tablespace_name
  ) s,
  dba_tablespaces dt,
  v$parameter p
WHERE p.name           = 'db_block_size'
AND ts.tablespace_name = dt.tablespace_name
AND ts.tablespace_name = s.tablespace_name (+)
AND ts.tablespace_name <> 'TEMP'
ORDER BY max_free_pct;
