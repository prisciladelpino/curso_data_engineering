{{
  config(
    materialized='view'
  )
}}

WITH base_product_features AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'product_unit_costs') }}
),

renamed_casted_unit_cost AS(
    SELECT
        product_name
        , unit_cost
    FROM base_product_features
)

SELECT *
FROM renamed_casted_unit_cost