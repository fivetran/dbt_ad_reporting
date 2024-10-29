{# Adapted from fivetran_utils.persist_pass_through_columns() macro to alias duplicate fields #}

{% macro ad_reporting_persist_pass_through_columns(pass_through_variable, identifier=none, transform='', coalesce_with=none, alias_fields=[]) %}

{% if var(pass_through_variable, none) %}
    {% for field in var(pass_through_variable) %}
        {% set field_name = field.alias|default(field.name)|lower if field is mapping else field %}
        , {{ transform ~ '(' ~ ('coalesce(' if coalesce_with is not none else '') ~ (identifier ~ '.' if identifier else '') ~ field_name ~ ('_c' if field_name in alias_fields else '') ~ ((', ' ~ coalesce_with ~ ')') if coalesce_with is not none else '') ~ ')' }} 
            as {{ field_name ~ ('_c' if field_name in alias_fields else '') }}
    {% endfor %}
{% endif %}

{% endmacro %}