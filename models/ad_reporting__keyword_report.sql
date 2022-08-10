with base as (

    select *
    from {{ ref('int_ad_reporting__keyword_report') }}
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
        keyword_id,
        keyword_text,
        keyword_match_type,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend
    from base
    {{ dbt_utils.group_by(11) }}
)

select *
from aggregated