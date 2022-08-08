{# Standard fields for search reports are:
    - 'account_id'
    - 'account_name'
    - 'campaign_id'
    - 'campaign_name'
    - 'ad_group_id'
    - 'ad_group_name'
    - 'keyword_id'
    - 'keyword_text'
    - 'search_query'
    - 'search_match_type'
    - 'clicks'
    - 'impressions'
    - 'spend'
#}

{#
with prep_microsoft as (

    {{ field_name_conversion(
        platform='microsoft_ads', 
        report_type='search', 
        field_mapping={
                'keyword_text': 'keyword_name',
                'search_match_type': 'match_type'
            },
        relation=ref('microsoft_ads__search_report')
    ) }}
), 

prep_apple_search as (

    {{ field_name_conversion(
        platform='apple_search_ads', 
        report_type='search', 
        field_mapping={
                'keyword_text': 'keyword_name',
                'search_match_type': 'match_type',
                'search_query': 'search_term_text'
            },
        relation=ref('apple_search_ads__search_report')
    ) }}
), 

unioned as (

    {{ union_ctes(ctes=[
        'prep_microsoft',
        'prep_apple_search']
    ) }}
)

select *
from unioned
#}