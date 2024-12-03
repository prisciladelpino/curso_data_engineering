--Este modelo intermedio se emplea para agregar las métricas de negocio a nivel mensual para facilitar su comparación con budget



with stg_order_items as (
    select * from {{ ref('stg_sql_server_dbo__order_items') }}
),

stg_orders as (
    select * from {{ ref('stg_sql_server_dbo__orders') }}
),

stg_products as (
    select * from {{ ref('stg_sql_server_dbo_products') }}
),

stg_budget as(
    select * from {{ ref('stg_google_sheets__budget') }}
),

stg_promos as(
    select * from {{ ref('stg_sql_server_dbo__promos') }}
),

grouped_by_month as(
    select
       YEAR(order_created_at_utc) as year
       , MONTH(order_created_at_utc) as month
       , b.product_id
       , product_name 
       , sum(product_quantity_sold) as monthly_quantity_sold          -- quantity_sold_per_product_and_month
       , sum(product_quantity_sold * price_usd) as monthly_incomes    -- La suma del precio de venta de cada producto por la cantidad vendida
       , sum(product_quantity_sold * unit_cost) as monthly_expenses   -- Suma del coste unitario (para la empresa) de cada producto por la cantidad vendida ese mes
       , sum(discount_in_usd) as monthly_total_discounts              -- Suma del descuento total por producto y por mes

    from stg_order_items as a
    left join stg_products as b
        on a.product_id = b.product_id
    left join stg_orders as c
        on a.order_id = c.order_id
    left join stg_budget as d
        on a.product_id = d.product_id
    left join stg_promos as e
        on c.promo_id = e.promo_id

    group by b.product_id, product_name, month, year
)

select * from grouped_by_month


