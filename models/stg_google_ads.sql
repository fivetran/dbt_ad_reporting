{{ config(enabled=var('ad_reporting__google_ads_enabled')) }}

with base as (

    select *
    {% if var('ad_reporting__google_ads_type') == 'final_url' %}
    from {{ ref('google_ads__url_ad_adapter')}}
    {% elif var('ad_reporting__google_ads_type') == 'criteria' %}
    from {{ ref('google_ads__criteria_ad_adapter')}}
    {% endif %}

), fields as (

    select
        'Google Ads' as platform,
        cast(date_day as date) as date_day,
        account_name,
        external_customer_id as account_id,
        campaign_name,
        cast(campaign_id as {{ dbt_utils.type_string() }}) as campaign_id,
        ad_group_name,
        cast(ad_group_id as {{ dbt_utils.type_string() }}) as ad_group_id,
        {% if var('ad_reporting__google_ads_type') == 'final_url' %}
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        coalesce(clicks, 0) as clicks,
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend
        {% elif var('ad_reporting__google_ads_type') == 'criteria' %}
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend
        {% endif %}

    from base
    {% if var('ad_reporting__google_ads_type') == 'criteria' %}
    group by 1,2,3,4,5,6,7,8
    {% endif %}

)

select *
from fields