-- ascii_bar is like bar but doesn't use ASCII escape codes
CREATE OR REPLACE FUNCTION ascii_bar(num BIGINT, max_num BIGINT)
    RETURNS VARCHAR
    DETERMINISTIC
    RETURNS NULL ON NULL INPUT
    RETURN array_join(repeat('|', CAST(100 * num / max_num AS integer)), '');

WITH
data AS (
    SELECT s.num
    FROM table(sequence(start=>1, stop=>10, step=>2)) AS s(num)
)
SELECT
    data.num
  , ascii_bar(data.num, max(data.num) OVER ()) AS chart
FROM data
ORDER BY data.num;

/* expected output:
CREATE FUNCTION
 num |                                                chart
-----+------------------------------------------------------------------------------------------------------
   1 | |||||||||||
   3 | |||||||||||||||||||||||||||||||||
   5 | |||||||||||||||||||||||||||||||||||||||||||||||||||||||
   7 | |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
   9 | ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
(5 rows)
*/
