{% set include_list = [] %}
{% do include_list.append('facebook_ads') if var('facebook_ads__using_demographics_country', false) %}
{% do include_list.append('linkedin_ads') if var('linkedin_ads__using_geo', true) and var('linkedin_ads__using_monthly_ad_analytics_by_member_country', true) %}
{% do include_list.append('microsoft_ads') if var('microsoft_ads__using_geographic_daily_report', false) %}
{% do include_list.append('pinterest_ads') if var('pinterest__using_pin_promotion_targeting_report', true) and var('pinterest__using_targeting_geo', true) %}
{% do include_list.append('reddit_ads') if var('reddit_ads__using_campaign_country_report', true) %}
{% do include_list.append('snapchat_ads') if var('snapchat_ads__using_campaign_country_report', false) %}
{% do include_list.append('tiktok_ads') if var('tiktok_ads__using_campaign_country_report', true) %}
{% do include_list.append('twitter_ads') if var('twitter_ads__using_campaign_locations_report', false) %}

{% set enabled_packages = get_enabled_packages(include=include_list) %}
{{ config(enabled=is_enabled(enabled_packages)) }}

with 
{% if 'facebook_ads' in enabled_packages %}
facebook_ads as (

    {{ get_query(
        platform='facebook_ads', 
        report_type='country', 
        field_mapping={
                'campaign_id': 'null',
                'campaign_name': "'Account-level'",
                'conversions_value': 'null',
                'country': 'null',
                'country_code': "replace(country, 'unknown', 'Unknown')"
            },
        relation=ref('facebook_ads__country_report')
    ) }}
),
{% endif %}

{% if 'linkedin_ads' in enabled_packages %}
{# Linkedin sends Hong Kong as Hong Kong SAR while others send it as Hong Kong SAR China or Hong Kong #}
linkedin_ads as (

    {{ get_query(
        platform='linkedin_ads', 
        report_type='country', 
        field_mapping={
                'campaign_id': 'campaign_group_id',
                'campaign_name': 'campaign_group_name',
                'spend': 'cost',
                'conversions': 'total_conversions',
                'conversions_value': 'conversion_value_in_local_currency',
                'country': "replace(country_name, 'Hong Kong SAR', 'Hong Kong SAR China')",
                'country_code': 'null'
            },
        relation=ref('linkedin_ads__monthly_campaign_country_report')
    ) }}
),
{% endif %}

{% if 'microsoft_ads' in enabled_packages %}
microsoft_ads as (

    {{ get_query(
        platform='microsoft_ads', 
        report_type='country', 
        field_mapping={
                'country_code': 'null'
            },
        relation=ref('microsoft_ads__campaign_country_report')
    ) }}
),
{% endif %}

{% if 'pinterest_ads' in enabled_packages %}
{# Pinterest Ads labels the United States as U.S. #}
pinterest_ads as (

    {{ get_query(
        platform='pinterest_ads', 
        report_type='country', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name',
                'conversions': 'total_conversions',
                'conversions_value': 'total_conversions_value',
                'country_code': 'country_id',
                'country': "replace(country_name, 'U.S.', 'United States')"
            },
        relation=ref('pinterest_ads__campaign_country_report')
    ) }}
),
{% endif %}

{% if 'reddit_ads' in enabled_packages %}
reddit_ads as (

    {{ get_query(
        platform='reddit_ads', 
        report_type='country', 
        field_mapping={
                'account_name': 'null',
                'conversions_value': 'total_value',
                'country': 'null',
                'country_code': 'country'
            },
        relation=ref('reddit_ads__campaign_country_report')
    ) }}
),
{% endif %}

{% if 'snapchat_ads' in enabled_packages %}
snapchat_ads as (

    {{ get_query(
        platform='snapchat_ads', 
        report_type='country', 
        field_mapping={
                'account_id': 'ad_account_id',
                'account_name': 'ad_account_name',
                'clicks': 'swipes',
                'conversions': 'total_conversions',
                'conversions_value': 'conversion_purchases_value',
                'country': 'null',
                'country_code': 'country'
            },
        relation=ref('snapchat_ads__campaign_country_report')
    ) }}
),
{% endif %}

{% if 'tiktok_ads' in enabled_packages %}
tiktok_ads as (

    {{ get_query(
        platform='tiktok_ads', 
        report_type='country', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name',
                'conversions': 'conversion',
                'conversions_value': 'null',
                'country': 'null',
                'country_code': 'country_code'
            },
        relation=ref('tiktok_ads__campaign_country_report')
    ) }}
),
{% endif %}

{% if 'twitter_ads' in enabled_packages %}
twitter_ads as (

    {{ get_query(
        platform='twitter_ads', 
        report_type='country', 
        field_mapping={
                'conversions': 'total_conversions',
                'conversions_value': 'total_conversions_sale_amount',
                'country_code': 'null'
            },
        relation=ref('twitter_ads__campaign_country_report')
    ) }}
),
{% endif %}

unioned as (

    {{ union_ctes(ctes=enabled_packages) }}
)

select *
from unioned