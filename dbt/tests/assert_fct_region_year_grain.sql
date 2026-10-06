select region_id, year, count(*) as cnt
from {{ ref('fct_region_year') }}
group by region_id, year
having count(*) > 1