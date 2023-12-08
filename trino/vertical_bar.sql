-- vertical_bar draws a vertical bar based on the value between 0 and 1 (inclusive)
CREATE OR REPLACE FUNCTION vertical_bar(value DOUBLE)
    RETURNS VARCHAR
    DETERMINISTIC
    RETURNS NULL ON NULL INPUT
    -- map [0.0, 1.0] to [1, 9]
    RETURN ARRAY[' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'][cast(value * 8 + 1 as int)];

WITH
measurements(sensor_id, recorded_at, value) AS (
    VALUES
        ('A', date '2023-01-01', 5.0)
      , ('A', date '2023-01-03', 7.0)
      , ('A', date '2023-01-04', 15.0)
      , ('A', date '2023-01-05', 14.0)
      , ('A', date '2023-01-08', 10.0)
      , ('A', date '2023-01-09', 1.0)
      , ('A', date '2023-01-10', 7.0)
      , ('A', date '2023-01-11', 8.0)
      , ('B', date '2023-01-03', 2.0)
      , ('B', date '2023-01-04', 3.0)
      , ('B', date '2023-01-05', 2.5)
      , ('B', date '2023-01-07', 2.75)
      , ('B', date '2023-01-09', 4.0)
      , ('B', date '2023-01-10', 1.5)
      , ('B', date '2023-01-11', 1.0)
)
, days AS (
    SELECT date_add('day', s.num, date '2023-01-01') AS day
    -- table function arguments need to be constant but range could be calculated
    -- using: SELECT date_diff('day', max(recorded_at), min(recorded_at)) FROM measurements
    FROM table(sequence(start=>0, stop=>10)) AS s(num)
)
, sensors(id) AS (VALUES ('A'), ('B'))
, normalized AS (
    SELECT
        sensors.id AS sensor_id
      , days.day
      , value
      , value / max(value) OVER (PARTITION BY sensor_id) AS normalized
    FROM days
    CROSS JOIN sensors
    LEFT JOIN measurements m ON day = recorded_at AND m.sensor_id = sensors.id
)
SELECT
      sensor_id
    , min(day) AS start
    , max(day) AS stop
    , count(value) AS num_values
    , min(value) AS min_value
    , max(value) AS max_value
    , avg(value) AS avg_value
    , array_join(array_agg(coalesce(vertical_bar(normalized), ' ') ORDER BY day), '') AS distribution
FROM normalized
WHERE sensor_id IS NOT NULL
GROUP BY sensor_id
ORDER BY sensor_id;

/* expected output:
CREATE FUNCTION
 sensor_id |   start    |    stop    | num_values | min_value | max_value | avg_value | distribution
-----------+------------+------------+------------+-----------+-----------+-----------+--------------
 A         | 2023-01-01 | 2023-01-11 |          8 |      1.00 |     15.00 |      8.38 | ▃ ▄█▇  ▅▁▄▄
 B         | 2023-01-01 | 2023-01-11 |          7 |      1.00 |      4.00 |      2.39 |   ▄▆▅ ▆ █▃▂
(2 rows)
*/

