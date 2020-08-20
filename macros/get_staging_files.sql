{% macro get_staging_files() %}

    {% set staging_file = [] %}

    {% if var('ad_reporting__pinterest_enabled') %} 
    {% set _ = staging_file.append(ref('stg_pinterest')) %}
    {% endif %}

    {% if var('ad_reporting__bing_ads_enabled') %} 
    {% set _ = staging_file.append(ref('stg_bing_ads')) %}
    {% endif %}

    {% if var('ad_reporting__linkedin_ads_enabled') %} 
    {% set _ = staging_file.append(ref('stg_linkedin_ads')) %}
    {% endif %}

    {{ return(staging_file) }}

{% endmacro %}


