-- format_data_size_decimal is like format_number but uses IEC8000 units (base 1000)
CREATE OR REPLACE FUNCTION format_data_size(input BIGINT)
    RETURNS VARCHAR
    DETERMINISTIC
    RETURNS NULL ON NULL INPUT
    BEGIN
        DECLARE value DOUBLE DEFAULT CAST(input AS DOUBLE);
        DECLARE result BIGINT;
        DECLARE base INT DEFAULT 1000;
        DECLARE unit VARCHAR DEFAULT 'B';
        DECLARE format VARCHAR;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'KiB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'MiB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'GiB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'TiB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'PiB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'EiB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'ZiB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'YiB';
        END IF;
        IF abs(value) < 10 THEN
            SET format = '%.2f';
        ELSEIF abs(value) < 100 THEN
            SET format = '%.1f';
        ELSE
            SET format = '%.0f';
        END IF;
        RETURN format(format, value) || unit;
    END;

WITH
data AS (
    SELECT CAST(pow(10, s.p) AS BIGINT) AS num
    FROM table(sequence(start=>1, stop=>18)) AS s(p)
    UNION ALL
    SELECT -CAST(pow(10, s.p) AS BIGINT) AS num
    FROM table(sequence(start=>1, stop=>18)) AS s(p)
    UNION ALL
    SELECT 0 AS num
)
SELECT
    data.num
  , format_data_size(data.num) AS formatted
FROM data
ORDER BY data.num;

/* expected output:
CREATE FUNCTION
         num          | formatted
----------------------+-----------
 -1000000000000000000 | -1.00EiB
  -100000000000000000 | -100PiB
   -10000000000000000 | -10.0PiB
    -1000000000000000 | -1.00PiB
     -100000000000000 | -100TiB
      -10000000000000 | -10.0TiB
       -1000000000000 | -1.00TiB
        -100000000000 | -100GiB
         -10000000000 | -10.0GiB
          -1000000000 | -1.00GiB
           -100000000 | -100MiB
            -10000000 | -10.0MiB
             -1000000 | -1.00MiB
              -100000 | -100KiB
               -10000 | -10.0KiB
                -1000 | -1.00KiB
                 -100 | -100B
                  -10 | -10.0B
                    0 | 0.00B
                   10 | 10.0B
                  100 | 100B
                 1000 | 1.00KiB
                10000 | 10.0KiB
               100000 | 100KiB
              1000000 | 1.00MiB
             10000000 | 10.0MiB
            100000000 | 100MiB
           1000000000 | 1.00GiB
          10000000000 | 10.0GiB
         100000000000 | 100GiB
        1000000000000 | 1.00TiB
       10000000000000 | 10.0TiB
      100000000000000 | 100TiB
     1000000000000000 | 1.00PiB
    10000000000000000 | 10.0PiB
   100000000000000000 | 100PiB
  1000000000000000000 | 1.00EiB
*/
