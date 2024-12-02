WITH stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__orders') }}
    ),

fct_orders AS(

    SELECT
         order_id
        , user_id  
        , order_created_at_utc 
        , promo_id   
        , order_cost_usd
        , shipping_cost_usd
        , order_total_cost_usd                                       
        , address_id      
        , delivery_status
        , tracking_id
        , shipping_service   
        , estimated_delivery_at_utc
        , delivered_at_utc
        , date_load_utc
        ,field_deleted   
    FROM stg_orders
)

SELECT * 
FROM fct_orders