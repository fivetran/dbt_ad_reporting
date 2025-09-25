{% set enabled_packages = get_enabled_packages() %}
{{ config(enabled=is_enabled(enabled_packages),
    unique_key = ['source_relation','platform','date_day','ad_id','ad_group_id','campaign_id','account_id'],
    partition_by={
      "field": "date_day",
      "data_type": "date",
      "granularity": "day"
    }
    ) }}

with base as (

    select *
    from {{ ref('int_ad_reporting__ad_report') }}
),

aggregated as (
    
    select
        source_relation,
        date_day,
        platform,
        account_id,
        account_name,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        ad_id,
        ad_name,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value
        
        {{ ad_reporting_persist_pass_through_columns(pass_through_variable='ad_reporting__ad_passthrough_metrics', transform = 'sum', alias_fields=['conversions', 'conversions_value']) }}

    from base
    {{ dbt_utils.group_by(11) }}
),

all_data as (
select *
from aggregated

union all

SELECT 
'' as source_relation
,date_day
,'youtube' as platform
,cast(account_id as string)
,account_name
,cast(campaign_id as string)
,campaign_name
,cast(ad_group_id as string)
,ad_group_name
,cast(ad_id as string)
,ad_name
,clicks
,impressions
,spend
,conversions 
,conversions_value  ,
video_views_25 as video_25p_watched,  
video_views_50 as video_50p_watched, 
video_views_75 as video_75p_watched, 
video_views_100 as video_complete_watched
from 
    {{ref('youtube_ads__custom_ad_summary_report')}}

union all

SELECT 
source_relation
,date_day
,platform
,account_id
,account_name
,campaign_id
,campaign_name
,ad_group_id
,ad_group_name
,ad_id
,ad_name
,sum(clicks) as clicks
,sum(impressions) as impressions
,sum(spend) as spend
,sum(conversions) as conversions 
, null as conversions_value,
sum(player_25p_complete) as video_25p_watched, 
sum(player_50p_complete) as video_50p_watched, 
sum(player_75p_complete) as video_75p_watched, 
sum(player_completed_views) as video_complete_watched
from {{ ref('ttd_ads__ad_report') }}  
group by 1,2,3,4,5,6,7,8,9,10,11

union all

SELECT 
'' as source_relation
,performance_date as date_day
,'zefr' as platform
,null as account_id
,account_name
,campaign_group_id as campaign_id
,campaign_group_name as campaign_name
,ad_group_id
,ad_group_name
,null as ad_id
,ad_name
,sum(clicks) as clicks
,sum(impressions) as impressions
,sum(spend) as spend
, null as conversions 
, null as conversions_value,
sum(video_view_25pct) as video_25p_watched, 
sum(video_view_50pct) as video_50p_watched, 
sum(video_view_75pct) as video_75p_watched, 
sum(video_view_100pct) as video_complete_watched
from {{ ref('zefr_ad_summary_report') }}  
group by 1,2,3,4,5,6,7,8,9,10,11
)

select *
from all_data
