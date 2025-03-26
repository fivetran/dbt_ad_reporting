{%- macro fivetran_today(tz=None) -%}
    {{ return(adapter.dispatch('fivetran_today', 'ad_reporting') (tz)) }}
{%- endmacro -%}

{%- macro default__fivetran_today(tz=None) -%}
    cast({{ ad_reporting.fivetran_now(tz) }} as date)
{%- endmacro -%}
