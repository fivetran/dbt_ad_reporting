{%- macro fivetran_now(tz=None) -%}
    {{ return(adapter.dispatch('fivetran_now', 'ad_reporting')) (tz) }}
{%- endmacro -%}

{%- macro default__fivetran_now(tz=None) -%}    
    {{ ad_reporting.fivetran_convert_timezone(ad_reporting.fivetran_current_timestamp(), tz) }}
{%- endmacro -%}