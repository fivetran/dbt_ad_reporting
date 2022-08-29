with prep_standardized_union as (

    {{ dbt_utils.union_relations(
        relations=[
            ref('google_ads__ad_group_report'),
            ref('microsoft_ads__ad_group_report')],
        source_column_name='platform',
        include=['date_day', 
                'account_id', 
                'account_name', 
                'campaign_id',
                'campaign_name',
                'ad_group_id',
                'ad_group_name',
                'clicks', 
                'impressions', 
                'spend']) }}
), 

prep_standardized_union_platform_rename as (

    select 
        cast(date_day as DATE) as date_day,
        CASE 
            WHEN lower(platform) like '%google_ads__ad_group_report`' then 'google_ads'
            WHEN lower(platform) like '%microsoft_ads__ad_group_report`' then 'microsoft_ads'
        END as platform,

        -- Below fields/aliases must be in alphabetical order 
        cast(account_id as {{ dbt_utils.type_string() }}) as account_id,
        cast(account_name as {{ dbt_utils.type_string() }}) as account_name,
        cast(ad_group_id as {{ dbt_utils.type_string() }}) as ad_group_id,
        cast(ad_group_name as {{ dbt_utils.type_string() }}) as ad_group_name,
        cast(account_id as {{ dbt_utils.type_string() }}) as campaign_id,
        cast(account_name as {{ dbt_utils.type_string() }}) as campaign_name,
        cast(clicks as {{ dbt_utils.type_int() }}) as clicks,
        cast(impressions as {{ dbt_utils.type_int() }}) as impressions,
        cast(spend as {{ dbt_utils.type_float() }}) as spend
    from prep_standardized_union
),

prep_apple_search as (

    {{ field_name_conversion(
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

prep_linkedin as (

    {{ field_name_conversion(
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

prep_facebook as (

    {{ field_name_conversion(
        platform='facebook_ads', 
        report_type='ad_group', 
        field_mapping={
                'ad_group_id': 'ad_set_id',
                'ad_group_name': 'ad_set_name'
            },
        relation=ref('facebook_ads__ad_set_report')
    ) }}
),

prep_pinterest as (

    {{ field_name_conversion(
        platform='pinterest_ads', 
        report_type='ad_group', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name'
            },
        relation=ref('pinterest_ads__ad_group_report')
    ) }}
),

prep_snapchat as (

    {{ field_name_conversion(
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

prep_tiktok as (

    {{ field_name_conversion(
        platform='tiktok_ads', 
        report_type='ad_group', 
        field_mapping={
                'account_id': 'advertiser_id',
                'account_name': 'advertiser_name'
            },
        relation=ref('tiktok_ads__ad_group_report')
    ) }}
), 

prep_twitter as (

    {{ field_name_conversion(
        platform='twitter_ads', 
        report_type='ad_group', 
        field_mapping={
                'ad_group_id': 'line_item_id',
                'ad_group_name': 'line_item_name'
            },
        relation=ref('twitter_ads__line_item_report')
    ) }}
), 

unioned as (

    {{ union_ctes(ctes=[
        'prep_standardized_union_platform_rename',
        'prep_apple_search',
        'prep_facebook',
        'prep_linkedin',
        'prep_pinterest',
        'prep_snapchat',
        'prep_tiktok',
        'prep_twitter']
    ) }}
)

select *
from unioned