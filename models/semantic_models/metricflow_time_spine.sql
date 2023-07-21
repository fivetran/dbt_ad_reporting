
--tmp table required by Metricflow for cumulative metrics. We are planning to create this table behind the scenes in core, but for now users will have to create it manually.
{{ config(materialized='table')}}

with days as (
{{ dbt_date.get_base_dates(n_dateparts=365*10, datepart="day") }}
),

final as (
    select cast(date_day as date) as date_day
    from days
)

select *
from final