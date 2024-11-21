WITH src_orders AS (
    SELECT * 
    FROM {{ ref('BASE_SQL_SREVER_DBO__ORDERS') }}
    ),

renamed_casted_orders_costs AS (
    SELECT
          ORDER_ID
        , USER_ID  
        , PROMO_ID  --En la tabla PROMOS pusimos una nueva clave primaria  con un hash, por eso la ponemos aquí también   
        , ADDRESS_ID      
        , SHIPMENT_ID
        , TRACKING_ID
        , DATE_LOAD_UTC
        , is_deleted   
    
    FROM src_orders
    )

SELECT * FROM renamed_casted_orders_costs

