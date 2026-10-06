{% macro date_key(column) -%}
    cast(to_char({{ column }}, 'YYYYMMDD') as integer)
{%- endmacro %}