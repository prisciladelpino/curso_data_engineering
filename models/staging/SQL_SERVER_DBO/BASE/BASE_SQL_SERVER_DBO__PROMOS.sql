WITH src_promos AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'PROMOS') }}
    ),

renamed_casted_promos AS (
    SELECT
          {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} AS PROMO_ID           --Generamos un id único con un hash
        , LOWER(PROMO_ID) AS PROMO_DESC              -- Cambiamos el antiguo promo_id por la descripción de la promoción 
        , DISCOUNT AS DISCOUNT_IN_DOLLAR     --Indicamos que el descuento es en dólares (no es porcentaje)
        , STATUS AS PROMO_STATUS
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , CASE 
            WHEN _FIVETRAN_DELETED IS NULL THEN FALSE 
            ELSE TRUE 
        END AS FIELD_DELETED 
    FROM src_promos
    )

SELECT *
FROM renamed_casted_promos