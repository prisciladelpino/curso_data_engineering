WITH src_users AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'USERS') }}
    ),

renamed_casted_users AS (
    SELECT
          USER_ID
        , FIRST_NAME
        , LAST_NAME
        , ADDRESS_ID
        , PHONE_NUMBER
        , EMAIL
        , CREATED_AT
        , UPDATED_AT
        , _fivetran_synced AS date_load
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_addresses
    )

SELECT * FROM renamed_casted_users

