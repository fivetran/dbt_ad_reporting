{% macro field_name_conversion(platform=None, report_type=None, field_mapping=None, relation=None) %}

{%- set consistent_fields = ['spend', 'impressions', 'clicks'] -%}
{%- set account_fields = ['account_id', 'account_name'] -%}
{%- set campaign_fields = ['campaign_id', 'campaign_name'] -%}
{%- set ad_group_fields = ['ad_group_id', 'ad_group_name'] -%}
{%- set ad_fields = ['ad_id', 'ad_name'] -%}
{%- set url_fields = ['base_url', 'url_host', 'url_path', 'utm_source', 'utm_medium', 'utm_campaign', 'utm_content', 'utm_term'] -%}
{%- set keyword_fields = ['keyword_id','keyword_text','keyword_match_type'] -%}
{%- set search_fields = ['keyword_id', 'keyword_text', 'search_match_type', 'search_query'] -%}

{%- if field_mapping is not none -%}
{%- set fields = field_mapping.keys() -%}
{%- endif -%}

{%- set final_fields_superset={} -%}

{#- Add the consistent_fields and account_fields to all reports regardless of type -#}
{%- if report_type -%}
    {%- for consistent_field in consistent_fields -%}
        {%- do final_fields_superset.update({consistent_field: consistent_field}) -%}
    {%- endfor -%}
    {%- for account_field in account_fields -%}
        {%- do final_fields_superset.update({account_field: account_field}) -%}
    {%- endfor -%}
{%- endif -%}

{#- For campaign level reports and lower, add campaign_fields -#}
{%- if report_type in ['campaign', 'ad_group', 'ad', 'url', 'keyword', 'search'] -%}
    {%- for campaign_field in campaign_fields -%}
        {%- do final_fields_superset.update({campaign_field: campaign_field}) -%}
    {%- endfor -%}
{%- endif -%}

{#- For ad_group level reports, equivalent and lower, add ad_group_fields -#}
{%- if report_type in ['ad_group', 'ad', 'url', 'keyword', 'search'] -%}
    {%- for ad_group_field in ad_group_fields -%}
        {%- do final_fields_superset.update({ad_group_field: ad_group_field}) -%}
    {%- endfor -%}
{%- endif -%}

{#- For ad level reports, add ad_fields -#}
{%- if report_type == 'ad' -%}
    {%- for ad_field in ad_fields -%}
        {%- do final_fields_superset.update({ad_field: ad_field})-%}
    {%- endfor -%}
{%- endif -%}

{#- For url level reports, add url_fields -#}
{%- if report_type == 'url' -%}
    {%- for url_field in url_fields -%}
        {%- do final_fields_superset.update({url_field: url_field})-%}
    {%- endfor -%}
{%- endif -%}

{#- For keyword level reports, add keyword_fields -#}
{%- if report_type == 'keyword' -%}
    {%- for keyword_field in keyword_fields -%}
        {%- do final_fields_superset.update({keyword_field: keyword_field})-%}
    {%- endfor -%}
{%- endif -%}

{#- For search level reports, add search_fields -#}
{%- if report_type == 'search' -%}
    {%- for search_field in search_fields -%}
        {%- do final_fields_superset.update({search_field: search_field})-%}
    {%- endfor -%}
{%- endif -%}

{%- if field_mapping is not none -%}
    {%- for field in fields -%}
        {%- do final_fields_superset.update({field:field_mapping[field]}) -%}
    {%- endfor -%}
{%- endif -%}

select 
    {{ get_date_from_timestamp('date_day') }} as date_day,
    cast( '{{ platform }}' as {{ dbt_utils.type_string() }}) as platform,

    {% for field in final_fields_superset.keys()|sort() -%}
    {% if field in ['clicks', 'impressions'] -%}
    cast({{ final_fields_superset[field] }} as {{ dbt_utils.type_int() }}) as {{ field }}

    {% elif field == 'spend' -%}
    cast({{ final_fields_superset[field] }} as {{ dbt_utils.type_float() }}) as {{ field }}

    {% elif '_id' in field or '_name' in field or 'url' in field or 'utm' in field or field in ['keyword_match_type', 'keyword_text', 'search_match_type', 'search_query'] -%}
    cast({{ final_fields_superset[field] }} as {{ dbt_utils.type_string() }}) as {{ field }} 
    {% endif -%}
    {%- if not loop.last -%},{%- endif -%}
    {%- endfor %}
from {{ relation }}
{% endmacro %}
