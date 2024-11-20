{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with ad_group_report as (

    select 
        platform,
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.ad_reporting__ad_group_report
    group by 1
),

amazon_ads as (

    select 
        sum(coalesce(purchases_30_d,0)) as conversions,
        sum(coalesce(sales_30_d,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.amazon_ads__ad_group_report
),

apple_search_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(0) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.apple_search_ads__ad_group_report
),

linkedin_ads as (

    select 
        sum(coalesce(total_conversions,0)) as conversions,
        sum(coalesce(conversion_value_in_local_currency,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.linkedin_ads__campaign_report
),

pinterest_ads as (

    select 
        sum(coalesce(total_conversions,0)) as conversions,
        sum(coalesce(total_conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.pinterest_ads__ad_group_report
),

snapchat_ads as (

    select 
        sum(coalesce(total_conversions,0)) as conversions,
        sum(coalesce(conversion_purchases_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.snapchat_ads__ad_squad_report
),

tiktok_ads as (

    select 
        sum(coalesce(conversion,0)) as conversions,
        sum(coalesce(total_conversion_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.tiktok_ads__ad_group_report
),

twitter_ads as (

    select 
        sum(coalesce(total_conversions,0)) as conversions,
        sum(coalesce(total_conversions_sale_amount,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.twitter_ads__line_item_report
),

google_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.google_ads__ad_group_report
),

facebook_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.facebook_ads__ad_set_report
),

microsoft_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(conversions_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.microsoft_ads__ad_group_report
),

reddit_ads as (

    select 
        sum(coalesce(conversions,0)) as conversions,
        sum(coalesce(total_value,0)) as conversions_value
    from {{ target.schema }}_ad_reporting_dev.reddit_ads__ad_group_report
)

select 
    'amazon_ads' as platform
from ad_group_report
join amazon_ads
    on ad_group_report.platform = 'amazon_ads'
where abs(amazon_ads.conversions - ad_group_report.conversions) >= .01
    or abs(amazon_ads.conversions_value - ad_group_report.conversions_value) >= .01

union all 

select 
    'apple_search_ads' as platform
from ad_group_report
join apple_search_ads
    on ad_group_report.platform = 'apple_search_ads'
where abs(apple_search_ads.conversions - ad_group_report.conversions) >= .01
    or abs(apple_search_ads.conversions_value - ad_group_report.conversions_value) >= .01

union all 

select 
    'linkedin_ads' as platform
from ad_group_report
join linkedin_ads
    on ad_group_report.platform = 'linkedin_ads'
where abs(linkedin_ads.conversions - ad_group_report.conversions) >= .01
    or abs(linkedin_ads.conversions_value - ad_group_report.conversions_value) >= .01

union all 

select 
    'pinterest_ads' as platform
from ad_group_report
join pinterest_ads
    on ad_group_report.platform = 'pinterest_ads'
where abs(pinterest_ads.conversions - ad_group_report.conversions) >= .01
    or abs(pinterest_ads.conversions_value - ad_group_report.conversions_value) >= .01

union all 

select 
    'snapchat_ads' as platform
from ad_group_report
join snapchat_ads
    on ad_group_report.platform = 'snapchat_ads'
where abs(snapchat_ads.conversions - ad_group_report.conversions) >= .01
    or abs(snapchat_ads.conversions_value - ad_group_report.conversions_value) >= .01

union all 

select 
    'tiktok_ads' as platform
from ad_group_report
join tiktok_ads
    on ad_group_report.platform = 'tiktok_ads'
where abs(tiktok_ads.conversions - ad_group_report.conversions) >= .01
    or abs(tiktok_ads.conversions_value - ad_group_report.conversions_value) >= .01

union all 

select 
    'twitter_ads' as platform
from ad_group_report
join twitter_ads
    on ad_group_report.platform = 'twitter_ads'
where abs(twitter_ads.conversions - ad_group_report.conversions) >= .01
    or abs(twitter_ads.conversions_value - ad_group_report.conversions_value) >= .01

union all 

select 
    'google_ads' as platform
from ad_group_report
join google_ads
    on ad_group_report.platform = 'google_ads'
where abs(google_ads.conversions - ad_group_report.conversions) >= .01
    or abs(google_ads.conversions_value - ad_group_report.conversions_value) >= .01

union all 

select 
    'facebook_ads' as platform
from ad_group_report
join facebook_ads
    on ad_group_report.platform = 'facebook_ads'
where abs(facebook_ads.conversions - ad_group_report.conversions) >= .01
    or abs(facebook_ads.conversions_value - ad_group_report.conversions_value) >= .01

union all 

select 
    'microsoft_ads' as platform
from ad_group_report
join microsoft_ads
    on ad_group_report.platform = 'microsoft_ads'
where abs(microsoft_ads.conversions - ad_group_report.conversions) >= .01
    or abs(microsoft_ads.conversions_value - ad_group_report.conversions_value) >= .01
union all 

select 
    'reddit_ads' as platform
from ad_group_report
join reddit_ads
    on ad_group_report.platform = 'reddit_ads'
where abs(reddit_ads.conversions - ad_group_report.conversions) >= .01
    or abs(reddit_ads.conversions_value - ad_group_report.conversions_value) >= .01