WITH src_products AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'PRODUCTS') }}
    ),

renamed_casted_products AS (
    SELECT
          PRODUCT_ID
        , NAME AS PRODUCT_NAME
        , PRICE::DECIMAL(10,2) AS PRICE_DOLLAR
        , INVENTORY::NUMBER(5,0) AS STOCK
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , CASE 
            WHEN _FIVETRAN_DELETED IS NULL THEN FALSE 
            ELSE TRUE 
        END AS FIELD_DELETED  
    FROM src_products
    )

SELECT * FROM renamed_casted_products
