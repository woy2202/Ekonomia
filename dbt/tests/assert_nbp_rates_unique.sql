select
    rate_date,
    currency_code,
    count(*) as cnt
from {{ ref('stg_nbp_rates') }}
group by rate_date, currency_code
having count(*) > 1