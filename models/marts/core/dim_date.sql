with stg_time as(
    select *
    from {{ ref('stg_date') }}
),

dim_time as(
    select
        date_id
        , date_day                  
        , year  
        , month_number  
        , month_name  
        , day_of_month      
        , weekday_number          
        , weekday_name  
        , quarter       
        , quatrimester  
        , semester  
        , day_type  
    from stg_time      
)

select *
from dim_time