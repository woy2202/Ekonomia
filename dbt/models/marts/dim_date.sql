with days as (

    select generate_series(
        date '1990-01-01',
        (date_trunc('year', current_date) + interval '1 year - 1 day')::date,
        interval '1 day'
    )::date as date_day

)

select
    cast(to_char(date_day, 'YYYYMMDD') as integer)  as date_key,
    date_day                                        as date,
    extract(year from date_day)::int                as year,
    extract(quarter from date_day)::int             as quarter,
    extract(month from date_day)::int               as month,
    (array['styczeń', 'luty', 'marzec', 'kwiecień', 'maj', 'czerwiec',
           'lipiec', 'sierpień', 'wrzesień', 'październik', 'listopad', 'grudzień']
    )[extract(month from date_day)::int]            as month_name,
    to_char(date_day, 'YYYY-MM')                    as year_month,
    extract(isodow from date_day)::int              as day_of_week,
    extract(isodow from date_day) in (6, 7)         as is_weekend
from days