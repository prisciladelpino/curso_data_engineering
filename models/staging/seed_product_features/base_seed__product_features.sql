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
        product_name::varchar(50) AS product_name
        , location::varchar(50) AS placement
        , light_requirements::varchar(50) AS light_requirements
        , size::varchar(50) AS size
        , water_needs::varchar(50) AS water_needs
    FROM base_product_features
)

select * from renamed_casted_product_features