-- format_data_size is like format_number but uses SI units (base 1024)
CREATE OR REPLACE FUNCTION format_data_size(input BIGINT)
    RETURNS VARCHAR
    DETERMINISTIC
    RETURNS NULL ON NULL INPUT
    BEGIN
        DECLARE value DOUBLE DEFAULT CAST(input AS DOUBLE);
        DECLARE result BIGINT;
        DECLARE base INT DEFAULT 1024;
        DECLARE unit VARCHAR DEFAULT 'B';
        DECLARE format VARCHAR;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'kB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'MB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'GB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'TB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'PB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'EB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'ZB';
        END IF;
        IF abs(value) >= base THEN
            SET value = value / base;
            SET unit = 'YB';
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
 -1000000000000000000 | -888PB
  -100000000000000000 | -88.8PB
   -10000000000000000 | -8.88PB
    -1000000000000000 | -909TB
     -100000000000000 | -90.9TB
      -10000000000000 | -9.09TB
       -1000000000000 | -931GB
        -100000000000 | -93.1GB
         -10000000000 | -9.31GB
          -1000000000 | -954MB
           -100000000 | -95.4MB
            -10000000 | -9.54MB
             -1000000 | -977kB
              -100000 | -97.7kB
               -10000 | -9.77kB
                -1000 | -1000B
                 -100 | -100B
                  -10 | -10.0B
                    0 | 0.00B
                   10 | 10.0B
                  100 | 100B
                 1000 | 1000B
                10000 | 9.77kB
               100000 | 97.7kB
              1000000 | 977kB
             10000000 | 9.54MB
            100000000 | 95.4MB
           1000000000 | 954MB
          10000000000 | 9.31GB
         100000000000 | 93.1GB
        1000000000000 | 931GB
       10000000000000 | 9.09TB
      100000000000000 | 90.9TB
     1000000000000000 | 909TB
    10000000000000000 | 8.88PB
   100000000000000000 | 88.8PB
  1000000000000000000 | 888PB
*/
