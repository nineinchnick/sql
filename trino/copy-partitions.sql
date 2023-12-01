with partitions as (
    select
    '''' || replace(licenseowner, '''', '''''') || '''' as p
    --, ntile(100) over (order by date desc, licenseowner) as n
    , row_number() OVER (order by licenseowner) as n
    FROM catalog.schema."table$partitions"
    where date < current_date
    group by licenseowner
)
select '-- group ' || cast(n as varchar) || u&'\000A' || 'INSERT INTO other_catalog.schema.table SELECT * FROM catalog.schema.table WHERE licenseowner IN (' || array_join(array_agg(p), ', ') || ');'
from partitions
group by n
order by n
;
