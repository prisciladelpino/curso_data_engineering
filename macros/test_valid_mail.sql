
{% test valid_email(model, column_name) %}

WITH src_data AS (
    SELECT {{ column_name }} AS email
    FROM {{ model }}
),

testing_mail AS (
    SELECT
        email, 
        COALESCE(
            REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'), 
            false
        ) AS is_valid_email
    FROM src_data
)

SELECT 
    email
FROM testing_mail
WHERE is_valid_email = false

{% endtest %}

