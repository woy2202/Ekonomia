select distinct on (currency_code)
    currency_code,
    currency_name,
    min(rate_date) over (partition by currency_code) as first_rate_date,
    max(rate_date) over (partition by currency_code) as last_rate_date
from {{ ref('stg_nbp_rates') }}
order by currency_code, rate_date desc