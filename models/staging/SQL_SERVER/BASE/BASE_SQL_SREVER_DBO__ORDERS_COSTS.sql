WITH src_orders AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ORDERS') }}
    ),

renamed_casted_orders_costs AS (
    SELECT
          ORDER_ID
        , {{ dbt_utils.generate_surrogate_key(['USER_ID']) }} AS USER_ID  --Generamos una clave subrogada utilizando el paquete utilsUSER_ID 
        , CONVERT_TIMEZONE('UTC',CREATED_AT) AS ORDER_CREATED_AT_UTC    
        , ORDER_COST
        , ORDER_TOTAL
        , {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} AS PROMO_ID  --En la tabla PROMOS pusimos una nueva clave primaria  con un hash, por eso la ponemos aquí también   
        , ADDRESS_ID      
        , SHIPPING_COST
        , STATUS AS DELIVERY_STATUS
        , TRACKING_ID
        ,  {{ dbt_utils.generate_surrogate_key(['SHIPPING_SERVICE']) }} AS SHIPPING_SERVICE_ID
        , CONVERT_TIMEZONE('UTC', ESTIMATED_DELIVERY_AT) AS ESTIMATED_DELIVERY_AT_UTC
        , CONVERT_TIMEZONE('UTC', DELIVERED_AT) AS DELIVERED_AT_UTC
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , _FIVETRAN_DELETED AS is_deleted   
    
    FROM src_orders
    )

SELECT * FROM renamed_casted_orders_costs