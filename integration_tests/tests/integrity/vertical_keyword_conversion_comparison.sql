{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with keyword_report as (

    select 
        platform,
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.ad_reporting__keyword_report
    group by 1
),

amazon_ads as (

    select 
        sum(coalesce(purchases_30_d,0)) as conversions,
        sum(coalesce(sales_30_d,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.amazon_ads__keyword_report
),

apple_search_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(0) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.apple_search_ads__keyword_report
),

pinterest_ads as (

    select 
        sum(coalesce(total_conversions,0)) as conversions,
        sum(coalesce(total_conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.pinterest_ads__keyword_report
),

{% if var('twitter_ads__using_keywords', true ) %}
twitter_ads as (

    select 
        sum(coalesce(total_conversions,0)) as conversions,
        sum(coalesce(total_conversions_sale_amount,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.twitter_ads__keyword_report
),
{% endif %}

google_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.google_ads__keyword_report
),

microsoft_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.microsoft_ads__keyword_report
)

select 
    'amazon_ads' as platform
from keyword_report
join amazon_ads
    on keyword_report.platform = 'amazon_ads'
where abs(amazon_ads.conversions - keyword_report.conversions) >= .01
    or abs(amazon_ads.conversions_value - keyword_report.conversions_value) >= .01

union all 

select 
    'apple_search_ads' as platform
from keyword_report
join apple_search_ads
    on keyword_report.platform = 'apple_search_ads'
where abs(apple_search_ads.conversions - keyword_report.conversions) >= .01
    or abs(apple_search_ads.conversions_value - keyword_report.conversions_value) >= .01

union all 

select 
    'pinterest_ads' as platform
from keyword_report
join pinterest_ads
    on keyword_report.platform = 'pinterest_ads'
where abs(pinterest_ads.conversions - keyword_report.conversions) >= .01
    or abs(pinterest_ads.conversions_value - keyword_report.conversions_value) >= .01

union all 

{% if var('twitter_ads__using_keywords', true ) %}
select 
    'twitter_ads' as platform
from keyword_report
join twitter_ads
    on keyword_report.platform = 'twitter_ads'
where abs(twitter_ads.conversions - keyword_report.conversions) >= .01
    or abs(twitter_ads.conversions_value - keyword_report.conversions_value) >= .01

union all 
{% endif %}

select 
    'google_ads' as platform
from keyword_report
join google_ads
    on keyword_report.platform = 'google_ads'
where abs(google_ads.conversions - keyword_report.conversions) >= .01
    or abs(google_ads.conversions_value - keyword_report.conversions_value) >= .01

union all 

select 
    'microsoft_ads' as platform
from keyword_report
join microsoft_ads
    on keyword_report.platform = 'microsoft_ads'
where abs(microsoft_ads.conversions - keyword_report.conversions) >= .01
    or abs(microsoft_ads.conversions_value - keyword_report.conversions_value) >= .01