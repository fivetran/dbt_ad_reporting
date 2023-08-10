{{ config(enabled=var('ad_reporting__metricflow_time_spine_enabled', True)) }}
with 

days as (
    {{ dbt_date.get_base_dates(n_dateparts=365*10, datepart="day") }}

),

cast_to_date as (

    select 
        cast(date_day as date) as date_day
    
    from days

)

select * from cast_to_date
