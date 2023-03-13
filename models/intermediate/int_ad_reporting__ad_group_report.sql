{% set enabled_packages = get_enabled_packages() %}
{{ config(enabled=is_enabled(enabled_packages)) }}

with
{% for package in ['google_ads', 'microsoft_ads'] %}
{% if package in enabled_packages %}
{{ package }} as (
    {{ get_query(
        platform=package,
        report_type='ad_group',
        relation=ref(package ~ '__ad_group_report')
    ) }}
),
{% endif %}
{% endfor %}

{% if 'apple_search_ads' in enabled_packages %}
apple_search_ads as (

    {{ get_query(
        platform='apple_search_ads', 
        report_type='ad_group', 
        field_mapping={
                'account_id': 'organization_id',
                'account_name': 'organization_name',
                'clicks': 'taps'
            },
        relation=ref('apple_search_ads__ad_group_report')
    ) }}
),
{% endif %}

{% if 'linkedin_ads' in enabled_packages %}
linkedin_ads as (

    {{ get_query(
        platform='linkedin_ads', 
        report_type='ad_group', 
        field_mapping={
                'campaign_id': 'campaign_group_id',
                'campaign_name': 'campaign_group_name',
                'ad_group_id': 'campaign_id',
                'ad_group_name': 'campaign_name',
                'spend': 'cost'
            },
        relation=ref('linkedin_ads__campaign_report')
    ) }}
),
{% endif %}

{% if 'facebook_ads' in enabled_packages %}
facebook_ads as (

    {{ get_query(
        platform='facebook_ads', 
        report_type='ad_group', 
        field_mapping={
                'ad_group_id': 'ad_set_id',
                'ad_group_name': 'ad_set_name'
            },
        relation=ref('facebook_ads__ad_set_report')
    ) }}
),
{% endif %}

{% if 'pinterest_ads' in enabled_packages %}
pinterest_ads as (

    {{ get_query(
        platform='pinterest_ads', 
        report_type='ad_group', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name'
            },
        relation=ref('pinterest_ads__ad_group_report')
    ) }}
),
{% endif %}

{% if 'snapchat_ads' in enabled_packages %}
snapchat_ads as (

    {{ get_query(
        platform='snapchat_ads', 
        report_type='ad_group', 
        field_mapping={
                'account_id': 'ad_account_id',
                'account_name': 'ad_account_name',
                'ad_group_id': 'ad_squad_id',
                'ad_group_name': 'ad_squad_name',
                'clicks':'swipes'
            },
        relation=ref('snapchat_ads__ad_squad_report')
    ) }}
), 
{% endif %}

{% if 'tiktok_ads' in enabled_packages %}
tiktok_ads as (

    {{ get_query(
        platform='tiktok_ads', 
        report_type='ad_group', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name'
            },
        relation=ref('tiktok_ads__ad_group_report')
    ) }}
), 
{% endif %}

{% if 'twitter_ads' in enabled_packages %}
twitter_ads as (

    {{ get_query(
        platform='twitter_ads', 
        report_type='ad_group', 
        field_mapping={
                'ad_group_id': 'line_item_id',
                'ad_group_name': 'line_item_name'
            },
        relation=ref('twitter_ads__line_item_report')
    ) }}
), 
{% endif %}

{% if 'amazon_ads' in enabled_packages %}
amazon_ads as (

    {{ get_query(
        platform='amazon_ads', 
        report_type='ad_group', 
        field_mapping={
                'spend': 'cost'
            },
        relation=ref('amazon_ads__ad_group_report')
    ) }}
), 
{% endif %}

{% if 'reddit_ads' in enabled_packages %}
apple_search_ads as (

    {{ get_query(
        platform='reddit_ads', 
        report_type='ad_group', 
        field_mapping={
                'account_name': 'null'
            },
        relation=ref('reddit_ads__ad_group_report')
    ) }}
),
{% endif %}

unioned as (

    {{ union_ctes(ctes=enabled_packages)}}
)

select *
from unioned