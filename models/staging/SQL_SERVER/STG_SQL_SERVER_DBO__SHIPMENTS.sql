WITH src_shipping_service AS (
    SELECT * 
    FROM {{ ref('BASE_SQL_SREVER_DBO__ORDERS') }}
    ),

renamed_casted_shipping_service AS (
    SELECT DISTINCT
        SHIPMENT_ID
        , CASE WHEN 
            SHIPPING_SERVICE ='' THEN 'not_asigned' 
            ELSE SHIPPING_SERVICE 
        END AS SHIPPING_SERVICE_DESC
        , SHIPPING_COST
        , DATE_LOAD_UTC
        , is_deleted
    FROM src_shipping_service
    )

SELECT * FROM renamed_casted_shipping_service