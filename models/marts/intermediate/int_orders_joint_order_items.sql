--Creamos un modelo intermedio para unir con la correcta granularidad order y order items
--Esto es util para tener en una sola tabla toda la información relativa a métricas de negocio de cada pedido
--y así poder utilizarla en tablas/análisis posteiores

{{ config(
    materialized='incremental',
    unique_key = ['order_id','product_id'],
    on_schema_change='fail',
)
    }}

with stg_order_items as (
    select * from {{ ref('stg_sql_server_dbo__order_items') }}
    
    {% if is_incremental() %}
        where _fivetran_synced > (select max(date_load_utc) from {{ this }} )
    {% endif %}
),

stg_orders as (
    select * from {{ ref('stg_sql_server_dbo__orders') }}
    
),

stg_products as (
    select * from {{ ref('stg_sql_server_dbo_products') }}
),

stg_promos as (
    select * from {{ ref('stg_sql_server_dbo__promos') }}
),


--Unimos en una tabla los campos con la misma granularidad

orders_and_order_items as (
    select

        a.order_id
        , b.user_id
        , b.address_id
        , c.product_id
        , a.product_quantity_sold
        , c.price_usd as product_price_usd
        , c.unit_cost
        , b.promo_id
        , d.discount_in_usd
        , b.order_created_at_utc                                  
        , b.delivered_at_utc
        , a.date_load_utc as order_items_load_utc
        , b.date_load_utc as orders_load_utc


--Ahora vamos a añadir a la tabla anterior algunas metricas interesantes para facilitar el análisis de ventas
--Para conocer los beneficios reales de mi empresa nesetito tener en algún sitio los ingresos por producto aplicando el descuento que le corresponda a cada producto
   
        , (product_price_usd / (order_total_cost_usd - shipping_cost_usd) * 100)::decimal(7,2) as percentage_of_order_cost
        , CASE
            WHEN discount_in_usd = 0 THEN 0
            ELSE ((product_price_usd / (order_total_cost_usd - shipping_cost_usd)) * discount_in_usd)::decimal(7,2) 
         END AS discount_per_item_usd


--Hacemos todos los join necesarios
    from stg_order_items as a
    left join stg_orders as b 
        on a.order_id = b.order_id
    left join stg_products as c
        on a.product_id = c.product_id
    left join stg_promos as d
        on b.promo_id = d.promo_id
    order by b.order_created_at_utc, a.order_id
)


Select * from orders_and_order_items