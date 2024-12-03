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

agg_marketing as (
    select
        f_o.user_id
        , first_name
        , last_name
        , f_o.order_created_at_utc
        , email
        , phone_number
        , address
        , zipcode
        , state
        , country
        , count(distinct oi.order_id) as total_number_orders
        , sum(f_o.order_cost_usd) as total_order_cost_usd
        , sum(f_o.shipping_cost_usd) as total_shipping_cost_usd
        , sum(discount_in_usd) as total_discount_usd
        , sum(product_quantity_sold) as total_quantity_product
        , count(distinct oi.product_id) as total_different_products
        , f_o.date_load_utc
    
    from fct_orders as f_o
    left join fct_orders_items as oi
        on f_o.order_id = oi.order_id
    left join dim_users as d_u
        on f_o.user_id = d_u.user_id
    left join dim_addresses as d_a
        on F_o.address_id = d_a.address_id
    left join dim_promos as dp
        on f_o.promo_id = dp.promo_id

    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 17 
)

select * from agg_marketing
