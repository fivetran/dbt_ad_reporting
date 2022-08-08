with base as (

    select *
    from {{ ref('int_ad_reporting__url_report') }}
),

aggregated as (
    
    select 
        date_day, 
        platform,
        account_id, 
        account_name, 
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend
    from base
    {{ dbt_utils.group_by(16) }}
)

select *
from aggregated