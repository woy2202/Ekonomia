with annual as (

    select region_id, year, indicator, value
    from {{ ref('stg_gus_bdl') }}
    where frequency = 'annual'

),

pivoted as (

    select
        region_id,
        year,
        max(case when indicator = 'avg_gross_wage_10plus'           then value end) as avg_gross_wage,
        max(case when indicator = 'avg_gross_wage_10plus_vs_poland' then value end) as wage_vs_poland,
        max(case when indicator = 'unemployment_rate'               then value end) as unemployment_rate,
        max(case when indicator = 'unemployment_rate_vs_poland'     then value end) as unemployment_vs_poland,
        max(case when indicator = 'population'                      then value end) as population,
        max(case when indicator = 'population_midyear'              then value end) as population_midyear,
        max(case when indicator = 'cpi'                             then value end) as cpi,
        max(case when indicator = 'cpi_food'                        then value end) as cpi_food,
        max(case when indicator = 'cpi_housing'                     then value end) as cpi_housing,
        max(case when indicator = 'cpi_transport'                   then value end) as cpi_transport
    from annual
    group by region_id, year

),

with_previous as (

    select
        *,
        lag(year)           over (partition by region_id order by year) as previous_year,
        lag(avg_gross_wage) over (partition by region_id order by year) as previous_wage
    from pivoted

)

select
    {{ date_key('make_date(year, 1, 1)') }}  as date_key,
    region_id,
    year,
    avg_gross_wage,
    wage_vs_poland,
    unemployment_rate,
    unemployment_vs_poland,
    cast(population as bigint)               as population,
    cast(population_midyear as bigint)       as population_midyear,
    cpi,
    cpi_food,
    cpi_housing,
    cpi_transport,
    case
        when previous_year = year - 1
        then round(avg_gross_wage / previous_wage * 100, 2)
    end                                      as wage_index_nominal,
    case
        when previous_year = year - 1 and cpi is not null
        then round(avg_gross_wage / previous_wage / (cpi / 100) * 100, 2)
    end                                      as wage_index_real
from with_previous