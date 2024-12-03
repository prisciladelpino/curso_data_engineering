WITH stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__users') }}
    ),

dim_users AS(

    SELECT
        user_id
        , first_name
        , last_name
        , address_id
        , phone_number
        , email
        , created_at_utc
        , updated_at_utc
        , date_load_utc
        , field_deleted  
    FROM stg_users
)

SELECT * 
FROM dim_users