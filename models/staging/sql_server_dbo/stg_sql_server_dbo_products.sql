WITH base_renamed_casted_products AS (
     SELECT *
     FROM {{ ref('base_sql_server_dbo__products') }}
),

renamed_casted_product_features AS(
    SELECT *
    FROM {{ ref('base_seed__product_features') }}
),

renamed_casted_unit_cost AS(
    SELECT *
    FROM {{ ref('base_sql_server_dbo__product_unit_cost') }}    
),

stg_products_completed AS(
    SELECT
        a.product_id
        , a.product_name
        , c.unit_cost
        , a.price_usd
        , a.stock
        , b.placement
        , b.light_requirements
        , b.size
        , b.water_needs     
        , a.date_load_utc
        , a.field_deleted
    FROM base_renamed_casted_products a
    LEFT JOIN renamed_casted_product_features b
        ON a.product_name=b.product_name
    LEFT JOIN renamed_casted_unit_cost c
        ON a.product_name=c.product_name

)

SELECT *
FROM stg_products_completed