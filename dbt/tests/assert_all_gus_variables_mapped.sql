select distinct s.variable_id
from {{ source('raw', 'gus_bdl') }} s
left join {{ ref('gus_variables') }} v
    on v.variable_id = s.variable_id
where v.variable_id is null