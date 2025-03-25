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


{% macro fivetran_generate_series(upper_bound) %}
    {{ return(adapter.dispatch('fivetran_generate_series', 'ad_reporting') (upper_bound)) }}
{% endmacro %}

{% macro default__fivetran_generate_series(upper_bound) %}

    {% set n = ad_reporting.fivetran_get_powers_of_two(upper_bound) %}

    with
        p as (
            select 0 as generated_number
            union all
            select 1
        ),
        unioned as (

            select

                {% for i in range(n) %}
                    p{{ i }}.generated_number * power(2, {{ i }})
                    {% if not loop.last %} + {% endif %}
                {% endfor %}
                + 1 as generated_number

            from

            {% for i in range(n) %}
                    p as p{{ i }} {% if not loop.last %} cross join {% endif %}
            {% endfor %}

        )

    select *
    from unioned
    where generated_number <= {{ upper_bound }}
    order by generated_number

{% endmacro %}