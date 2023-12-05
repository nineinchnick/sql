-- vertical_bar draws a vertical bar based on the value between 0 and 1 (inclusive)
CREATE OR REPLACE FUNCTION vertical_bar(value DOUBLE)
    RETURNS VARCHAR
    DETERMINISTIC
    RETURNS NULL ON NULL INPUT
    -- map [0.0, 1.0] to [1, 9]
    RETURN ARRAY[' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'][cast(value * 8 + 1 as int)];

WITH
data AS (
    SELECT s.num / 10.0 AS num
    FROM table(sequence(start=>0, stop=>10, step=>1)) AS s(num)
)
SELECT
    data.num
  , vertical_bar(data.num) AS chart
FROM data
UNION ALL
SELECT
    11
  , (SELECT array_join(array_agg(vertical_bar(num) ORDER BY num), '') FROM data)
ORDER BY num;

/* expected output:
CREATE FUNCTION
 num  |    chart
------+-------------
  0.0 |
  0.1 | ▁
  0.2 | ▂
  0.3 | ▂
  0.4 | ▃
  0.5 | ▄
  0.6 | ▅
  0.7 | ▆
  0.8 | ▆
  0.9 | ▇
  1.0 | █
 11.0 |  ▁▂▂▃▄▅▆▆▇█
(12 rows)
*/

