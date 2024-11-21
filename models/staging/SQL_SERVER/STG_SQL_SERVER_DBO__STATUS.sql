WITH src_orders AS (
    SELECT * 
    FROM {{ ref('BASE_SQL_SREVER_DBO__ORDERS') }}
    ),

renamed_casted_orders_costs AS (
    SELECT DISTINCT
        DELIVERY_STATUS
        , DELIVERY_STATUS_ID

  
    FROM src_orders
    )

SELECT * FROM renamed_casted_orders_costs