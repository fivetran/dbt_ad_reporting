{% set enabled_packages = get_enabled_packages() %}
{{ config(enabled=is_enabled(enabled_packages)) }}

with
{% for package in ['twitter_ads', 'facebook_ads', 'google_ads', 'microsoft_ads'] %}
{% if package in enabled_packages %}
{{ package }} as (
    {{ get_query(
        platform=package,
        report_type='campaign',
        relation=ref(package ~ '__campaign_report')
    ) }}
),
{% endif %}
{% endfor %}

{% if 'apple_search_ads' in enabled_packages %}
apple_search_ads as (

    {{ get_query(
        platform='apple_search_ads', 
        report_type='campaign', 
        field_mapping={
                'account_id': 'organization_id',
                'account_name': 'organization_name',
                'clicks': 'taps'
            },
        relation=ref('apple_search_ads__campaign_report')
    ) }}
),
{% endif %}

{% if 'linkedin_ads' in enabled_packages %}
linkedin_ads as (

    {{ get_query(
        platform='linkedin_ads', 
        report_type='campaign', 
        field_mapping={
                'campaign_id': 'campaign_group_id',
                'campaign_name': 'campaign_group_name',
                'spend': 'cost'
            },
        relation=ref('linkedin_ads__campaign_group_report')
    ) }}
),
{% endif %}

{% if 'pinterest_ads' in enabled_packages %}
pinterest_ads as (

    {{ get_query(
        platform='pinterest_ads', 
        report_type='campaign', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name'
            },
        relation=ref('pinterest_ads__campaign_report')
    ) }}
),
{% endif %}

{% if 'snapchat_ads' in enabled_packages %}
snapchat_ads as (

    {{ get_query(
        platform='snapchat_ads', 
        report_type='campaign', 
        field_mapping={
                'account_id': 'ad_account_id',
                'account_name': 'ad_account_name',
                'clicks':'swipes'
            },
        relation=ref('snapchat_ads__campaign_report')
    ) }}
), 
{% endif %}

{% if 'tiktok_ads' in enabled_packages %}
tiktok_ads as (

    {{ get_query(
        platform='tiktok_ads', 
        report_type='campaign', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name'
            },
        relation=ref('tiktok_ads__campaign_report')
    ) }}
), 
{% endif %}

{% if 'amazon_ads' in enabled_packages %}
amazon_ads as (

    {{ get_query(
        platform='amazon_ads', 
        report_type='campaign', 
        field_mapping={
                'spend': 'cost'
            },
        relation=ref('amazon_ads__campaign_report')
    ) }}
), 
{% endif %}

unioned as (

    {{ union_ctes(ctes=enabled_packages)}}
)

select *
from unioned