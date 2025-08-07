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
,conversions_value   
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
,clicks
,impressions
,spend
,conversions  
, null as conversions_value  
from {{ ref('ttd_ads__ad_report') }}  

)

select *
from all_data