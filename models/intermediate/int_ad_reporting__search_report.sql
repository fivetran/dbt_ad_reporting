{% set include_list = ['amazon_ads', 'microsoft_ads'] %}
{% do include_list.append('apple_search_ads') if var('apple_search_ads__using_search_terms', true) %}
{% do include_list.append('google_ads') if var('google_ads__using_search_term_keyword_stats', true) %}

{% set enabled_packages = get_enabled_packages(include=include_list)%}
{{ config(enabled=is_enabled(enabled_packages)) }}

with 
{% if 'microsoft_ads' in enabled_packages %}
microsoft_ads as (

    {{ get_query(
        platform='microsoft_ads', 
        report_type='search', 
        field_mapping={
                'keyword_text': 'keyword_name',
                'search_match_type': 'match_type'
            },
        relation=ref('microsoft_ads__search_report')
    ) }}
), 
{% endif %}

{% if 'apple_search_ads' in enabled_packages and var('apple_search_ads__using_search_terms', True) %}
apple_search_ads as (

    {{ get_query(
        platform='apple_search_ads', 
        report_type='search', 
        field_mapping={
                'account_id': 'organization_id',
                'account_name': 'organization_name',
                'search_match_type': 'match_type',
                'search_query': 'search_term_text',
                'clicks': 'taps',
                'conversions': 'tap_installs',
                'conversions_value': 'null'
            },
        relation=ref('apple_search_ads__search_term_report')
    ) }}
), 
{% endif %}

{% if 'amazon_ads' in enabled_packages %}
amazon_ads as (

    {{ get_query(
        platform='amazon_ads', 
        report_type='search', 
        field_mapping={
                'spend': 'cost',
                'search_match_type': 'match_type',
                'search_query': 'search_term',
                'conversions': 'purchases_30_d',
                'conversions_value': 'sales_30_d'
            },
        relation=ref('amazon_ads__search_report')
    ) }}
), 
{% endif %}

{% if 'google_ads' in enabled_packages and var('google_ads__using_search_term_keyword_stats', True) %}
google_ads as (

    {{ get_query(
        platform='google_ads', 
        report_type='search', 
        field_mapping={
                'search_match_type': 'search_term_match_type',
                'search_query': 'search_term',
                'keyword_id': 'criterion_id'
            },
        relation=ref('google_ads__search_term_report')
    ) }}
), 
{% endif %}

unioned as (

    {{ union_ctes(ctes=enabled_packages)}}
)

select *
from unioned
