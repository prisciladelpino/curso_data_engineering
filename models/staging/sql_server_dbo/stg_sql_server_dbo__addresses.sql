{{
  config(
      materialized='incremental'
    , unique_key='address_id'
    , on_schema_change='fail'
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}

    {% if is_incremental() %}
        WHERE _fivetran_synced > (SELECT max(batched_at_utc) FROM {{ this }})
    {% endif %}
    ),


renamed_casted_addresses AS (
    SELECT
          address_id
        , address::varchar(100) as address
        , state::varchar(50) AS state
        , country::varchar(50) AS country
        , zipcode::int AS zipcode
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted  
    FROM src_addresses
    )

SELECT * FROM renamed_casted_addresses
