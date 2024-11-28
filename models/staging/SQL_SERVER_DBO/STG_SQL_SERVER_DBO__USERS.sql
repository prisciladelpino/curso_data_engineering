WITH src_users AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'USERS') }}
    ),

renamed_casted_users AS (
    SELECT
          {{ dbt_utils.generate_surrogate_key(['USER_ID']) }} AS USER_ID --Generamos una clave subrogada utilizando el paquete utils
        , FIRST_NAME
        , LAST_NAME
        , ADDRESS_ID
        , PHONE_NUMBER
        , EMAIL
        , CONVERT_TIMEZONE('UTC', CREATED_AT) AS CREATED_AT_UTC
        , CONVERT_TIMEZONE('UTC', UPDATED_AT) AS UPDATED_AT_UTC
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , CASE 
            WHEN _FIVETRAN_DELETED IS NULL THEN FALSE 
            ELSE TRUE 
        END AS FIELD_DELETED  
    FROM src_users
    )

SELECT * FROM renamed_casted_users

