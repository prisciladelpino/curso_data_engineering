{% test valid_zipcode(model, column_name) %}

WITH src_data AS (
    SELECT {{ column_name }} AS zipcode
    FROM {{ model }}
),

testing_zipcode AS (
    SELECT
        zipcode,
        COALESCE(
            REGEXP_LIKE(TRIM(zipcode), '^[0-9]{5}$') AND zipcode != '00000',
            false
        ) AS is_valid_zipcode
    FROM src_data
)

SELECT 
    zipcode
FROM testing_zipcode
WHERE is_valid_zipcode = false

{% endtest %}
