WITH src_order_items AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ORDER_ITEMS') }}
    ),

renamed_casted_order_items AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID', 'ORDER_ID']) }} AS ORDER_ITEM_ID        
        , PRODUCT_ID
        , ORDER_ID
        , QUANTITY::NUMBER(5,0)
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , CASE 
            WHEN _FIVETRAN_DELETED IS NULL THEN FALSE 
            ELSE TRUE 
        END AS FIELD_DELETED  
    FROM src_order_items
    )

SELECT * FROM renamed_casted_order_items
