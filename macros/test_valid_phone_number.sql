{% test valid_phone_number(model, column_name) %}

WITH src_data AS (
    SELECT {{ column_name }} AS phone_number
    FROM {{ model }}
),

testing_phone AS (
    SELECT
        phone_number, 
        COALESCE(
            REGEXP_LIKE(TRIM(phone_number), '^[0-9]{3}-[0-9]{3}-[0-9]{4}$'), 
            false
        ) AS is_valid_phone
    FROM src_data
)

SELECT 
    phone_number
FROM testing_phone
WHERE is_valid_phone = false

{% endtest %}

