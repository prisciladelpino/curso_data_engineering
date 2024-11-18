WITH src_products AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'PRODUCTS') }}
    ),

renamed_casted_products AS (
    SELECT
          PRODUCT_ID
        , NAME
        , PRICE AS PRICE_USD
        , INVENTORY
        , ZIPCODE
        , _fivetran_synced AS date_load
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_addresses
    )

SELECT * FROM renamed_casted_products
