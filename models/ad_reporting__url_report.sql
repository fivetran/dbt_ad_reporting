{% set enabled_packages = get_enabled_packages(exclude=['amazon_ads', 'apple_search_ads']) %}
{{ config(enabled=is_enabled(enabled_packages)) }}

with base as (

    select *
    from {{ ref('int_ad_reporting__url_report') }}
),

aggregated as (
    
    select
        source_relation,
        date_day, 
        platform,
        account_id, 
        account_name, 
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value

        {{ ad_reporting_persist_pass_through_columns(pass_through_variable='ad_reporting__ad_passthrough_metrics', transform = 'sum', alias_fields=['conversions', 'conversions_value']) }}

    from base
    {{ dbt_utils.group_by(17) }}
)

select *
from aggregated