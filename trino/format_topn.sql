-- format_topn makes it easier to print results for approx_most_frequent in descending order
CREATE OR REPLACE FUNCTION format_topn(input map<varchar, bigint>)
    RETURNS VARCHAR
    NOT DETERMINISTIC
    RETURNS NULL ON NULL INPUT
    BEGIN
    DECLARE freq_separator VARCHAR DEFAULT '=';
    DECLARE entry_separator VARCHAR DEFAULT ', ';
    RETURN array_join(transform(
            reverse(array_sort(transform(
                transform(
                    map_entries(input),
                    r -> cast(r AS row(key varchar, value bigint))
                ),
                r -> cast(row(r.value, r.key) AS row(value bigint, key varchar)))
            )),
            r -> r.key || freq_separator || cast(r.value as varchar)),
        entry_separator);
    END;

WITH
data AS (
    SELECT lpad('', 3, chr(65+(s.num / 3))) AS value
    FROM table(sequence(start=>1, stop=>10)) AS s(num)
)
, aggregated AS (
    SELECT
        array_agg(data.value ORDER BY data.value) AS all_values
      , approx_most_frequent(3, data.value, 1000) AS top3
    FROM data
)
SELECT
    a.all_values
  , a.top3
  , format_topn(a.top3) AS top3_formatted
FROM aggregated a;

/* expected output:
CREATE FUNCTION
                     all_values                     |         top3          |        _col2
----------------------------------------------------+-----------------------+---------------------
 [AAA, AAA, BBB, BBB, BBB, CCC, CCC, CCC, DDD, DDD] | {AAA=2, CCC=3, BBB=3} | CCC=3, BBB=3, AAA=2
(1 row)
*/
