WITH src_shipping_service AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ORDERS') }}
    ),

renamed_casted_shipping_service AS (
    SELECT DISTINCT
          MD5(SHIPPING_SERVICE) AS SHIPPING_SERVICE_ID
        , CASE WHEN 
            SHIPPING_SERVICE ='' THEN 'not_asigned' 
            ELSE SHIPPING_SERVICE END AS SHIPPING_SERVICE_DESC
        , CURRENT_TIMESTAMP AS DATE_LOAD_UTC
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_shipping_service
    )

SELECT * FROM renamed_casted_shipping_service