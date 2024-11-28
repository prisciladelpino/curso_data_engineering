
WITH src_orders AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ORDERS') }}
    ),

renamed_casted_orders_costs AS (
    SELECT
          ORDER_ID
        , {{ dbt_utils.generate_surrogate_key(['USER_ID']) }} AS USER_ID  --Generamos una clave subrogada utilizando el paquete utilsUSER_ID 
        , CONVERT_TIMEZONE('UTC',CREATED_AT) AS ORDER_CREATED_AT_UTC    
        , ORDER_COST::decimal(10,2) AS ORDER_COST_DOLLAR
        , ORDER_TOTAL::decimal(10,2) AS ORDER_TOTAL_DOLLAR
        , {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} AS PROMO_ID  --En la tabla PROMOS pusimos una nueva clave primaria  con un hash, por eso la ponemos aquí también   
        , ADDRESS_ID      
        , SHIPPING_COST::decimal(10,2) AS SHIPPING_COST_DOLLAR
        , STATUS AS DELIVERY_STATUS
        , CASE 
            WHEN TRACKING_ID = ''
            THEN 'NOT_ASSIGNED'
            ELSE TRACKING_ID
        END AS TRACKING_ID
        , SHIPPING_SERVICE   --Necesito tener la descripción de shipping service aqui para luego poder sacarla
        , CONVERT_TIMEZONE('UTC', ESTIMATED_DELIVERY_AT) AS ESTIMATED_DELIVERY_AT_UTC
        , CONVERT_TIMEZONE('UTC', DELIVERED_AT) AS DELIVERED_AT_UTC
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , CASE 
            WHEN _FIVETRAN_DELETED IS NULL THEN FALSE 
            ELSE TRUE 
        END AS FIELD_DELETED  
    
    FROM src_orders
    )

SELECT * FROM renamed_casted_orders_costs