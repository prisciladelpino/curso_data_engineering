WITH src_products AS (
    SELECT * 
    FROM {{ ref('src_products_snap') }}
    ),

base_renamed_casted_products AS (
    
    SELECT
        
          product_id
        , name::varchar(50) AS product_name
        , price::DECIMAL(10,2) AS price_usd
        , inventory::NUMBER(5,0) AS stock
        , convert_timezone('UTC', _fivetran_synced) AS date_load_utc
        
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted  
    
    FROM src_products
    )

SELECT * FROM base_renamed_casted_products

