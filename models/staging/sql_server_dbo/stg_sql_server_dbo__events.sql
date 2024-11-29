WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted_events AS (
    SELECT
          event_id
        , session_id
        , event_type
        , page_url
        , {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id
        , product_id
        , CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc
        , ORDER_ID
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted  
    FROM src_events
    )

SELECT * FROM renamed_casted_events

