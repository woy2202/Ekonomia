select
    variable_id,
    region_id,
    year,
    count(*) as cnt
from {{ ref('stg_gus_bdl') }}
group by variable_id, region_id, year
having count(*) > 1