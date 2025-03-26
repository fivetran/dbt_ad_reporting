{% macro fivetran_get_intervals_between(start_date, end_date, datepart) -%}
    {{ return(adapter.dispatch('fivetran_get_intervals_between', 'ad_reporting') (start_date, end_date, datepart)) }}
{%- endmacro %}

{% macro default__fivetran_get_intervals_between(start_date, end_date, datepart) -%}
    {%- call statement("fivetran_get_intervals_between", fetch_result=True) %}

        select {{ dbt.datediff(start_date, end_date, datepart) }}

    {%- endcall -%}

    {%- set value_list = load_result("fivetran_get_intervals_between") -%}

    {%- if value_list and value_list["data"] -%}
        {%- set values = value_list["data"] | map(attribute=0) | list %}
        {{ return(values[0]) }}
    {%- else -%} {{ return(1) }}
    {%- endif -%}

{%- endmacro %}

