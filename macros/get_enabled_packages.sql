{% macro get_enabled_packages(exclude=none, include=none) %}

{%- if exclude and include -%}
    {{ exceptions.raise_compiler_error("Both an exclude and include list were provided `get_enabled_packages` macro. Only one is allowed") }}
{%- endif -%}

{% set all_packages = [
    'amazon_ads',
    'apple_search_ads', 
    'facebook_ads', 
    'google_ads', 
    'linkedin_ads',
    'microsoft_ads', 
    'pinterest_ads',
    'snapchat_ads',
    'tiktok_ads',
    'twitter_ads',
    'reddit_ads'] %}

{% set enabled_packages = [] %}

{% if include != [] %}
    {% for package in all_packages if var('ad_reporting__' ~ package ~ '_enabled', True) %}
        {% if include is not none %}
            {{ enabled_packages.append(package) if package in include }}
        {% elif exclude is not none %}
            {{ enabled_packages.append(package) if package not in exclude }}
        {% else %}
            {{ enabled_packages.append(package) }}
        {% endif %}
    {% endfor %}
{% endif %}

{{ return(enabled_packages) }}

{% endmacro %}