{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

{% set include_list = [] %}
{% do include_list.append('facebook_ads') if var('facebook_ads__using_demographics_region', false) %}
{% do include_list.append('linkedin_ads') if var('linkedin_ads__using_geo', true) and var('linkedin_ads__using_monthly_ad_analytics_by_member_region', true) %}
{% do include_list.append('microsoft_ads') if var('microsoft_ads__using_geographic_daily_report', false) %}
{% do include_list.append('pinterest_ads') if var('pinterest__using_pin_promotion_targeting_report', true) and var('pinterest__using_targeting_geo_region', true) %}
{% do include_list.append('snapchat_ads') if var('snapchat_ads__using_campaign_region_report', false) %}
{% do include_list.append('twitter_ads') if var('twitter_ads__using_campaign_regions_report', false) %}

{% set enabled_packages = ad_reporting.get_enabled_packages(include=include_list) %}

with report as (

    select 
        platform,
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend,
        sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value

    from {{ target.schema }}_ad_reporting_dev.ad_reporting__monthly_campaign_region_report
    group by 1
),

{% if 'linkedin_ads' in enabled_packages %}
linkedin_ads as (

    select 
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(cost, 0)) as spend,
        sum(coalesce(total_conversions, 0)) as conversions,
        sum(coalesce(conversion_value_in_local_currency, 0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.linkedin_ads__monthly_campaign_region_report
),
{% endif %}

{% if 'pinterest_ads' in enabled_packages %}
pinterest_ads as (

    select 
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend,
        sum(coalesce(total_conversions, 0)) as conversions,
        sum(coalesce(total_conversions_value, 0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.pinterest_ads__campaign_region_report
),
{% endif %}

{% if 'snapchat_ads' in enabled_packages %}
snapchat_ads as (

    select 
        sum(coalesce(swipes, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend,
        sum(coalesce(total_conversions, 0)) as conversions,
        sum(coalesce(conversion_purchases_value, 0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.snapchat_ads__campaign_region_report
),
{% endif %}

{% if 'twitter_ads' in enabled_packages %}
twitter_ads as (

    select 
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend,
        sum(coalesce(total_conversions, 0)) as conversions,
        sum(coalesce(total_conversions_sale_amount, 0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.twitter_ads__campaign_region_report
),
{% endif %}

{% if 'facebook_ads' in enabled_packages %}
facebook_ads as (

    select 
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend,
        sum(coalesce(conversions, 0)) as conversions,
        0 as conversions_value
    from {{ target.schema }}_ad_reporting_dev.facebook_ads__region_report
),
{% endif %}

{% if 'microsoft_ads' in enabled_packages %}
microsoft_ads as (

    select 
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend,
        sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.microsoft_ads__campaign_region_report
),
{% endif %}

{% set metrics = ['clicks', 'impressions', 'spend', 'conversions', 'conversions_value'] %}

final as (
{% for platform in enabled_packages %}
    select 
        '{{ platform }}' as platform
    from report
    join {{ platform }}
        on report.platform = '{{ platform }}'
    where 
    {% for metric in metrics %}
        abs({{ platform }}.{{ metric }} - report.{{ metric }}) >= .01
        {% if not loop.last %} or {% endif %}
    {% endfor %}
        
    {% if not loop.last %} union all {% endif %}

{% endfor %}
)

select *
from final