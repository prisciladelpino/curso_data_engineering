with stg_promos as (
    select * 
    from {{ ref('stg_sql_server_dbo__promos') }}
),

dim_promos as(
    select
        promo_id       
        , promo_desc                           
        , discount_in_usd                              
        , promo_status
        , date_load_utc
        , field_deleted     
    from stg_promos    
)

select * from dim_promos