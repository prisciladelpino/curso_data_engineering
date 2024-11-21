WITH stg_events AS (
    SELECT * 
    FROM {{ ref('STG_SQL_SERVER_DBO__EVENTS') }}
    ),

stg_users AS (
    SELECT * 
    FROM {{ ref('STG_SQL_SERVER_DBO__USERS') }}    
),

caso_producto as(
    SELECT
        A.SESSION_ID
        , A.USER_ID
        , B.FIRST_NAME
        , B.EMAIL
        , MIN(A.CREATED_AT_UTC) AS FIRST_EVENT_TIME_UTC
        , MAX(A.CREATED_AT_UTC) AS LAST_EVENT_TIME_UTC
        , DATEDIFF(minute, MIN(A.CREATED_AT_UTC), MAX(A.CREATED_AT_UTC)) AS DIFERENCIA_MIN
        ,sum(case when event_type = 'page_view' then 1 end) as page_view_amount
        ,sum(case when event_type = 'add_to_cart' then 1 end) as add_to_cart
        ,sum(case when event_type = 'checkout' then 1 end) as checkout
        ,sum(case when event_type = 'package_shipped' then 1 end) as package_shipped
    FROM stg_events A
    INNER JOIN stg_users B
    ON A.USER_ID=B.USER_ID
    GROUP BY A.SESSION_ID, A.USER_ID, B.FIRST_NAME, B.EMAIL
)

SELECT *
FROM caso_producto