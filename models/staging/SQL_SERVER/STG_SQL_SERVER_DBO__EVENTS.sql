WITH src_events AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'EVENTS') }}
    ),

renamed_casted_events AS (
    SELECT
          EVENT_ID
        , SESSION_ID
        , EVENT_TYPE
        , PAGE_URL
        , USER_ID
        , PRODUCT_ID
        , CREATED_AT
        , ORDER_ID
        , _FIVETRAN_SYNCED AS date_load
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_addresses
    )

SELECT * FROM renamed_casted_events
