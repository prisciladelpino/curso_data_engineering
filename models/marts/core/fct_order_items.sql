
{{
  config(
    materialized='incremental'
    , unique_key = 'order_item_id'    
    , on_schema_change='fail'
  )
}}

with int_orders as(
    select *
    from {{ ref('int_orders_joint_order_items') }}
),

stg_orders as(
    select * 
    from {{ ref('stg_sql_server_dbo__orders') }}
),

dim_date AS (
    SELECT *
    FROM {{ ref('dim_date') }}
),

fct_orders_items as (
    select
        order_item_id
        , s_o.order_id
        , s_o.user_id    
        , s_o.address_id
        , product_id
        , product_quantity_sold
        , product_price_usd
        , (product_price_usd * product_quantity_sold) as gross_line_sale
        , discount_per_item_usd
        , (discount_per_item_usd * product_quantity_sold) as total_line_discount
        , unit_cost
        , (unit_cost * product_quantity_sold) as line_product_cost_usd
        , (gross_line_sale - total_line_discount - line_product_cost_usd) as net_profit
        , s_o.promo_id
        , s_o.order_created_at_utc                                  
        , s_o.delivered_at_utc
        , io.date_load_utc


    from stg_orders as s_o
    left join int_orders as io
        on s_o.order_id = io.order_id
    left join dim_date as dd
        on s_o.order_created_at_utc::date = dd.date_day 

)

select *
from fct_orders_items
{% if is_incremental() %}
	  where date_load_utc > (select max(date_load_utc) from {{ this }} )
{% endif %}