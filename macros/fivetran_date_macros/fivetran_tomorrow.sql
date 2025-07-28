{%- macro fivetran_tomorrow(date=None, tz=None) -%}
    {{ return(adapter.dispatch('fivetran_tomorrow', 'ad_reporting') (date, tz)) }}
{%- endmacro -%}

{%- macro default__fivetran_tomorrow(date=None, tz=None) -%}
    {{ ad_reporting.fivetran_n_days_away(1, date, tz) }}
{%- endmacro -%}
