{{ config(materialized='table') }}

with unioned as (

    {{ dbt_utils.union_relations(get_staging_files(),
                                column_override = {"account_id": "string"} if target.type in ['bigquery', 'spark'] else {"account_id": "varchar"} ) }}

)

select *
from unioned