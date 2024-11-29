WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted_products AS (
    
    SELECT
        
          product_id
        , name AS product_name
        , price::DECIMAL(10,2) AS price_dollar
        , inventory::NUMBER(5,0) AS stock
        , convert_timezone('UTC', _fivetran_synced) AS date_load_utc
        
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted  
    
    FROM src_products
    )

SELECT * FROM renamed_casted_products

