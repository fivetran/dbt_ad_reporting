{%- macro fivetran_n_days_away(n, date=None, tz=None) -%}
    {{ return(adapter.dispatch('fivetran_n_days_away', 'ad_reporting') (n, date, tz)) }}
{%- endmacro -%}

{%- macro default__fivetran_n_days_away(n, date=None, tz=None) -%}
    {{ ad_reporting.fivetran_n_days_ago(-1 * n, date, tz) }}
{%- endmacro -%}