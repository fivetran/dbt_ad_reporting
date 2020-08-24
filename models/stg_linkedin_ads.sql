{{ config(enabled=var('ad_reporting__linkedin_ads_enabled')) }}

with base as (

    select *
    from {{ ref('linkedin__ad_adapter')}}

), fields as (

    select
        'LinkedIn Ads' as platform,
        date_day,
        account_name,
        account_id,
        campaign_name,
        campaign_id,
        campaign_group_name as ad_group_name,
        campaign_group_id as ad_group_id,
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        clicks,
        impressions,
        cost as spend
    from base


)

select *
from fields