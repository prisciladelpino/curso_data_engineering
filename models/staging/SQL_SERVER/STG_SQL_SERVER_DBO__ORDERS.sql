WITH base_orders_costs AS (
    SELECT * 
    FROM {{ ref('BASE_SQL_SREVER_DBO__ORDERS') }}
    ),


renamed_casted_orders AS (
    SELECT
          A.ORDER_ID
        , A.USER_ID 
        , A.CREATED_AT_UTC
        , ORDER_COST
        , ORDER_TOTAL
        , PROMO_ID     
        , ADDRESS_ID
        , TRACKING_ID
        , SHIPPING_SERVICE_ID
        , SHIPPING_COST
        , ESTIMATED_DELIVERY_AT_UTC
        , DELIVERY_STATUS
        , DELIVERED_AT_UTC
        , A.DATE_LOAD_UTC
        , A.is_deleted
    FROM base_orders_costs 
    )

SELECT * FROM renamed_casted_orders

