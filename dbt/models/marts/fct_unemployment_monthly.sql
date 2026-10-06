select
    {{ date_key('period_date') }}  as date_key,
    region_id,
    year,
    month,
    value                          as unemployment_rate
from {{ ref('stg_gus_bdl') }}
where indicator = 'unemployment_rate'
  and frequency = 'monthly'