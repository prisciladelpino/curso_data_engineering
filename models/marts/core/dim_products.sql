WITH stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
    ),

dim_products AS(

    SELECT
        product_id
        , product_name
        , unit_cost
        , price_usd
        , stock
        , placement
        , light_requirements
        , size
        , water_needs     
        , date_load_utc
        , field_deleted
    FROM stg_products
)

SELECT * 
FROM dim_products