with int_orders as(
    select *
    from {{ ref('int_orders_per_month') }}
),

fct_budget as (
    select *
    from {{ ref('fct_budget') }}
),

comparison_mart as(
    select
        year
        , month
        , a.product_id
        , product_name
        , target_quantity
        , monthly_quantity_sold
        , case when monthly_quantity_sold >= target_quantity then 1
             else 0 end as target_acomplish
        ,(round(monthly_quantity_sold / target_quantity ,0 ) *100 ) as target_sells_diff_percentage
        , monthly_incomes
        , monthly_expenses
        , date_load_utc
    from fct_budget as a
    left join int_orders as b
        on a.product_id = b.product_id
)

select * from comparison_mart