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
        product_name::varchar(50)
        , location::varchar(50)
        , light_requirements::varchar(50)
        , size::varchar(50)
        , water_needs::varchar(50)
    FROM base_product_features
)

select * from renamed_casted_product_features