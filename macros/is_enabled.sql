{% macro is_enabled(enabled_packages) %}

{% if enabled_packages != [] %}
    {% set is_enabled = True %}
{% else %}
    {% set is_enabled = False %}
{% endif %}
{{ return(is_enabled) }}

{% endmacro %}