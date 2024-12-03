with fct_events as (
    select * 
    from {{ ref('fct_events') }}
    ),

dim_users as (
    select *
    from {{ ref('dim_users') }}
),

agg_producto as (
    select distinct
        session_id
	    , ui.user_id
        , first_name
        , email
        , min(f_e.created_at_utc) as first_event_time_utc
        , max(f_e.created_at_utc) as last_event_time_utc
        , sum(case when event_type = 'page_view' then 1 end) as page_view_amount
        , sum(case when event_type = 'add_to_cart' then 1 end) as add_to_cart_amount       
        , sum(case when event_type = 'checkout' then 1 end) as checkout_amount
        , sum(case when event_type = 'package_shipped' then 1 end) as package_shipped_amount

    from fct_events as f_e
    left join dim_users as ui
        on f_e.user_id = ui.user_id
    group by 1, 2, 3, 4 
    order by first_event_time_utc
    )

SELECT * FROM agg_producto