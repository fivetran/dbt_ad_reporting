{%- macro fivetran_n_days_ago(n, date=None, tz=None) -%}
    {{ return(adapter.dispatch('fivetran_n_days_ago', 'ad_reporting') (n, date, tz)) }}
{%- endmacro -%}

{%- macro default__fivetran_n_days_ago(n, date=None, tz=None) -%}
    {%-set dt = date if date else ad_reporting.fivetran_today(tz) -%}
    {%- set n = n|int -%}
    cast({{ dbt.dateadd('day', -1 * n, dt) }} as date)
{%- endmacro -%}