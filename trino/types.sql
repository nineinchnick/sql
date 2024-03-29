SELECT
    false AS col_bool
  , cast(null AS BOOLEAN) AS col_bool_null

  , cast(127 AS TINYINT) AS col_tinyint
  , cast(-128 AS TINYINT) AS col_tinyint_min
  , cast(null AS TINYINT) AS col_tinyint_null
  , cast(32767 AS SMALLINT) AS col_smallint
  , cast(-32768 AS SMALLINT) AS col_smallint_min
  , cast(null AS SMALLINT) AS col_smallint_null
  , cast(2147483647 AS INTEGER) AS col_integer
  , cast(-2147483648 AS INTEGER) AS col_integer_min
  , cast(null AS INTEGER) AS col_integer_null
  , cast(9223372036854775807 AS BIGINT) AS col_bigint
  , cast(-9223372036854775808 AS BIGINT) AS col_bigint_min
  , cast(null AS BIGINT) AS col_bigint_null

  , cast(3.4028235E38 AS REAL) AS col_real
  , cast(1.4E-45 AS REAL) as col_real_min
  , cast('Infinity' AS REAL) AS col_real_inf
  , cast('-Infinity' AS REAL) AS col_real_ninf
  , cast('NaN' AS REAL) AS col_real_nan
  , cast(null AS REAL) AS col_real_null
  , cast(1.7976931348623157E308 AS DOUBLE) AS col_double
  , cast(4.9E-324 AS DOUBLE) as col_double_min
  , cast('Infinity' AS DOUBLE) AS col_double_inf
  , cast('-Infinity' AS DOUBLE) AS col_double_ninf
  , cast('NaN' AS DOUBLE) AS col_double_nan
  , cast(null AS DOUBLE) AS col_double_null

  , DECIMAL '10.3' AS col_decimal
  , cast(null AS DECIMAL) AS col_decimal_null
  , cast('0.123456789123456789' AS DECIMAL(18,18)) col_decimal18
  , cast(null AS DECIMAL(18,18)) AS col_decimal18_null
  , cast('10.3' AS DECIMAL(38,0)) col_decimal38
  , cast(null AS DECIMAL(38,0)) AS col_decimal38_null

  , 'aaa' AS col_varchar
  , U&'Hello winter \2603 !' AS col_varchar_uni
  , cast(null AS VARCHAR) AS col_varchar_null
  , cast('bbb' AS VARCHAR(1)) AS col_varchar1
  , cast(null AS VARCHAR(1)) AS col_varchar1_null

  , cast('ccc' AS CHAR) AS col_char
  , cast(null AS CHAR) AS col_char_null
  , cast('ddd' AS CHAR(1)) AS col_char1
  , cast(null AS CHAR(1)) AS col_char1_null

  , X'65683F' AS col_varbinary
  , cast(null AS VARBINARY) AS col_varbinary_null
  , cast('{}' AS JSON) AS col_json
  , cast('null' AS JSON) AS col_json_null2
  , cast(null AS JSON) AS col_json_null

  , DATE '2001-08-22' AS col_date
  , cast(null AS DATE) AS col_date_null

  , TIME '01:23:45.123' AS col_time
  , cast(null AS TIME) AS col_time_null
  , cast('01:23:45' AS TIME(0)) AS col_time0
  , cast(null AS TIME(0)) AS col_time0_null
  , cast('01:23:45.123' AS TIME(3)) AS col_time3
  , cast(null AS TIME(3)) AS col_time3_null
  , cast('01:23:45.123456' AS TIME(6)) AS col_time6
  , cast(null AS TIME(6)) AS col_time6_null
  , cast('01:23:45.123456789' AS TIME(9)) AS col_time9
  , cast(null AS TIME(9)) AS col_time9_null
  , cast('01:23:45.123456789123' AS TIME(12)) AS col_time12
  , cast(null AS TIME(12)) AS col_time12_null

  , TIME '01:23:45.123 -08:00' AS col_timetz
  , cast(null AS TIME WITH TIME ZONE) AS col_timetz_null
  , cast('01:23:45 -08:00' AS TIME(0) WITH TIME ZONE) AS col_timetz0
  , cast(null AS TIME(0) WITH TIME ZONE) AS col_timetz0_null
  , cast('01:23:45.123 -08:00' AS TIME(3) WITH TIME ZONE) AS col_timetz3
  , cast(null AS TIME(3) WITH TIME ZONE) AS col_timetz3_null
  , cast('01:23:45.123456 -08:00' AS TIME(6) WITH TIME ZONE) AS col_timetz6
  , cast(null AS TIME(6) WITH TIME ZONE) AS col_timetz6_null
  , cast('01:23:45.123456789 -08:00' AS TIME(9) WITH TIME ZONE) AS col_timetz9
  , cast(null AS TIME(9) WITH TIME ZONE) AS col_timetz9_null
  , cast('01:23:45.123456789123 -08:00' AS TIME(12) WITH TIME ZONE) AS col_timetz12
  , cast(null AS TIME(12) WITH TIME ZONE) AS col_timetz12_null

  , TIMESTAMP '2001-08-22 01:23:45.123' AS col_ts
  , cast(null AS TIMESTAMP) AS col_ts_null
  , cast('2001-08-22 01:23:45' AS TIMESTAMP(0)) AS col_ts0
  , cast(null AS TIMESTAMP(0)) AS col_ts0_null
  , cast('2001-08-22 01:23:45.123' AS TIMESTAMP(3)) AS col_ts3
  , cast(null AS TIMESTAMP(3)) AS col_ts3_null
  , cast('2001-08-22 01:23:45.123456' AS TIMESTAMP(6)) AS col_ts6
  , cast(null AS TIMESTAMP(6)) AS col_ts6_null
  , cast('2001-08-22 01:23:45.123456789' AS TIMESTAMP(9)) AS col_ts9
  , cast(null AS TIMESTAMP(9)) AS col_ts9_null
  , cast('2001-08-22 01:23:45.123456789123' AS TIMESTAMP(12)) AS col_ts12
  , cast(null AS TIMESTAMP(12)) AS col_ts12_null

  , TIMESTAMP '2001-08-22 01:23:45.123 -08:00' AS col_tstz
  , cast(null AS TIMESTAMP WITH TIME ZONE) AS col_tstz_null
  , cast('2001-08-22 01:23:45 -08:00' AS TIMESTAMP(0) WITH TIME ZONE) AS col_tstz0
  , cast(null AS TIMESTAMP(0) WITH TIME ZONE) AS col_tstz0_null
  , cast('2001-08-22 01:23:45.123 -08:00' AS TIMESTAMP(3) WITH TIME ZONE) AS col_tstz3
  , cast(null AS TIMESTAMP(3) WITH TIME ZONE) AS col_tstz3_null
  , cast('2001-08-22 01:23:45.123456 -08:00' AS TIMESTAMP(6) WITH TIME ZONE) AS col_tstz6
  , cast(null AS TIMESTAMP(6) WITH TIME ZONE) AS col_tstz6_null
  , cast('2001-08-22 01:23:45.123456789 -08:00' AS TIMESTAMP(9) WITH TIME ZONE) AS col_tstz9
  , cast(null AS TIMESTAMP(9) WITH TIME ZONE) AS col_tstz9_null
  , cast('2001-08-22 01:23:45.123456789123 -08:00' AS TIMESTAMP(12) WITH TIME ZONE) AS col_tstz12
  , cast(null AS TIMESTAMP(12) WITH TIME ZONE) AS col_tstz12_null

  , INTERVAL '3' MONTH AS col_int_year
  , cast(null AS INTERVAL YEAR TO MONTH) AS col_int_year_null
  , INTERVAL '2' DAY AS col_int_day
  , cast(null AS INTERVAL DAY TO SECOND) AS col_int_day_null

  , ARRAY['a', 'b', null] AS col_array
  , cast(null AS ARRAY(VARCHAR)) AS col_array_null
  , MAP(ARRAY['a', 'b'], ARRAY[1, null]) AS col_map
  , cast(null AS MAP(VARCHAR, INTEGER)) AS col_map_null
  , cast(ROW(1, 2e0) AS ROW(x BIGINT, y DOUBLE)) AS col_row
  , cast(null AS ROW(x BIGINT, y DOUBLE)) AS col_row_null

  , IPADDRESS '2001:db8::1' AS col_ipaddr
  , cast(null AS IPADDRESS) AS col_ipaddr_null
  , UUID '12151fd2-7586-11e9-8f9e-2a86e4085a59' AS col_uuid
  , cast(null AS UUID) AS col_uuid_null

  , approx_set(1) AS col_hll
  , cast(null AS HyperLogLog) AS col_hll_null
  , cast(approx_set(1) AS P4HyperLogLog) AS col_p4hll
  , cast(null AS P4HyperLogLog) AS col_p4hll_null
  , make_set_digest(1) AS col_setdigest
  , cast(null AS SetDigest) AS col_setdigest_null
  , qdigest_agg(1) AS col_qdigest
  , cast(null AS QDigest(BIGINT)) AS col_qdigest_null
  , tdigest_agg(1) AS col_tdigest
  , cast(null AS TDigest) AS col_tdigest_null
;
