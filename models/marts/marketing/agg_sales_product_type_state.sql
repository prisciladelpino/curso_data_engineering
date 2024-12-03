
{{
  config(
    materialized='incremental'
    , unique_key = 'order_item_id'    
    , on_schema_change='fail'
  )
}}

with fct_orders_items as(
    select *
    from {{ ref('fct_order_items') }}
),

dim_addresses as(
    select *
    from {{ ref('dim_addresses') }}
),

dim_state as(
    select *
    from {{ ref('dim_states') }}
),

dim_date AS (
    SELECT *
    FROM {{ ref('dim_date') }}
),

dim_products AS (
    SELECT *
    FROM {{ ref('dim_products') }}
),

agg_sales_analysis as(
    select
       order_item_id
       , order_id
       , user_id
       , product_name
       , ds.state
       , product_quantity_sold
       , product_price_usd
       , gross_line_sale
       , discount_per_item_usd
       , total_line_discount
       , oi.unit_cost
       , line_product_cost_usd
       , net_profit
       , order_created_at_utc                                  
       , placement
       , light_requirements
       , size
       , water_needs
       , DATE_DAY                  
       , year  
       , month_number  
       , month_name  
       , day_of_month             
       , weekday_name  
       , quarter       
       , day_type  
       , oi.date_load_utc

    from fct_orders_items as oi
    left join dim_addresses as d_a
        on oi.address_id = d_a.address_id
    left join dim_state as ds
        on d_a.state = ds.state
    left join dim_date as dd
        on oi.order_created_at_utc::date = dd.date_day
    left join dim_products as dp
        on oi.product_id = dp.product_id
)


select *
from agg_sales_analysis
{% if is_incremental() %}
	  where date_load_utc > (select max(date_load_utc) from {{ this }} )
{% endif %}