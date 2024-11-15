WITH src_orders AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ORDERS') }}
    ),

renamed_casted_orders AS (
    SELECT
          ORDER_ID
        , USER_ID
        , CREATED_AT
        , ORDER_COST
        , ORDER_TOTAL
        , PROMO_ID
        , ADDRESS_ID
        , TRACKING_ID
        , SHIPPING_SERVICE
        , SHIPPING_COST
        , ESTIMATED_DELIVERY_AT
        , STATUS AS DELIVERY_STATUS
        , DELIVERED_AT
        , _FIVETRAN_SYNCED AS date_load
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_addresses
    )

SELECT * FROM renamed_casted_orders

