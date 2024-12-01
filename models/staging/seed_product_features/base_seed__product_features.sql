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
        , location
        , light_requirements
        , size
        , water_needs
    FROM base_product_features
)

select * from renamed_casted_product_features