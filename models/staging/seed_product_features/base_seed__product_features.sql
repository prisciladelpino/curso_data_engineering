{{
  config(
    materialized='view'
  )
}}

WITH base_product_features AS (
    SELECT *
    FROM {{ ref('product_features') }}
),

renamed_casted_product_features AS(
    SELECT
        product_name
        , location::varchar(50)
        , light_requirements::varchar(50)
        , size::varchar(50)
        , water_needs::varchar(50)
)

select * from renamed_casted_product_features