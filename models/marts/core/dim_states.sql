WITH stg_states AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__addresses') }}
    ),

dim_states AS(
    SELECT DISTINCT
         {{ dbt_utils.generate_surrogate_key(['state']) }} AS state_id
        , state
        , country
        , date_load_utc
        , field_deleted
    
    FROM stg_states         
)

SELECT *
FROM dim_states