{{ config(materialized='table') }}

WITH date_spine AS (
    -- Generamos una secuencia de días desde el inicio de Olist
    SELECT 
        DATEADD(day, seq4(), '2016-01-01') AS date_day
    FROM table(generator(rowcount => 1500)) -- Genera aprox 4 años
)

SELECT
    date_day AS date_id,
    YEAR(date_day) AS year,
    MONTH(date_day) AS month_num,
    MONTHNAME(date_day) AS month_name,
    QUARTER(date_day) AS quarter,
    DAYNAME(date_day) AS day_name,
    -- Identificador de fin de semana para análisis de comportamiento
    CASE WHEN DAYOFWEEK(date_day) IN (0, 6) THEN 'Weekend' ELSE 'Weekday' END AS day_type
FROM date_spine
WHERE date_day <= '2019-12-31' -- Límite razonable para el dataset