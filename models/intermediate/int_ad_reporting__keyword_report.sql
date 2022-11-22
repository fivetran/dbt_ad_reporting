{% if var('twitter_ads__using_keywords', True) %}
    {% set include_list = ['apple_search_ads', 'google_ads', 'microsoft_ads', 'pinterest_ads', 'twitter_ads'] %}
{% else %}
    {% set include_list = ['apple_search_ads', 'google_ads', 'microsoft_ads', 'pinterest_ads'] %}
{% endif %}

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
                'clicks': 'taps'
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

{% if 'pinterest_ads' in enabled_packages %}
pinterest_ads as (

    {{ get_query(
        platform='pinterest_ads', 
        report_type='keyword', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name',
                'keyword_text': 'keyword_value',
                'keyword_match_type': 'match_type'
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
                'keyword_match_type': 'null'
            },
        relation=ref('twitter_ads__keyword_report')
    ) }}
), 
{% endif %}

unioned as (

    {{ union_ctes(ctes=enabled_packages)}}
)

select *
from unioned