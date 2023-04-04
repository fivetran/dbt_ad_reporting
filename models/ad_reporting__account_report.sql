{% set enabled_packages = get_enabled_packages() %}
{{ config(enabled=is_enabled(enabled_packages)) }}

with base as (

    select *
    from {{ ref('int_ad_reporting__account_report') }}
),

aggregated as (
    
    select 
        date_day,
        platform,
        account_id,
        account_name,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend

        {%- if var('ad_reporting__account_passthrough_metrics') -%}
            {% for metric in var('ad_reporting__account_passthrough_metrics') %}
                , sum({{ metric }}) as {{ metric.name }}
            {% endfor %}
        {%- endif -%}

    from base
    {{ dbt_utils.group_by(4) }}
)

select *
from aggregated