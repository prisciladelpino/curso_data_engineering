WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted_promos AS (
   
    SELECT
       
          {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id           --Generamos un id único con un hash
        , LOWER(promo_id) AS promo_desc              -- Cambiamos el antiguo promo_id por la descripción de la promoción 
        , discount AS discount_in_dollar     --Indicamos que el descuento es en dólares (no es porcentaje)
        , status AS promo_status
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
       
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
      
        END AS field_deleted 
    FROM src_promos
    )

SELECT *
FROM renamed_casted_promos
