
{{
  config(
    materialized='incremental'
    , on_schema_change='fail'
  )
}}

WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}

{% if is_incremental() %}
	  where _fivetran_synced > (select max(date_load_utc) from {{ this }} )
{% endif %}

    ),

renamed_casted_order_items AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_id', 'order_id']) }} AS order_item_id        
        , product_id
        , order_id
        , quantity::int AS product_quantity_sold
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted  
    FROM src_order_items
    )

SELECT * FROM renamed_casted_order_items
