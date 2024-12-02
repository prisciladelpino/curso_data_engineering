with fct_orders as (
    select *
    from {{ ref('fct_orders') }}
),

dim_states as (
    select *
    from {{ ref('dim_states') }}
),

