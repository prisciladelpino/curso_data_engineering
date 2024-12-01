WITH stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__products') }}
    ),

dim_products AS(
    SELECT
        product_id
        , name
        , price_dollar
        , stock
        , date_load_utc
        , field_deleted
    
    FROM stg_products          
)

SELECT *
FROM dim_products