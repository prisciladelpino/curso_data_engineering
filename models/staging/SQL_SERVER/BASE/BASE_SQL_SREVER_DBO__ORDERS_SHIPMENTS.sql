WITH src_orders AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ORDERS') }}
    ),

base_renamed_casted_orders_shippments AS (
    SELECT
          ORDER_ID
        , {{ dbt_utils.generate_surrogate_key(['USER_ID']) }} AS USER_ID --Generamos una clave subrogada utilizando el paquete utilsUSER_ID
        , ADDRESS_ID        
        , CONVERT_TIMEZONE('UTC',CREATED_AT) AS CREATED_AT_UTC
        , STATUS AS DELIVERY_STATUS
        , TRACKING_ID
        ,  {{ dbt_utils.generate_surrogate_key(['SHIPPING_SERVICE']) }} AS SHIPPING_SERVICE_ID
        , CONVERT_TIMEZONE('UTC', ESTIMATED_DELIVERY_AT) AS ESTIMATED_DELIVERY_AT_UTC
        , CONVERT_TIMEZONE('UTC', DELIVERED_AT) AS DELIVERED_AT_UTC
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_orders
    )

SELECT * FROM base_renamed_casted_orders_shippments