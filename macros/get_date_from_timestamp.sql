{% macro get_date_from_timestamp(column) %}
  {{ return(adapter.dispatch('get_date_from_timestamp') (column)) }}
{% endmacro %}

{% macro default__get_date_from_timestamp(column) %}
    date({{column}})
{% endmacro %}


{% macro bigquery__get_date_from_timestamp(column) %}

    cast({{column}} as date)

{% endmacro %}

{% macro spark__get_date_from_timestamp(column) %}

    to_date(to_timestamp({{ column }}),'yyyyMMdd')

{% endmacro %}

{% macro snowflake__get_date_from_timestamp(column) %}

    to_date(to_timestamp({{ column }}))

{% endmacro %}