/*
generate a query to get cardinality and other details of each column of a table
use like this:
  usql -X -t -A -vSHOW_HOST_INFORMATION=false -f ~/sql/stats.sql  "trino://localhost:8080/rds/public" 2>/dev/null | \
  usql -X -x "trino://localhost:8080/rds/public"
example output:
-[ RECORD 30 ]--------------------------------------------------------------------------------------------
 table    | public.steps
 column   | conclusion
 type     | varchar
 total    | 554044
 nonempty | 554044
 uniq     | 5
 min      | cancelled
 max      | success
 q25      |
 q50      |
 q75      |
 avg      | 0
 stddev   | 0
 var      | 0
 top3     | {                                                                                            +
          |   "cancelled": 3683,                                                                         +
          |   "skipped": 49479,                                                                          +
          |   "success": 496618                                                                          +
          | }
-[ RECORD 31 ]--------------------------------------------------------------------------------------------
 table    | public.steps
 column   | job_id
 type     | bigint
 total    | 554044
 nonempty | 554044
 uniq     | 30222
 min      | 1853829466
 max      | 2294967036
 q25      | 2243091670
 q50      | 2253471138
 q75      | 2277025591
 avg      | 2.2071469133226113e+09
 stddev   | 1.2863407062211637e+08
 var      | 1.6546724124815624e+16
 top3     | {                                                                                            +
          |   "1923194580": 564,                                                                         +
          |   "1923194733": 564,                                                                         +
          |   "1951662086": 564                                                                          +
          | }
 */
SELECT replace(array_join(s, '\nUNION ALL\n'), '\n', u&'\000a') || ';' FROM (
    SELECT array_agg(
        'SELECT\n' ||
          '  ''' || table_schema || '.' || table_name || ''' AS "table",\n' ||
          '  ''' || column_name || ''' AS column,\n' ||
          '  ''' || data_type || ''' AS type,\n' ||
          '  count(*) AS total,\n' ||
          '  count(' || column_name || ') AS nonempty,\n' ||
          '  approx_distinct(' || column_name || ') AS uniq,\n' ||
          '  cast(min(' || column_name || ') AS varchar) AS min,\n' ||
          '  cast(max(' || column_name || ') AS varchar) AS max,\n' ||
          CASE WHEN data_type NOT IN ('varchar', 'date', 'timestamp') AND data_type NOT LIKE 'timestamp% with time zone' THEN
          '  cast(approx_percentile(' || column_name || ', 0.25) AS varchar) AS q25,\n' ||
          '  cast(approx_percentile(' || column_name || ', 0.5) AS varchar) AS q50,\n' ||
          '  cast(approx_percentile(' || column_name || ', 0.75) AS varchar) AS q75,\n'
          ELSE
          '  '''' AS q25,\n' ||
          '  '''' AS q50,\n' ||
          '  '''' AS q75,\n'
          END ||
          CASE WHEN data_type NOT IN ('varchar', 'date', 'timestamp') AND data_type NOT LIKE 'timestamp% with time zone' THEN
          '  avg(' || column_name || ') AS avg,\n' ||
          '  stddev(' || column_name || ') AS stddev,\n' ||
          '  variance(' || column_name || ') AS var,\n'
          ELSE
          '  0 AS avg,\n' ||
          '  0 AS stddev,\n' ||
          '  0 AS var,\n'
          END ||
          '  approx_most_frequent(3, cast(' || column_name || ' AS varchar), 1000) AS top3\n' ||
          'FROM ' || table_catalog || '.' || table_schema || '.' || table_name
        ORDER BY table_catalog, table_schema, table_name, ordinal_position
    ) AS s
    FROM information_schema.columns
    WHERE table_schema != 'information_schema'
);
