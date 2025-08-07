{% set enabled_packages = get_enabled_packages() %}
{{ config(enabled=is_enabled(enabled_packages),
    unique_key = ['source_relation','platform','date_day','account_id'],
    partition_by={
      "field": "date_day",
      "data_type": "date",
      "granularity": "day"
    }
) }}

with base as (

    select *
    from {{ ref('int_ad_reporting__account_report') }}
),

aggregated as (
    
    select
        source_relation,
        date_day,
        platform,
        account_id,
        account_name,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value

        {{ ad_reporting_persist_pass_through_columns(pass_through_variable='ad_reporting__account_passthrough_metrics', transform = 'sum', alias_fields=['conversions', 'conversions_value']) }}

    from base
    {{ dbt_utils.group_by(5) }}
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
,sum(clicks) as clicks
,sum(impressions) as impressions
,sum(spend) as spend
,sum(conversions) as conversions
,sum(conversions_value) as conversions_value    
from 
    {{ref('youtube_ads__custom_ad_summary_report')}}
group by 1,2,3,4,5

union all

SELECT 
source_relation
,date_day
,platform
,account_id
,account_name
,clicks
,impressions
,spend
,conversions   
, null as conversions_value
from {{ ref('ttd_ads__account_report') }}

)

select *
from all_data

