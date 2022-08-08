-- add apple search ads
-- add twitter
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
#}

with prep_google as (

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

{#- Below CTEs can be uncommented once new persist logic is released in `fivetran_utils` -#}

unioned as (

    {{ union_ctes(ctes=[
        'prep_google',
        'prep_microsoft',
        'prep_pinterest']
    ) }}
)

select *
from unioned