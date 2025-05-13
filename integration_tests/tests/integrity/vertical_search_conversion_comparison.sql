{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with search_report as (

    select 
        platform,
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.ad_reporting__search_report
    group by 1
),

amazon_ads as (

    select 
        sum(coalesce(purchases_30_d,0)) as conversions,
        sum(coalesce(sales_30_d,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.amazon_ads__search_report
),

{% if var('apple_search_ads__using_search_terms', true ) %}
apple_search_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(0) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.apple_search_ads__search_term_report
),
{% endif %}

{% if var('google_ads__using_search_term_keyword_stats', true ) %}
google_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.google_ads__search_term_report
),
{% endif %}

microsoft_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.microsoft_ads__search_report
)

select 
    'amazon_ads' as platform
from search_report
join amazon_ads
    on search_report.platform = 'amazon_ads'
where abs(amazon_ads.conversions - search_report.conversions) >= .01
    or abs(amazon_ads.conversions_value - search_report.conversions_value) >= .01

union all 

{% if var('apple_search_ads__using_search_terms', true ) %}
select 
    'apple_search_ads' as platform
from search_report
join apple_search_ads
    on search_report.platform = 'apple_search_ads'
where abs(apple_search_ads.conversions - search_report.conversions) >= .01
    or abs(apple_search_ads.conversions_value - search_report.conversions_value) >= .01

union all 
{% endif %}

{% if var('google_ads__using_search_term_keyword_stats', true ) %}
select 
    'google_ads' as platform
from search_report
join google_ads
    on search_report.platform = 'google_ads'
where abs(google_ads.conversions - search_report.conversions) >= .01
    or abs(google_ads.conversions_value - search_report.conversions_value) >= .01

union all 
{% endif %}

select 
    'microsoft_ads' as platform
from search_report
join microsoft_ads
    on search_report.platform = 'microsoft_ads'
where abs(microsoft_ads.conversions - search_report.conversions) >= .01
    or abs(microsoft_ads.conversions_value - search_report.conversions_value) >= .01