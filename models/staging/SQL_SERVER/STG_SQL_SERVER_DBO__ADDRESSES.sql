WITH src_addresses AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ADDRESSES') }}
    ),

renamed_casted_addresses AS (
    SELECT
          ADDRESS_ID
        , ADDRESS
        , STATE
        , COUNTRY
        , ZIPCODE
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , CASE 
            WHEN _FIVETRAN_DELETED IS NULL THEN FALSE 
            ELSE TRUE 
        END AS FIELD_DELETED  
    FROM src_addresses
    )

SELECT * FROM renamed_casted_addresses
