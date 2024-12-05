WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
        CAST({{ dbt_utils.generate_surrogate_key(['product_id', 'month']) }} AS varchar(50)) AS budget_id
        , product_id::varchar(100) AS product_id
        , quantity::int AS target_quantity
        , CAST (month AS date) as budget_month
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
    FROM src_budget
    )

SELECT * FROM renamed_casted
