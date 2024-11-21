WITH src_orders AS (
    SELECT * 
    FROM {{ ref('BASE_SQL_SREVER_DBO__ORDERS') }}
    ),

renamed_casted_orders_costs AS (
    SELECT
          ORDER_ID
        , ORDER_CREATED_AT_UTC    
        , ORDER_COST
        , ORDER_TOTAL  
        , DELIVERY_STATUS_ID
        , ESTIMATED_DELIVERY_AT_UTC
        , DELIVERED_AT_UTC
        , DATE_LOAD_UTC
        , is_deleted   
    
    FROM src_orders
    )

SELECT * FROM renamed_casted_orders_costs

