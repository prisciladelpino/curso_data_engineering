WITH src_promos AS (
    SELECT * 
    from {{ ref('src_promos_snap') }}
    where dbt_valid_to is null 
    ),



renamed_casted_promos AS (
    SELECT
        CAST({{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS varchar(50)) AS promo_id        -- Generamos un id único con un hash
        , LOWER(promo_id)::varchar(50) AS promo_desc                            -- Cambiamos el antiguo promo_id por la descripción de la promoción
        , discount::NUMBER(5,0) AS discount_in_usd                              -- Indicamos que el descuento es en dólares (no es porcentaje)
        , status::varchar(50) AS promo_status
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
        , CASE 
            WHEN _fivetran_deleted IS NULL THEN FALSE 
            ELSE TRUE 
        END AS field_deleted 
    FROM src_promos
),

-- Añadimos una nueva fila para el caso de que NO exista descuento
add_promo AS (
    SELECT
        CAST(md5('no_promo') AS varchar(50)) AS promo_id    -- Generamos una clave surrogada para 'sin_promo'
        , CAST('no_promo' AS VARCHAR(50)) AS promo_desc
        , CAST(0 AS NUMBER(5,0)) AS discount_in_usd
        , CAST('inactive' AS VARCHAR(50)) AS promo_status
        , CURRENT_TIMESTAMP AS date_load_utc
        , CAST(False AS BOOLEAN) AS field_deleted
),

-- Aquí aseguramos que las columnas tengan el mismo formato y nombres en ambas partes del `UNION ALL`
final_result AS (
    SELECT 
        promo_id, 
        promo_desc, 
        discount_in_usd, 
        promo_status, 
        date_load_utc, 
        field_deleted
    FROM renamed_casted_promos

    UNION ALL

    SELECT 
        promo_id, 
        promo_desc, 
        discount_in_usd, 
        promo_status, 
        date_load_utc, 
        field_deleted
    FROM add_promo
)

SELECT *
FROM final_result
