{{ config(materialized='table') }}

with unioned as (

    {{ dbt_utils.union_relations(get_staging_files(), 
                                column_override = {"account_id": "int64"} if target.type == 'bigquery' else {"account_id": "bigint"} ) }}

)

select *
from unioned