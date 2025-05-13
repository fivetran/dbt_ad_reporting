{% set include_list = [] %}
{% do include_list.append('facebook_ads') if var('facebook_ads__using_demographics_region', false) %}
{% do include_list.append('linkedin_ads') if var('linkedin_ads__using_geo', true) and var('linkedin_ads__using_monthly_ad_analytics_by_member_region', true) %}
{% do include_list.append('microsoft_ads') if var('microsoft_ads__using_geographic_daily_report', false) %}
{% do include_list.append('pinterest_ads') if var('pinterest__using_pin_promotion_targeting_report', true) and var('pinterest__using_targeting_geo_region', true) %}
{% do include_list.append('snapchat_ads') if var('snapchat_ads__using_campaign_region_report', false) %}
{% do include_list.append('twitter_ads') if var('twitter_ads__using_campaign_regions_report', false) %}

{% set enabled_packages = get_enabled_packages(include=include_list)%}
{{ config(enabled=is_enabled(enabled_packages)) }}

with base as (

    select *
    from {{ ref('int_ad_reporting__monthly_campaign_region_report') }}
),

aggregated as (
    
    select
        source_relation,
        {{ dbt.date_trunc("month", "date_day") }} as date_month,
        platform,
        account_id,
        account_name,
        campaign_id,
        campaign_name,
        region,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value

        {{ ad_reporting_persist_pass_through_columns(pass_through_variable='ad_reporting__country_passthrough_metrics', transform = 'sum', alias_fields=['conversions', 'conversions_value']) }}

    from base
    {{ dbt_utils.group_by(8) }}
)

select *
from aggregated