{% macro get_query(platform=None, report_type=None, field_mapping=None, relation=None) %}

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

{#- For account level reports and lower, add account_fields -#}
{%- if report_type in ['campaign', 'ad_group', 'ad', 'url', 'keyword', 'search', 'account'] -%}
    {%- for account_field in account_fields -%}
        {#- When campaign_passthrough_metrics are defined, add them too but only to the ad_group report_type -#}
        {%- if report_type == 'account' and var('ad_reporting__account_passthrough_metrics', []) -%}
            {% set account_passthrough_metric_array_of_dicts = var('ad_reporting__account_passthrough_metrics') %}
                {%- for account_passthrough_metric_dict in account_passthrough_metric_array_of_dicts -%}
                    {%- for account_passthrough_metric_value in account_passthrough_metric_dict.values() -%}
                        {%- do final_fields_superset.update({account_passthrough_metric_value: account_passthrough_metric_value}) -%}
                    {%- endfor -%}
                {%- endfor -%}
        {%- endif -%}
        {%- do final_fields_superset.update({account_field: account_field}) -%}
    {%- endfor -%}
{%- endif -%}

{#- For campaign level reports and lower, add campaign_fields -#}
{%- if report_type in ['campaign', 'ad_group', 'ad', 'url', 'keyword', 'search'] -%}
    {%- for campaign_field in campaign_fields -%}
        {#- When campaign_passthrough_metrics are defined, add them too but only to the ad_group report_type -#}
        {%- if report_type == 'campaign' and var('ad_reporting__campaign_passthrough_metrics', []) -%}
            {% set campaign_passthrough_metric_array_of_dicts = var('ad_reporting__campaign_passthrough_metrics') %}
                {%- for campaign_passthrough_metric_dict in campaign_passthrough_metric_array_of_dicts -%}
                    {%- for campaign_passthrough_metric_value in campaign_passthrough_metric_dict.values() -%}
                        {%- do final_fields_superset.update({campaign_passthrough_metric_value: campaign_passthrough_metric_value}) -%}
                    {%- endfor -%}
                {%- endfor -%}
        {%- endif -%}
        {%- do final_fields_superset.update({campaign_field: campaign_field}) -%}
    {%- endfor -%}
{%- endif -%}

{#- For ad_group level reports, equivalent and lower, add ad_group_fields -#}
{%- if report_type in ['ad_group', 'ad', 'url', 'keyword', 'search'] -%}
    {%- for ad_group_field in ad_group_fields -%}
        {#- When ad_group_passthrough_metrics are defined, add them too but only to the ad_group report_type -#}
        {%- if report_type == 'ad_group' and var('ad_reporting__ad_group_passthrough_metrics', []) -%}
            {% set ad_group_passthrough_metric_array_of_dicts = var('ad_reporting__ad_group_passthrough_metrics') %}
                {%- for ad_group_passthrough_metric_dict in ad_group_passthrough_metric_array_of_dicts -%}
                    {%- for ad_group_passthrough_metric_value in ad_group_passthrough_metric_dict.values() -%}
                        {%- do final_fields_superset.update({ad_group_passthrough_metric_value: ad_group_passthrough_metric_value}) -%}
                    {%- endfor -%}
                {%- endfor -%}
        {%- endif -%}
        {%- do final_fields_superset.update({ad_group_field: ad_group_field}) -%}
    {%- endfor -%}
{%- endif -%}

{#- For ad reports, add ad_fields and ad_passthrough_metrics (if any) -#}
{%- if report_type == 'ad' -%}
    {%- if var('ad_reporting__ad_passthrough_metrics', []) -%}
        {%- set ad_passthrough_metrics_values = [] -%}
        {%- set ad_passthrough_metrics_array_of_dicts = var('ad_reporting__ad_passthrough_metrics') -%}
            {%- for ad_passthrough_metrics_dict in ad_passthrough_metrics_array_of_dicts -%}
                {%- for _, value in ad_passthrough_metrics_dict.items() -%}
                    {%- do ad_passthrough_metrics_values.append(value) -%}
                {%- endfor -%}
            {%- endfor -%}
        {%- set combined_ad_fields = ad_fields + ad_passthrough_metrics_values -%}
    {%- else -%}
        {%- set combined_ad_fields = ad_fields -%}
    {%- endif -%}
    {%- for ad_field in combined_ad_fields -%}
        {%- do final_fields_superset.update({ad_field: ad_field})-%}
    {%- endfor -%}
{%- endif -%}

{#- For url level reports, add ad_fields and ad_passthrough_metrics (if any) -#}
{%- if report_type == 'url' -%}
    {%- if var('ad_reporting__ad_passthrough_metrics', []) -%}
        {%- set ad_passthrough_metrics_values = [] -%}
        {%- set ad_passthrough_metrics_array_of_dicts = var('ad_reporting__ad_passthrough_metrics') -%}
            {%- for ad_passthrough_metrics_dict in ad_passthrough_metrics_array_of_dicts -%}
                {%- for _, value in ad_passthrough_metrics_dict.items() -%}
                    {%- do ad_passthrough_metrics_values.append(value) -%}
                {%- endfor -%}
            {%- endfor -%}
        {%- set combined_ad_fields = url_fields + ad_passthrough_metrics_values -%}
    {%- else -%}
        {%- set combined_ad_fields = url_fields -%}
    {%- endif -%}
    {%- for ad_field in combined_ad_fields -%}
        {%- do final_fields_superset.update({ad_field: ad_field})-%}
    {%- endfor -%}
{%- endif -%}

{#- For keyword level reports, add keyword_fields and keyword_passthrough_metrics (if any) -#}
{%- if report_type == 'keyword' -%}
    {%- if var('ad_reporting__keyword_passthrough_metrics', []) -%}
        {%- set keyword_passthrough_metrics_values = [] -%}
        {%- set keyword_passthrough_metrics_array_of_dicts = var('ad_reporting__keyword_passthrough_metrics') -%}
            {%- for keyword_passthrough_metrics_dict in keyword_passthrough_metrics_array_of_dicts -%}
                {%- for _, value in keyword_passthrough_metrics_dict.items() -%}
                    {%- do keyword_passthrough_metrics_values.append(value) -%}
                {%- endfor -%}
            {%- endfor -%}
        {%- set combined_keyword_fields = keyword_fields + keyword_passthrough_metrics_values -%}
    {%- else -%}
        {%- set combined_keyword_fields = keyword_fields -%}
    {%- endif -%}
    {%- for keyword_field in combined_keyword_fields -%}
        {%- do final_fields_superset.update({keyword_field: keyword_field})-%}
    {%- endfor -%}
{%- endif -%}

{#- For search level reports, add search_fields and search_passthrough_metrics (if any) -#}
{%- if report_type == 'search' -%}
    {%- if var('ad_reporting__search_passthrough_metrics',[]) -%}
        {%- set search_passthrough_metrics_values = [] -%}
        {%- set search_passthrough_metrics_array_of_dicts = var('ad_reporting__search_passthrough_metrics') -%}
            {%- for search_passthrough_metrics_dict in search_passthrough_metrics_array_of_dicts -%}
                {%- for _, value in search_passthrough_metrics_dict.items() -%}
                    {%- do search_passthrough_metrics_values.append(value) -%}
                {%- endfor -%}
            {%- endfor -%}
        {%- set combined_search_fields = search_fields + search_passthrough_metrics_values -%}
    {%- else -%}
        {%- set combined_search_fields = search_fields -%}
    {%- endif -%}
    {%- for search_field in combined_search_fields -%}
        {%- do final_fields_superset.update({search_field: search_field})-%}
    {%- endfor -%}
{%- endif -%}

{%- if field_mapping is not none -%}
    {%- for field in fields -%}
        {%- do final_fields_superset.update({field:field_mapping[field]}) -%}
    {%- endfor -%}
{%- endif -%}

select 
    source_relation,
    {{ get_date_from_timestamp('date_day') }} as date_day,
    cast( '{{ platform }}' as {{ dbt.type_string() }}) as platform,

    {% for field in final_fields_superset.keys()|sort() -%}
    {% if field in consistent_fields and field != 'spend' -%}
    cast({{ final_fields_superset[field] }} as {{ dbt.type_int() }}) as {{ field }}

    {% elif field == 'spend' -%}
    cast({{ final_fields_superset[field] }} as {{ dbt.type_float() }}) as {{ field }}

    {% elif '_id' in field or '_name' in field or 'url' in field or 'utm' in field or field in ['keyword_match_type', 'keyword_text', 'search_match_type', 'search_query'] -%}
    cast({{ final_fields_superset[field] }} as {{ dbt.type_string() }}) as {{ field }}

    {# This is the case for the rest of fields (passthrough_metrics) #}
    {% else %}
    cast({{ final_fields_superset[field] }} as {{ dbt.type_float() }}) as {{ field }}
    {% endif -%}
    {%- if not loop.last -%},{%- endif -%}
    {%- endfor %}
from {{ relation }}
{% endmacro %}