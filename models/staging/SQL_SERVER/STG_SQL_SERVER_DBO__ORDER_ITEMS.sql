WITH src_order_items AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ORDER_ITEMS') }}
    ),

renamed_casted_order_items AS (
    SELECT
          PRODUCT_ID
        , ORDER_ID
        , QUANTITY
        , _fivetran_synced AS date_load
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_addresses
    )

SELECT * FROM renamed_casted_order_items
