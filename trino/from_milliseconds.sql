-- from_milliseconds is the reverse of to_milliseconds
CREATE OR REPLACE FUNCTION from_milliseconds(milliseconds BIGINT)
    RETURNS INTERVAL DAY TO SECOND
    DETERMINISTIC
    RETURNS NULL ON NULL INPUT
    RETURN parse_duration(cast(milliseconds as varchar) || 'ms');

WITH
data AS (
    SELECT s.num
    FROM table(sequence(start=>1, stop=>1000000, step=>100000)) AS s(num)
)
SELECT
    data.num
  , from_milliseconds(data.num) AS chart
FROM data
ORDER BY data.num;

/* expected output:
CREATE FUNCTION
  num   |     chart
--------+----------------
      1 | 0 00:00:00.001
 100001 | 0 00:01:40.001
 200001 | 0 00:03:20.001
 300001 | 0 00:05:00.001
 400001 | 0 00:06:40.001
 500001 | 0 00:08:20.001
 600001 | 0 00:10:00.001
 700001 | 0 00:11:40.001
 800001 | 0 00:13:20.001
 900001 | 0 00:15:00.001
(10 rows)
*/
