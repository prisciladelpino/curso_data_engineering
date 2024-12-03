{{
  config(
    materialized='incremental'
    , unique_key = 'event_id'
    , on_schema_change='fail'
  )
}}

WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__events') }}
    
{% if is_incremental() %}
	  where _fivetran_synced > (select max(date_load_utc) from {{ this }} )
{% endif %}
    ),

dim_date as(
    select *
    from {{ ref('dim_date') }}
),

fct_events as(
    select
        event_id
        , session_id
        , event_type
        , page_url
        , user_id
        , product_id
        , created_at_utc
        , order_id
        , date_load_utc
        , field_deleted  
    from stg_events as se
    left join dim_date as dd
        on se.created_at_utc::date = dd.date_day
)

select * from fct_events