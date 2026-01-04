{{ config(materialized='table') }}

SELECT
    product_id,
    COALESCE(category_name, 'others') AS category_name, -- Cambio aquí
    weight_g / 1000 AS weight_kg,                       -- Cambio aquí
    length_cm                                           -- Cambio aquí
FROM {{ ref('stg_products') }}