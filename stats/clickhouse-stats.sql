/*
generate a query to get cardinality and other details of each column of a table
use like this:
  cat details.sql | \
  clickhouse --client --user setup --password heimdall --database platform --format PrettySpace | \
  tail -n +3 | \
  clickhouse --client --user setup --password heimdall --database platform --format PrettyCompactMonoBlock
example output:
┌─type────┬─comp───┬─uncomp─┬─name──────────┬─total─┬─nonempty─┬──uniq─┬─min────────┬─q25────────┬─q50────────┬─q75────────┬─max─────────┬────────────────avg─┬────────────stddev─┬─top3─────────────────────────────────────────────────────────────────────────────┐
│ String  │ 9140   │ 812835 │ short_name    │ 47785 │    47785 │    15 │            │            │            │            │             │                  0 │                 0 │ ['node_filesystem_free','node_cpu','ready_check']                                │
│ Date    │ 610    │ 95570  │ date          │ 47785 │    47785 │     1 │ 2018-11-22 │ 2018-11-22 │ 2018-11-22 │ 2018-11-22 │ 2018-11-22  │                  0 │                 0 │ ['2018-11-22']                                                                   │
│ Float64 │ 120445 │ 382280 │ value         │ 47785 │    28310 │ 10596 │ 0          │ 0          │ 1          │ 111.0725   │ 21929504768 │ 2002020845.2927737 │ 5628205853.271457 │ ['0','1','10664574976']                                                          │
│ String  │ 373    │ 47785  │ workload_ip   │ 47785 │        0 │     1 │            │            │            │            │             │                  0 │                 0 │ ['']                                                                             │
│ String  │ 373    │ 47785  │ workload_port │ 47785 │        0 │     1 │            │            │            │            │             │                  0 │                 0 │ ['']                                                                             │
│ String  │ 373    │ 47785  │ port          │ 47785 │        0 │     1 │            │            │            │            │             │                  0 │                 0 │ ['']                                                                             │
│ String  │ 983    │ 49905  │ app           │ 47785 │      265 │     2 │            │            │            │            │             │                  0 │                 0 │ ['','test-app']                                                                  │
│ String  │ 995    │ 51495  │ path          │ 47785 │      265 │     2 │            │            │            │            │             │                  0 │                 0 │ ['','test-http-path']                                                            │
│ String  │ 7155   │ 274117 │ service_name  │ 47785 │     8909 │    18 │            │            │            │            │             │                  0 │                 0 │ ['k8s-traffic-path-svc','k8s-traffic-policy-svc','k8s-traffic-service-ctrl-svc'] │
│ String  │ 6972   │ 244439 │ semver        │ 47785 │     8909 │    18 │            │            │            │            │             │                  0 │                 0 │ ['0.2.0-m.alpha1.1604814','0.5.0-m.alpha1.1544282','']                           │
│ String  │ 5134   │ 119057 │ git_commit_id │ 47785 │     8909 │    18 │            │            │            │            │             │                  0 │                 0 │ ['a3048648','5995216d','ddea203a']                                               │
└─────────┴────────┴────────┴───────────────┴───────┴──────────┴───────┴────────────┴────────────┴────────────┴────────────┴─────────────┴────────────────────┴───────────────────┴──────────────────────────────────────────────────────────────────────────────────┘
 */
SELECT arrayStringConcat(s, '\nUNION ALL\n') FROM (
    SELECT groupArray(
        'SELECT ''' || type || ''' AS type, ''' || cast(data_compressed_bytes, 'String') || ''' AS comp, ''' || cast(data_uncompressed_bytes, 'String') || ''' AS uncomp, ''' || name || ''' AS name, \n' ||
          '  count() AS total,\n' ||
          '  (SELECT count() FROM ' || table || ' WHERE ' || name || ' != ' || CASE WHEN type != 'String' THEN '0' ELSE '''''' END || ') AS nonempty,\n' ||
          '  uniq(' || name || ') AS uniq,\n' ||
          CASE WHEN type != 'String' THEN
          '  cast(min(' || name || '), ''String'') AS min,\n' ||
          '  cast(quantile(0.25)(' || name || '), ''String'') AS q25,\n' ||
          '  cast(quantile(0.5)(' || name || '), ''String'') AS q50,\n' ||
          '  cast(quantile(0.75)(' || name || '), ''String'') AS q75,\n' ||
          '  cast(max(' || name || '), ''String'') AS max,\n'
          ELSE
          '  '''' AS min,\n' ||
          '  '''' AS q25,\n' ||
          '  '''' AS q50,\n' ||
          '  '''' AS q75,\n' ||
          '  '''' AS max,\n'
          END ||
          CASE WHEN type NOT IN ('String', 'Date', 'DateTime') THEN
          '  avg(' || name || ') AS avg,\n' ||
          '  stddevSamp(' || name || ') AS stddev,\n'
          ELSE
          '  0 AS avg,\n' ||
          '  0 AS stddev,\n'
          END ||
          '  cast(topK(3)(' || name || '), ''Array(String)'') AS top3\n' ||
          'FROM ' || database || '.' || table
    ) AS s
    FROM system.columns
    WHERE database = 'platform' AND table = 'measures'
)
