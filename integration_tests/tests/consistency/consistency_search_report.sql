{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        search_query,
        keyword_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
        {# sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value #}
    from {{ target.schema }}_ad_reporting_prod.ad_reporting__search_report
    group by 1,2
),

dev as (
    select
        search_query,
        keyword_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
        {# sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value #}
    from {{ target.schema }}_ad_reporting_dev.ad_reporting__search_report
    group by 1,2
),

final as (
    select 
        prod.search_query,
        prod.keyword_id,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend
        {# prod.conversions as prod_conversions,
        dev.conversions as dev_conversions,
        prod.conversions_value as prod_conversions_value,
        dev.conversions_value as dev_conversions_value #}
    from prod
    full outer join dev 
        on dev.search_query = prod.search_query
        and dev.keyword_id = prod.keyword_id

)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
    {# or abs(prod_conversions - dev_conversions) >= .01
    or abs(prod_conversions_value - dev_conversions_value) >= .01 #}