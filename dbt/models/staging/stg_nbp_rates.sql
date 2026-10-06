with source as (

    select * from {{ source('raw', 'nbp_rates') }}

)

select
    cast(effective_date as date)  as rate_date,
    upper(code)                   as currency_code,
    currency                      as currency_name,
    cast(mid as numeric(12, 6))   as mid_rate,
    table_no,
    loaded_at
from source