WITH src_budget AS (
    SELECT * 
    FROM {{ source('GOOGLE_SHEETS', 'BUDGET') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_id', 'month']) }} AS BUDGET_ID
        , product_id
        , quantity
        , month
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD
    FROM src_budget
    )

SELECT * FROM renamed_casted