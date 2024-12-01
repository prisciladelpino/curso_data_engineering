
WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),


renamed_casted_orders_costs AS (
    
    SELECT
        
          order_id
        , {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id  --Generamos una clave subrogada utilizando el paquete utilsUSER_ID 
        , CONVERT_TIMEZONE('UTC',created_at) AS order_created_at_utc    
        , order_cost::decimal(10,2) AS order_cost_usd
        , order_total::decimal(10,2) AS order_total_cost_usd
        , {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} AS promo_id  --En la tabla PROMOS pusimos una nueva clave primaria  con un hash, por eso la ponemos aquí también   
        , address_id      
        , shipping_cost::decimal(10,2) AS shipping_cost_usd
        , status AS delivery_status
        
        , CASE 
            WHEN tracking_id = ''
            THEN 'not_assigned'
            ELSE tracking_id
        END AS tracking_id
       
        , shipping_service::varchar(50) AS shipping_service   --Necesito tener la descripción de shipping service aqui para luego poder sacarla
        , CONVERT_TIMEZONE('UTC', estimated_delivery_at) AS estimated_delivery_at_utc
        , CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at_utc
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
       
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted  
    
    FROM src_orders
    )


SELECT * FROM renamed_casted_orders_costs
