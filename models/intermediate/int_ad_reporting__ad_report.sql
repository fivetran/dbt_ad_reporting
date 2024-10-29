{% set enabled_packages = get_enabled_packages() %}
{{ config(enabled=is_enabled(enabled_packages)) }}

with
{% for package in ['google_ads', 'microsoft_ads'] %}
{% if package in enabled_packages %}
{{ package }} as (
    {{ get_query(
        platform=package,
        report_type='ad',
        relation=ref(package ~ '__ad_report')
    ) }}
),
{% endif %}
{% endfor %}

{% if 'apple_search_ads' in enabled_packages %}
apple_search_ads as (

    {{ get_query(
        platform='apple_search_ads', 
        report_type='ad', 
        field_mapping={
                'account_id': 'organization_id',
                'account_name': 'organization_name',
                'clicks': 'taps',
                'conversions_value': 'null'
            },
        relation=ref('apple_search_ads__ad_report')
    ) }}
),
{% endif %}

{% if 'facebook_ads' in enabled_packages %}
facebook_ads as (

    {{ get_query(
        platform='facebook_ads', 
        report_type='ad', 
        field_mapping={
                'ad_group_id': 'ad_set_id',
                'ad_group_name': 'ad_set_name',
                'conversions': 'total_conversions',
                'conversions_value': 'total_conversions_value'
            },
        relation=ref('facebook_ads__ad_report')
    ) }}
),
{% endif %}

{% if 'linkedin_ads' in enabled_packages %}
linkedin_ads as (

    {{ get_query(
        platform='linkedin_ads', 
        report_type='ad', 
        field_mapping={
                'campaign_id': 'campaign_group_id',
                'campaign_name': 'campaign_group_name',
                'ad_group_id': 'campaign_id',
                'ad_group_name': 'campaign_name',
                'ad_id': 'creative_id',
                'ad_name': 'null',
                'spend': 'cost',
                'conversions': 'total_conversions',
                'conversions_value': 'conversion_value_in_local_currency'
            },
        relation=ref('linkedin_ads__creative_report')
    ) }}
),
{% endif %}

{% if 'pinterest_ads' in enabled_packages %}
pinterest_ads as (

    {{ get_query(
        platform='pinterest_ads', 
        report_type='ad', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name',
                'ad_id': 'pin_promotion_id',
                'ad_name': 'pin_name',
                'conversions': 'total_conversions',
                'conversions_value': 'total_conversions_value'
            },
        relation=ref('pinterest_ads__pin_promotion_report')
    ) }}
),
{% endif %}

{% if 'snapchat_ads' in enabled_packages %}
snapchat_ads as (

    {{ get_query(
        platform='snapchat_ads', 
        report_type='ad', 
        field_mapping={
                'account_id': 'ad_account_id',
                'account_name': 'ad_account_name',
                'campaign_id': 'null',
                'campaign_name': 'null',
                'ad_group_id': 'null',
                'ad_group_name': 'null',
                'clicks':'swipes',
                'conversions': 'total_conversions',
                'conversions_value': 'conversion_purchases_value'
            },
        relation=ref('snapchat_ads__ad_report')
    ) }}
), 
{% endif %}

{% if 'tiktok_ads' in enabled_packages %}
tiktok_ads as (

    {{ get_query(
        platform='tiktok_ads', 
        report_type='ad', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name',
                'conversions': 'conversion',
                'conversions_value': 'total_conversion_value'
            },
        relation=ref('tiktok_ads__ad_report')
    ) }}
), 
{% endif %}

{% if 'twitter_ads' in enabled_packages %}
twitter_ads as (

    {{ get_query(
        platform='twitter_ads', 
        report_type='ad', 
        field_mapping={
                'ad_group_id': 'line_item_id',
                'ad_group_name': 'line_item_name',
                'ad_id': 'promoted_tweet_id',
                'ad_name': 'tweet_name',
                'conversions': 'total_conversions',
                'conversions_value': 'total_conversions_sale_amount'
            },
        relation=ref('twitter_ads__promoted_tweet_report')
    ) }}
), 
{% endif %}

{% if 'amazon_ads' in enabled_packages %}
amazon_ads as (

    {{ get_query(
        platform='amazon_ads', 
        report_type='ad', 
        field_mapping={
                'spend': 'cost',
                'ad_name': 'advertised_asin',
                'conversions': 'purchases_30_d',
                'conversions_value': 'sales_30_d'
            },
        relation=ref('amazon_ads__ad_report')
    ) }}
), 
{% endif %}

{% if 'reddit_ads' in enabled_packages %}
reddit_ads as (

    {{ get_query(
        platform='reddit_ads', 
        report_type='ad', 
        field_mapping={
                'account_name': 'null',
                'conversions_value': 'total_value'
            },
        relation=ref('reddit_ads__ad_report')
    ) }}
),
{% endif %}

unioned as (

    {{ union_ctes(ctes=enabled_packages)}}
)

select *
from unioned