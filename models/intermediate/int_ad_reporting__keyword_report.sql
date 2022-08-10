{# Standard fields for keyword reports are:
    - 'account_id'
    - 'account_name'
    - 'campaign_id'
    - 'campaign_name'
    - 'ad_group_id'
    - 'ad_group_name'
    - 'keyword_id'
    - 'keyword_text'
    - 'keyword_match_type'
    - 'clicks'
    - 'impressions'
    - 'spend'
#}

with prep_apple_search as (

    {{ field_name_conversion(
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

prep_google as (

    {{ field_name_conversion(
        platform='google_ads', 
        report_type='keyword', 
        field_mapping={
                'keyword_id': 'criterion_id',
            },
        relation=ref('google_ads__keyword_report')
    ) }}
),

prep_microsoft as (

    {{ field_name_conversion(
        platform='microsoft_ads', 
        report_type='keyword', 
        field_mapping={
                'keyword_text': 'keyword_name',
                'keyword_match_type': 'match_type'
            },
        relation=ref('microsoft_ads__keyword_report')
    ) }}
),

prep_pinterest as (

    {{ field_name_conversion(
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

prep_twitter as (

    {{ field_name_conversion(
        platform='twitter_ads', 
        report_type='keyword', 
        field_mapping={
                'ad_group_id': 'line_item_id',
                'ad_group_name': 'line_item_name',
                'keyword_id': 'null',
                'keyword_text': 'keyword',
                'keyword_match_type': 'null'
            },
        relation=ref('twitter_ads__keyword_report')
    ) }}
), 

unioned as (

    {{ union_ctes(ctes=[
        'prep_apple_search',
        'prep_google',
        'prep_microsoft',
        'prep_pinterest',
        'prep_twitter']
    ) }}
)

select *
from unioned