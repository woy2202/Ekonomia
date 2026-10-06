with regions as (

    select distinct
        region_id,
        region_name
    from {{ ref('stg_gus_bdl') }}

)

select
    region_id,
    substring(region_id from 3 for 2)   as teryt_code,
    region_name,
    initcap(region_name)                as region_label,
    case substring(region_id from 1 for 2)
        when '01' then 'Makroregion południowy'
        when '02' then 'Makroregion północno-zachodni'
        when '03' then 'Makroregion południowo-zachodni'
        when '04' then 'Makroregion północny'
        when '05' then 'Makroregion centralny'
        when '06' then 'Makroregion wschodni'
        when '07' then 'Makroregion województwo mazowieckie'
    end                                 as macroregion
from regions