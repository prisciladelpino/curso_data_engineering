WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted_users AS (
    SELECT
          {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id --Generamos una clave subrogada utilizando el paquete utils
        , first_name::varchar(50) AS first_name
        , last_name::varchar(50) AS last_name
        , address_id::varchar(50) AS address_id
        , cast(replace(phone_number, '-', '') as number(38,0)) AS phone_number --Quitamos los guiones del nº de teléfono
        , email::varchar(50) AS email
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


