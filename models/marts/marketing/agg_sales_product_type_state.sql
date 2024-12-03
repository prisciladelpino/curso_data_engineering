with fct_orders as (
    select * 
    from {{ ref('fct_orders') }}
    ),

fct_orders_items as(
    select *
    from {{ ref('fct_order_items') }}
),

dim_state as(
    select *
    from {{ ref('dim_states') }}
),

dim_date AS (
    SELECT *
    FROM {{ ref('dim_date') }}
),


agg_sales_analysis as(
    select
        
)