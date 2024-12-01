WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted_addresses AS (
    SELECT
          address_id
        , address::varchar(100)
        , state::varchar(50)
        , country::varchar(50)
        , zipcode::int
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted  
    FROM src_addresses
    )

SELECT * FROM renamed_casted_addresses
