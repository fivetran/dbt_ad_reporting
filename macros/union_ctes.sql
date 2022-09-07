{% macro union_ctes(ctes=[]) %}

{% for cte in ctes %}
select * from {{ cte }}

{% if not loop.last -%}
    union all
{% endif -%}

{% endfor %}

{% endmacro %}