{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        date_day,
        platform,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_ad_reporting_prod.ad_reporting__ad_report
    group by 1, 2
),

dev as (
    select
        date_day,
        platform,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_ad_reporting_dev.ad_reporting__ad_report
    group by 1, 2
),

final as (
    select 
        prod.date_day,
        dev.date_day,
        prod.platform,
        dev.platform,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend
    from prod
    full outer join dev 
        on dev.date_day = prod.date_day
        and dev.platform = prod.platform
)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01