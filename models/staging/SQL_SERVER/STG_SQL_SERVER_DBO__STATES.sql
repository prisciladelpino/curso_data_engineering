WITH src_addresses AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ADDRESSES') }}
    ),

renamed_casted_states AS (
    SELECT 
          DISTINCT STATE
        , COUNTRY
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_addresses
    )

SELECT * FROM renamed_casted_states