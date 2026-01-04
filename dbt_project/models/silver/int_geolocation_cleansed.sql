{{ config(materialized='table') }}

SELECT
    zip_code,
    latitude,
    longitude,
    UPPER(city) AS city,
    state
FROM {{ ref('stg_geolocation') }}
-- Eliminamos duplicados de coordenadas para el mismo código postal
QUALIFY ROW_NUMBER() OVER(PARTITION BY zip_code ORDER BY latitude) = 1