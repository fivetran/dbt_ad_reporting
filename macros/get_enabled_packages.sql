{% macro get_enabled_packages(exclude=[], include=[]) %}

{%- if exclude and include -%}
    {{ exceptions.raise_compiler_error("Both an exclude and include list were provided `get_enabled_packages` macro. Only one is allowed") }}
{%- endif -%}

{% set all_packages = [
    'apple_search_ads', 
    'facebook_ads', 
    'google_ads', 
    'linkedin_ads',
    'microsoft_ads', 
    'pinterest_ads',
    'snapchat_ads',
    'tiktok_ads',
    'twitter_ads',
    'amazon_ads'] %}

{% set enabled_packages = [] %}

{% if include != [] %}
    {% for package in include %}
        {% if var('ad_reporting__' ~ package ~ '_enabled', True) %}
            {{ enabled_packages.append(package) }}
        {% endif %}
    {% endfor %}

{% elif exclude != [] %}
    {% for package in all_packages %}
        {% if var('ad_reporting__' ~ package ~ '_enabled', True) and package not in exclude %}
            {{ enabled_packages.append(package) }}
        {% endif %}
    {% endfor %}

{% else %}
    {% for package in all_packages %}
        {% if var('ad_reporting__' ~ package ~ '_enabled', True) %}
            {{ enabled_packages.append(package) }}
        {% endif %}
    {% endfor %}
{% endif %}

{{ return(enabled_packages) }}

{% endmacro %}