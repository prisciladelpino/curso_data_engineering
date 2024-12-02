with fct_orders as (
    select *
    from {{ ref('fct_orders') }}
),

dim_addresses as (
    select *
    from {{ ref('dim_addresses') }}
),

dim_states as (
    select *
    from {{ ref('dim_states') }}
),

dim_date as(
    select *
    from {{ ref('dim_date') }}
),


agg_logistics as(
    select
        order_id
        , user_id
        , ds.state
        , ds.state_id 
        , fc.address_id 
        , order_created_at_utc
        , estimated_delivery_at_utc
        , datediff('day', order_created_at_utc, estimated_delivery_at_utc) as stimated_days_between
        , delivered_at_utc   
        , datediff('day', order_created_at_utc, delivered_at_utc) as days_between        --días que pasan desde que se realiza la compra hasta que llega el pedido
        , ABS(stimated_days_between-days_between) as stimated_delivery_accuracy
        , shipping_cost_usd                                  
        , delivery_status
        , tracking_id
        , shipping_service   
        , dd.date_id
        , fc.date_load_utc
        , fc.field_deleted  
    
    from fct_orders as fc
    left join dim_addresses as da
        on fc.address_id = da.address_id
    left join dim_states as ds
        on ds.state = da.state
    left join dim_date as dd
        on dd.date_day = fc.order_created_at_utc::date
    
),

logistics_metrics as (
select
    state_id
    , ROUND(AVG(days_between), 2) as avergare_days_between
    , ROUND(AVG(stimated_days_between), 2) as avergare_days_between
    , ROUND(AVG(stimated_delivery_accuracy),2) as average_stimated_delivery_accuracy
    , MODE(shipping_service) as main_shipping_service
from agg_logistics
group by state_id
)

select * 
from logistics_metrics as lm
full outer join agg_logistics as al
    on al.state_id = lm.state_id
