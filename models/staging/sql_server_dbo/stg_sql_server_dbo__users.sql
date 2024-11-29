WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted_users AS (
    SELECT
          {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id --Generamos una clave subrogada utilizando el paquete utils
        , first_name
        , last_name
        , address_id
        , phone_number
        , email
        , CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc
        , CONVERT_TIMEZONE('UTC', updated_at) AS updated_at_utc
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted  
    FROM src_users
    )

SELECT * FROM renamed_casted_users


