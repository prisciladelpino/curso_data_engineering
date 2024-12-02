
{{
  config(
    materialized='incremental'
    , unique_key = 'order_id'
    , on_schema_change='fail'
  )
}}

WITH stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__orders') }}

{% if is_incremental() %}
	  where date_load_utc > (select max(date_load_utc) from {{ this }} )
{% endif %}
    ),

dim_date AS (
    SELECT *
    FROM {{ ref('dim_date') }}
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
        , date_id
        , date_load_utc
        ,field_deleted   
    FROM stg_orders AS a
    LEFT JOIN dim_date AS b
        ON a.order_created_at_utc::date=b.date_day
)

SELECT * 
FROM fct_orders