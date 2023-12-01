SELECT
  node
  , transform(
      regexp_extract_all(heapmemoryusage, '[a-z]+=\d+'),
      value -> row(
        split_part(value, '=', 1),
        format_number(cast(split_part(value, '=', 2) as bigint))
      )
    )
FROM "java.lang:type=memory"
ORDER BY node
;
