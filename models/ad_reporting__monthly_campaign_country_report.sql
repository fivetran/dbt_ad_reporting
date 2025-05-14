{% set include_list = [] %}
{% do include_list.append('facebook_ads') if var('facebook_ads__using_demographics_country', false) %}
{% do include_list.append('linkedin_ads') if var('linkedin_ads__using_geo', true) and var('linkedin_ads__using_monthly_ad_analytics_by_member_country', true) %}
{% do include_list.append('microsoft_ads') if var('microsoft_ads__using_geographic_daily_report', false) %}
{% do include_list.append('pinterest_ads') if var('pinterest__using_pin_promotion_targeting_report', true) and var('pinterest__using_targeting_geo', true) %}
{% do include_list.append('reddit_ads') if var('reddit_ads__using_campaign_country_report', true) %}
{% do include_list.append('snapchat_ads') if var('snapchat_ads__using_campaign_country_report', false) %}
{% do include_list.append('tiktok_ads') if var('tiktok_ads__using_campaign_country_report', true) %}
{% do include_list.append('twitter_ads') if var('twitter_ads__using_campaign_locations_report', false) %}

{% set enabled_packages = get_enabled_packages(include=include_list)%}
{{ config(enabled=is_enabled(enabled_packages)) }}

with base as (

    select *
    from {{ ref('int_ad_reporting__monthly_campaign_country_report') }}
),

country_mapping as (

    select *
    from {{ ref('int_ad_reporting__country_mapping') }}
),

{# Before grabbing the country codes or names for platforms that only provide the codes, let's standardize the existing country names #}
standardize_country_names as (

    select 
        base.*,
        coalesce(country_mapping.country_name, base.country) as standardized_alt_country_name

    from base 
    left join country_mapping
        on base.country = country_mapping.alternative_country_name
),

{# Now grab the country names for platforms that only provide codes and vice versa #}
map_countries_and_codes as (

    select 
        standardize_country_names.*,
        coalesce(standardize_country_names.standardized_alt_country_name, country_mapping.country_name) as standardized_country,
        coalesce(standardize_country_names.country_code, country_mapping.country_code) as standardized_country_code,
        country_mapping.global_region

    from standardize_country_names 
    left join country_mapping
        on standardize_country_names.standardized_alt_country_name = country_mapping.country_name
        or standardize_country_names.country_code = country_mapping.country_code
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
        standardized_country as country,
        standardized_country_code as country_code,
        global_region,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value

        {{ ad_reporting_persist_pass_through_columns(pass_through_variable='ad_reporting__country_passthrough_metrics', transform = 'sum', alias_fields=['conversions', 'conversions_value']) }}

    from map_countries_and_codes
    {{ dbt_utils.group_by(10) }}
)

select *
from aggregated