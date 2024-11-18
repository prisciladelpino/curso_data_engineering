WITH BASE_DATE AS(
    SELECT * FROM (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2024-01-01' as date)",
        end_date="cast('2025-12-31' as date)"
    )
    }}
    )
)

SELECT 
    DATE_DAY as date_id  -- Identificador único de la fecha
    , year (DATE_DAY) as year  -- Año
    , month(DATE_DAY) as month_number  -- Número del mes
    , to_char(DATE_DAY, 'Month') as month_name  -- Nombre del mes
    , day(DATE_DAY) as day_of_month  -- Día del mes
    , case 
        when dayofweek(DATE_DAY) = 0 then 7
        else dayofweek(DATE_DAY)
    end as weekday_number  -- Día de la semana (1 = Domingo, 7 = Sábado)
    , dayname(DATE_DAY) as weekday_name  -- Nombre del día de la semana
    , quarter(DATE_DAY) as quarter  -- Trimestre (1-4)
    , case
        when month(DATE_DAY) in (1, 2, 3, 4) then 1  -- Cuatrimestre 1
        when month(DATE_DAY) in (5, 6, 7, 8) then 2  -- Cuatrimestre 2
        when month(DATE_DAY) in (9, 10, 11, 12) then 3  -- Cuatrimestre 3
    end as quatrimester,  -- Cuatrimestre (1-3)

    -- Otros posibles campos adicionales
    case 
        when dayofweek(DATE_DAY) in (1, 5) then 'Weekday'
        else 'Weekend'
    end as day_type  -- Tipo de día (fin de semana o día de semana)

from BASE_DATE


