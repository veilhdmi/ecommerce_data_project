{{ config(materialized='table') }}

WITH customers AS (
    -- Traemos los datos limpios de la capa intermediate
    SELECT * FROM {{ ref('int_customers_cleansed') }}
),
geo AS (
    -- Traemos la geolocalización deduplicada (la que tiene el QUALIFY)
    SELECT * FROM {{ ref('int_geolocation_cleansed') }} 
)

SELECT
    c.customer_id,
    c.customer_unique_id,
    c.city,
    c.state,
    -- CAMBIO 1: Formato ISO para que el mapa de Looker funcione (ej. BR-SP)
    CONCAT('BR-', c.state) AS iso_state, 
    g.latitude,
    g.longitude,
    -- Jerarquía regional
    CASE 
        WHEN c.state IN ('SP', 'RJ', 'MG', 'ES') THEN 'Southeast'
        WHEN c.state IN ('PR', 'SC', 'RS') THEN 'South'
        WHEN c.state IN ('MT', 'MS', 'GO', 'DF') THEN 'Central-West'
        WHEN c.state IN ('BA', 'PE', 'CE', 'PB', 'MA', 'PI', 'RN', 'AL', 'SE') THEN 'Northeast'
        WHEN c.state IN ('PA', 'TO', 'AM', 'RO', 'AC', 'RR', 'AP') THEN 'North'
        ELSE 'Unknown'
    END AS macro_region
FROM customers c
-- CAMBIO 2: Usamos 'zip_code' que es el nombre consistente en todas las capas
LEFT JOIN geo g ON c.zip_code = g.zip_code