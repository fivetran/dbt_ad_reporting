{% set enabled_packages = get_enabled_packages() %}
{{ config(enabled=is_enabled(enabled_packages),
    unique_key = ['source_relation','platform','date_day','campaign_id','account_id'],
    partition_by={
      "field": "date_day",
      "data_type": "date",
      "granularity": "day"
    }
    ) }}

with base as (

    select *
    from {{ ref('int_ad_reporting__campaign_report') }}
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
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value

        {{ ad_reporting_persist_pass_through_columns(pass_through_variable='ad_reporting__campaign_passthrough_metrics', transform = 'sum', alias_fields=['conversions', 'conversions_value']) }}

    from base
    {{ dbt_utils.group_by(7) }}
),

all_data as(
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
,sum(clicks) as clicks
,sum(impressions) as impressions
,sum(spend) as spend
,sum(conversions) as conversions  
,sum(conversions_value) as conversions_value,
sum(video_views_25) as video_25p_watched,  
sum(video_views_50) as video_50p_watched, 
sum(video_views_75) as video_75p_watched, 
sum(video_views_100) as video_complete_watched
from 
    {{ref('youtube_ads__custom_ad_summary_report')}}
group by 1,2,3,4,5,6,7

union all

SELECT 
source_relation
,date_day
,platform
,account_id
,account_name
,campaign_id
,campaign_name
,sum(clicks) as clicks
,sum(impressions) as impressions
,sum(spend) as spend
,sum(conversions) as conversions 
, null as conversions_value,
sum(player_25p_complete) as video_25p_watched, 
sum(player_50p_complete) as video_50p_watched, 
sum(player_75p_complete) as video_75p_watched, 
sum(player_completed_views) as video_complete_watched
from {{ ref('ttd_ads__campaign_report') }}  
group by 1,2,3,4,5,6,7

union all

SELECT 
'' as source_relation
,performance_date as date_day
,'zefr' as platform
,'' as account_id
,account_name
,campaign_group_id as campaign_id
,campaign_group_name as campaign_name
,clicks
,impressions
,spend
, null as conversions 
, null as conversions_value,
video_view_25pct as video_25p_watched, 
video_view_50pct as video_50p_watched, 
video_view_75pct as video_75p_watched, 
video_view_100pct as video_complete_watched
from {{ ref('zefr_campaign_summary_report') }}  

union all

 SELECT 
'' as source_relation,
 date_day,
platform,
account_id,
account_name,
campaign_id,
campaign_name,
clicks,
impressions,
spend,
conversions, 
conversions_value,
null as video_25p_watched, 
video_midpoint as video_50p_watched, 
null as video_75p_watched, 
video_complete as video_complete_watched
from {{ ref('amazon_dsp__campaign_report') }}  


)

select *
from all_data
