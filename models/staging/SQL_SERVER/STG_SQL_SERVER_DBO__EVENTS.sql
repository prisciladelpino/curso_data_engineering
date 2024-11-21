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
        , {{ dbt_utils.generate_surrogate_key(['USER_ID']) }} AS USER_ID
        , PRODUCT_ID
        , CONVERT_TIMEZONE('UTC', CREATED_AT) AS CREATED_AT_UTC
        , ORDER_ID
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_events
    )

SELECT * FROM renamed_casted_events
