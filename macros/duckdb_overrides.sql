{# DuckDB-specific macro overrides for dependency packages that lack native DuckDB support. #}

{# Override for linkedin.date_from_month_string
   The default implementation uses to_date(), which does not exist in DuckDB.
   DuckDB can cast a 'YYYY-MM-DD' string directly to date. #}
{% macro duckdb__date_from_month_string(month_str) %}
    cast(
        split_part({{ month_str }}, '-', 1) || '-' || lpad(split_part({{ month_str }}, '-', 2), 2, '0') || '-01'
    as date)
{% endmacro %}

{# Override for facebook_ads.get_url_tags_query
   The default implementation references a CTE named 'unnested' that only exists
   in the BigQuery-specific implementation, causing a catalog error in DuckDB.
   This DuckDB implementation properly unnests the JSON array of url tag objects. #}
{% macro duckdb__get_url_tags_query(output_cte_name, url_tags_datatype) %}

    unnested as (
        select
            source_relation,
            _fivetran_id,
            creative_id,
            unnest(replace(trim(url_tags, '"'), '\\', '')::JSON[]) as url_tag_element
        from required_fields
        where url_tags is not null
    ),

    {{ output_cte_name }} as (
        select
            source_relation,
            _fivetran_id,
            creative_id,
            json_extract_string(url_tag_element, '$.key') as key,
            json_extract_string(url_tag_element, '$.value') as value,
            json_extract_string(url_tag_element, '$.type') as type
        from unnested
    )
{% endmacro %}
