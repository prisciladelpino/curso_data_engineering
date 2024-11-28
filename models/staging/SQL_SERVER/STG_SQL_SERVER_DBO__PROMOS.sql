

WITH base_promos AS (
    SELECT * 
    FROM {{ ref('BASE_SQL_SERVER_DBO__PROMOS') }}
    ),

add_promo AS (
    SELECT *
    FROM base_promos

--Añadimos una nueva fila para el caso de que NO exista descuento
UNION ALL

    SELECT
        MD5('SIN_PROMO') AS ID_PROMO
        , CAST('SIN_PROMO' AS VARCHAR(256)) AS PROMO_DESC
        , CAST(0 AS NUMBER(38,0)) AS DISCOUNT_IN_DOLLAR
        , CAST('ACTIVE' AS VARCHAR(256)) AS PROMO_STATUS
        , CURRENT_TIMESTAMP AS DATE_LOAD_UTC
        , CAST(False AS BOOLEAN) AS FIELD_DELETED
        )

SELECT *
FROM add_promo

