WITH src_order_items AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ORDER_ITEMS') }}
    ),

renamed_casted_order_items AS (
    SELECT
          PRODUCT_ID
        , ORDER_ID
        , QUANTITY
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_order_items
    )

SELECT * FROM renamed_casted_order_items
