
WITH base_promos AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__promos') }}
    ),

add_promo AS (
    SELECT *
    FROM base_promos

--Añadimos una nueva fila para el caso de que NO exista descuento
UNION ALL

    SELECT
        MD5('sin_promo') AS id_promo
        , CAST('sin_promo' AS VARCHAR(256)) AS promo_desc
        , CAST(0 AS number(38,0)) AS discount_in_dollar
        , CAST('ACTIVE' AS VARCHAR(256)) AS promo_status
        , CURRENT_TIMESTAMP AS date_load_utc
        , CAST(False AS BOOLEAN) AS field_deleted
        )

SELECT *
FROM add_promo

