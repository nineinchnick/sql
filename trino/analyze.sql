with partitions as (
    select
    'ARRAY[''' || cast(date as varchar) || ''', ''' || replace(licenseowner, '''', '''''') || ''']' as p
    , ntile(100) over (order by date desc, licenseowner) as n
    FROM catalog.schema."table$partitions"
    where date < current_date
    and licenseowner not like '%é%'
)
select '-- group ' || cast(n as varchar) || u&'\000A' || 'ANALYZE catalog.schema.table WITH (partitions = ARRAY[' || array_join(array_agg(p), ', ') || ']);' 
from partitions
group by n
order by n
;
