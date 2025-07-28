{% macro fivetran_get_powers_of_two(upper_bound) %}
    {{ return(adapter.dispatch('fivetran_get_powers_of_two', 'ad_reporting') (upper_bound)) }}
{% endmacro %}

{% macro default__fivetran_get_powers_of_two(upper_bound) %}

    {% if upper_bound <= 0 %}
        {{ exceptions.raise_compiler_error("upper bound must be positive") }}
    {% endif %}

    {% for _ in range(1, 100) %}
        {% if upper_bound <= 2**loop.index %} {{ return(loop.index) }}{% endif %}
    {% endfor %}

{% endmacro %}


