{% if var('apple_search_ads__using_search_terms', True) %}
    {% set include_list = ['amazon_ads', 'apple_search_ads', 'microsoft_ads'] %}
{% else %}
    {% set include_list = ['amazon_ads', 'microsoft_ads'] %}
{% endif %}

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
                'clicks': 'taps'
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
                'search_query': 'search_term'
            },
        relation=ref('amazon_ads__search_report')
    ) }}
), 
{% endif %}

unioned as (

    {{ union_ctes(ctes=enabled_packages)}}
)

select *
from unioned
