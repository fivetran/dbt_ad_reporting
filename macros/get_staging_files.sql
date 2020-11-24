{% macro get_staging_files() %}

    {% set staging_file = [] %}

    {% if var('ad_reporting__pinterest_enabled') %} 
    {% set _ = staging_file.append(ref('stg_pinterest')) %}
    {% endif %}

    {% if var('ad_reporting__microsoft_ads_enabled') %} 
    {% set _ = staging_file.append(ref('stg_microsoft_ads')) %}
    {% endif %}

    {% if var('ad_reporting__linkedin_ads_enabled') %} 
    {% set _ = staging_file.append(ref('stg_linkedin_ads')) %}
    {% endif %}

    {% if var('ad_reporting__twitter_ads_enabled') %} 
    {% set _ = staging_file.append(ref('stg_twitter_ads')) %}
    {% endif %}

    {% if var('ad_reporting__google_ads_enabled') %} 
    {% set _ = staging_file.append(ref('stg_google_ads')) %}
    {% endif %}

    {{ return(staging_file) }}

{% endmacro %}


