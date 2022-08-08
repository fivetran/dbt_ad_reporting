-- TO DO:
-- Test untested additions (Apple Search Ads, Twitter, Linkedin) after persist logic is released into fivetran utils
with prep_standardized_union as (

    {{ dbt_utils.union_relations(
        relations=[
            ref('facebook_ads__account_report'),
            ref('google_ads__account_report'),
            ref('microsoft_ads__account_report')     
            ],
        source_column_name='platform',
        include=['date_day',
                'account_id', 
                'account_name', 
                'clicks', 
                'impressions', 
                'spend']) }}
), 

prep_standardized_union_platform_rename as (

    select 
        cast(date_day as DATE) as date_day,
        CASE 
            WHEN lower(platform) like '%facebook_ads__account_report`' then 'facebook_ads'
            WHEN lower(platform) like '%google_ads__account_report`' then 'google_ads'
            WHEN lower(platform) like '%microsoft_ads__account_report`' then 'microsoft_ads'
        END as platform,

        -- Below fields/aliases must be in alphabetical order 
        cast(account_id as {{ dbt_utils.type_int() }}) as account_id,
        cast(account_name as {{ dbt_utils.type_string() }}) as account_name,
        cast(clicks as {{ dbt_utils.type_int() }}) as clicks,
        cast(impressions as {{ dbt_utils.type_int() }}) as impressions,
        cast(spend as {{ dbt_utils.type_float() }}) as spend
    from prep_standardized_union
),

prep_pinterest as (

    {{ field_name_conversion(
        platform='pinterest_ads', 
        report_type='account', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name'
            },
        relation=ref('pinterest_ads__advertiser_report')
    ) }}
),

prep_snapchat as (

    {{ field_name_conversion(
        platform='snapchat_ads', 
        report_type='account', 
        field_mapping={
                'account_id': 'ad_account_id',
                'account_name': 'ad_account_name',
                'clicks':'swipes'
            },
        relation=ref('snapchat_ads__account_report')
    ) }}
), 

prep_tiktok as (

    {{ field_name_conversion(
        platform='tiktok_ads', 
        report_type='account', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name'
            },
        relation=ref('tiktok_ads__advertiser_report')
    ) }}
), 

unioned as (

    {{ union_ctes(ctes=[
        'prep_standardized_union_platform_rename',
        'prep_pinterest',
        'prep_snapchat',
        'prep_tiktok']
    ) }}
)


select *
from unioned