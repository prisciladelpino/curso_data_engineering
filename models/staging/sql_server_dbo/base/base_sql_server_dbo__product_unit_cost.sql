
WITH base_product_features AS (
    SELECT *
    FROM {{ ref('src_product_unit_costs_snap') }}
    WHERE dbt_valid_to is null
),

renamed_casted_unit_cost AS(
    SELECT
        product_name::varchar(50) AS product_name
        , unit_cost::NUMBER(5,2) AS unit_cost
    FROM base_product_features
)

SELECT *
FROM renamed_casted_unit_cost