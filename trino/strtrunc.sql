-- strtrunc truncates strings longer than 60 characters, leaving the prefix and suffix visible
CREATE OR REPLACE FUNCTION strtrunc(input VARCHAR)
    RETURNS VARCHAR
    DETERMINISTIC
    RETURNS NULL ON NULL INPUT
    RETURN case when length(input) > 60 then substr(input, 1, 30) || ' ... ' || substr(input, length(input) - 25) else input end;


WITH
data AS (
    SELECT substring('strtrunc truncates strings longer than 60 characters, leaving the prefix and suffix visible', 1, s.num) AS value
    FROM table(sequence(start=>40, stop=>80, step=>5)) AS s(num)
)
SELECT
    data.value
  , strtrunc(data.value) AS truncated
FROM data
ORDER BY data.value;

/* expected output:
CREATE FUNCTION
                                      value                                       |                           truncated
----------------------------------------------------------------------------------+---------------------------------------------------------------
 strtrunc truncates strings longer than 6                                         | strtrunc truncates strings longer than 6
 strtrunc truncates strings longer than 60 cha                                    | strtrunc truncates strings longer than 60 cha
 strtrunc truncates strings longer than 60 characte                               | strtrunc truncates strings longer than 60 characte
 strtrunc truncates strings longer than 60 characters, l                          | strtrunc truncates strings longer than 60 characters, l
 strtrunc truncates strings longer than 60 characters, leavin                     | strtrunc truncates strings longer than 60 characters, leavin
 strtrunc truncates strings longer than 60 characters, leaving the                | strtrunc truncates strings lon ... 60 characters, leaving the
 strtrunc truncates strings longer than 60 characters, leaving the pref           | strtrunc truncates strings lon ... aracters, leaving the pref
 strtrunc truncates strings longer than 60 characters, leaving the prefix an      | strtrunc truncates strings lon ... ers, leaving the prefix an
 strtrunc truncates strings longer than 60 characters, leaving the prefix and suf | strtrunc truncates strings lon ... leaving the prefix and suf
(9 rows)
*/
