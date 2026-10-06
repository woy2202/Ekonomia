with source as (

    select * from {{ source('raw', 'gus_bdl') }}

),

variables as (

    select * from {{ ref('gus_variables') }}

)

select
    s.variable_id,
    v.indicator,
    v.frequency,
    v.unit,
    s.unit_id                                       as region_id,
    lower(s.unit_name)                              as region_name,
    cast(s.year as integer)                         as year,
    v.month,
    make_date(cast(s.year as integer), coalesce(v.month, 1), 1) as period_date,
    cast(s.value as numeric(18, 4))                 as value,
    s.attr_id,
    s.loaded_at
from source s
inner join variables v
    on v.variable_id = s.variable_id
where s.value is not null