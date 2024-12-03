
{{
  config(
    materialized='incremental'
    , unique_key = 'event_id'
    , on_schema_change='fail'
  )
}}


WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    
{% if is_incremental() %}

	  where _fivetran_synced > (select max(date_load_utc) from {{ this }} )

{% endif %}
    ),

renamed_casted_events AS (
    SELECT
          event_id
        , session_id
        , event_type::varchar(50) AS event_type
        , page_url::varchar(100) AS page_url
        , {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id
        , product_id
        , CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc
        , order_id
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted  
    FROM src_events
    )

SELECT * FROM renamed_casted_events

