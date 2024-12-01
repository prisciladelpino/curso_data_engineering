WITH stg_addresses AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__addresses') }}
    ),

dim_addresses AS(
    SELECT
        address_id
        , address
        , state
        , country
        , zipcode
        , date_load_utc
        , field_deleted
    
    FROM stg_addresses         
)

SELECT *
FROM dim_addresses
