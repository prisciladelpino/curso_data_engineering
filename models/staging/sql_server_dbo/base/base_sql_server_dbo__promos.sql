--Se decica esta base para añadir una nueva fila a la tabla PROMOS dedicada al supuesto de que no haya promo 'no_promo'
    --Posteriormente, en el stage, castearemos todos los datos ya con la nueva fila incluida


WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

existing_promos AS (
   
    SELECT
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id
        , promo_id AS promo_name            
        , discount
        , status
        , _fivetran_synced
        , _fivetran_deleted

    FROM src_promos
    ),

new_promo AS(
    SELECT
        md5('no_promo') AS promo_id 
        , 'no_promo' AS promo_name
        , 0 AS discount
        , 'inactive' AS status
        , CURRENT_TIMESTAMP as _fivetran_synced
        , null AS  _fivetran_deleted
)

SELECT *
FROM existing_promos

UNION ALL

SELECT *
FROM new_promo

