with rates as (

    select
        rate_date,
        currency_code,
        mid_rate,
        lag(mid_rate) over (partition by currency_code order by rate_date) as previous_rate
    from {{ ref('stg_nbp_rates') }}

)

select
    {{ date_key('rate_date') }}                          as date_key,
    currency_code,
    rate_date,
    mid_rate,
    round((mid_rate / previous_rate - 1) * 100, 4)       as daily_change_pct
from rates