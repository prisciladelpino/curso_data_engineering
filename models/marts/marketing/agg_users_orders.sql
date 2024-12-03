
{{
  config(
    materialized='incremental'
    , unique_key = 'user_id'
    , on_schema_change='fail'
  )
}}

with fct_orders as (
    select * 
    from {{ ref('fct_orders') }}
    ),

fct_orders_items as(
    select *
    from {{ ref('fct_order_items') }}
),

dim_users as (
    select *
    from {{ ref('dim_users') }}
),

dim_addresses as(
    select *
    from {{ ref('dim_addresses') }}
),

dim_promos as(
    select *
    from {{ ref('dim_promos') }}
),

dim_date AS (
    SELECT *
    FROM {{ ref('dim_date') }}
),

dim_state as(
    select *
    from {{ ref('dim_states') }}
),

--Creamos una tabla con todas las métricas que nos interesan agrupadas por cliente
    --Así, para cada dicliente conocemos los pedidos que ha hecho, su coste, etc

agg_metrics as (
    select
        
         f_o.user_id
        , count(distinct oi.order_id) as total_number_orders
        , sum(f_o.order_cost_usd) as total_order_cost_usd
        , sum(f_o.shipping_cost_usd) as total_shipping_cost_usd
        , sum(discount_in_usd) as total_discount_usd
        , sum(product_quantity_sold) as total_quantity_product
        , count(distinct oi.product_id) as total_different_products
      
    from fct_orders as f_o
    left join fct_orders_items as oi
        on f_o.order_id = oi.order_id
    left join dim_users as d_u
        on f_o.user_id = d_u.user_id  
    left join dim_addresses as d_a
        on f_o.address_id = d_a.address_id
    left join dim_promos as dp
        on f_o.promo_id = dp.promo_id
  
        
    group by 1      
),

--Añadimos a la tabla anterior más información sobre los clientes
    --No la añadimos antes porque queríamos hacer agrupaciones y las perderíamos

agg_marketing as (
    select distinct
        am.user_id
        , first_name
        , last_name
        , email
        , phone_number
        , address
        , zipcode
        , state
        , country  
        , total_number_orders
        , total_order_cost_usd
        , total_shipping_cost_usd
        , total_discount_usd
        , total_quantity_product
        , total_different_products
        , d_u.date_load_utc 

    from agg_metrics as am
    left join dim_users as d_u
        on am.user_id = d_u.user_id
    left join dim_addresses as d_a
        on d_u.address_id = d_a.address_id

)

select * from agg_marketing
{% if is_incremental() %}
	  where date_load_utc > (select max(date_load_utc) from {{ this }} )
{% endif %}