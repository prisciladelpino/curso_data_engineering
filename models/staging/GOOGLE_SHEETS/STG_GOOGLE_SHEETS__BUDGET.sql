WITH src_budget AS (
    SELECT * 
    FROM {{ source('GOOGLE_SHEETS', 'BUDGET') }}
    ),

renamed_casted AS (
    SELECT
          _row
        , product_id
        , quantity
        , month
        , _fivetran_synced AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted