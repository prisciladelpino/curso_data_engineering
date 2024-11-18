
{{
  config(
    materialized='table'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'PROMOS') }}
    ),

renamed_casted_promos AS (
    SELECT
          MD5(PROMO_ID) AS ID_PROMO           --Generamos un id único con un hash
        , PROMO_ID AS PROMO_DESC              -- Cambiamos el antiguo promo_id por la descripción de la promoción 
        , DISCOUNT AS DISCOUNT_IN_DOLLARS     --Indicamos que el descuento es en dólares (no es porcentaje)
        , STATUS AS STATUS_DISCOUNT
        , _FIVETRAN_SYNCED AS DATE_LOAD
        , _FIVETRAN_DELETED AS IS_DELETED
    FROM src_promos
    ),


--Añadimos una nueva fila para el caso de que NO exista descuento
new_promo AS (
    SELECT
        MD5('SIN_PROMO') AS ID_PROMO
        , CAST('SIN_PROMO' AS VARCHAR(256)) AS PROMO_DESC
        , CAST(0 AS NUMBER(38,0)) AS DISCOUNT_IN_DOLLARS
        , CAST('ACTIVE' AS VARCHAR(256)) AS STATUS_DISCOUNT
        , CURRENT_TIMESTAMP AS DATE_LOAD
        , CAST(NULL AS BOOLEAN) AS IS_DELETED
        )

-- Combinamos los datos existentes con la nueva fila
SELECT *
FROM renamed_casted_promos

UNION ALL

SELECT *
FROM new_promo