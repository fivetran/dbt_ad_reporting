{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        ad_id,
        sum(coalesce(clicks, 0)) as clicks, 
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend
        sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value
    from {{ target.schema }}_ad_reporting_prod.ad_reporting__ad_report
    group by 1
),

dev as (
    select
        ad_id,
        sum(coalesce(clicks, 0)) as clicks, 
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend
        sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.ad_reporting__ad_report
    group by 1
),

final as (
    select 
        prod.ad_id,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend
        prod.conversions as prod_conversions,
        dev.conversions as dev_conversions,
        prod.conversions_value as prod_conversions_value,
        dev.conversions_value as dev_conversions_value
    from prod
    full outer join dev 
        on dev.ad_id = prod.ad_id
)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
    or abs(prod_conversions - dev_conversions) >= .01
    or abs(prod_conversions_value - dev_conversions_value) >= .01
