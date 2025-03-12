{% set include_list = ['amazon_ads', 'apple_search_ads', 'google_ads', 'microsoft_ads'] %}
{% do include_list.append('pinterest_ads') if var('pinterest__using_keywords', true) %}
{% do include_list.append('twitter_ads') if var('twitter_ads__using_keywords', true) %}

{% set enabled_packages = get_enabled_packages(include=include_list)%}
{{ config(enabled=is_enabled(enabled_packages)) }}

with
{% if 'apple_search_ads' in enabled_packages %}
apple_search_ads as (

    {{ get_query(
        platform='apple_search_ads', 
        report_type='keyword', 
        field_mapping={
                'account_id': 'organization_id',
                'account_name': 'organization_name',
                'keyword_match_type': 'match_type',
                'clicks': 'taps',
                'conversions': 'tap_installs'
                'conversions_value': 'null'
            },
        relation=ref('apple_search_ads__keyword_report')
    ) }}
),
{% endif %}

{% if 'google_ads' in enabled_packages %}
google_ads as (

    {{ get_query(
        platform='google_ads', 
        report_type='keyword', 
        field_mapping={
                'keyword_id': 'criterion_id',
            },
        relation=ref('google_ads__keyword_report')
    ) }}
),
{% endif %}

{% if 'microsoft_ads' in enabled_packages %}
microsoft_ads as (

    {{ get_query(
        platform='microsoft_ads', 
        report_type='keyword', 
        field_mapping={
                'keyword_text': 'keyword_name',
                'keyword_match_type': 'match_type'
            },
        relation=ref('microsoft_ads__keyword_report')
    ) }}
),
{% endif %}

{% if 'pinterest_ads' in enabled_packages and var('pinterest__using_keywords', True) %}
pinterest_ads as (

    {{ get_query(
        platform='pinterest_ads', 
        report_type='keyword', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name',
                'keyword_text': 'keyword_value',
                'keyword_match_type': 'match_type',
                'conversions': 'total_conversions',
                'conversions_value': 'total_conversions_value'
            },
        relation=ref('pinterest_ads__keyword_report')
    ) }}
),
{% endif %}

{% if 'twitter_ads' in enabled_packages and var('twitter_ads__using_keywords', True) %}
twitter_ads as (

    {{ get_query(
        platform='twitter_ads', 
        report_type='keyword', 
        field_mapping={
                'ad_group_id': 'line_item_id',
                'ad_group_name': 'line_item_name',
                'keyword_id': 'keyword_id',
                'keyword_text': 'keyword',
                'keyword_match_type': 'null',
                'conversions': 'total_conversions',
                'conversions_value': 'total_conversions_sale_amount'
            },
        relation=ref('twitter_ads__keyword_report')
    ) }}
), 
{% endif %}

{% if 'amazon_ads' in enabled_packages %}
amazon_ads as (

    {{ get_query(
        platform='amazon_ads', 
        report_type='keyword', 
        field_mapping={
                'spend': 'cost',
                'keyword_match_type': 'match_type',
                'conversions': 'purchases_30_d',
                'conversions_value': 'sales_30_d'
            },
        relation=ref('amazon_ads__keyword_report')
    ) }}
), 
{% endif %}

unioned as (

    {{ union_ctes(ctes=enabled_packages)}}
)

select *
from unioned