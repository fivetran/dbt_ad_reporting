{% set enabled_packages = get_enabled_packages() %}
{{ config(enabled=is_enabled(enabled_packages)) }}

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
)

select *
from aggregated