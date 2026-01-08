{{ config(materialized='table') }}

SELECT
    seller_id,
    zip_code,
    UPPER(city) AS seller_city,
    state AS seller_state,
    -- Agregamos iso_state por si quieres mapear las tiendas en un mapa de Looker
    CONCAT('BR-', state) AS iso_state,
    -- Jerarquía regional (Idéntica a customers_enriched)
    CASE 
        WHEN state IN ('SP', 'RJ', 'MG', 'ES') THEN 'Southeast'
        WHEN state IN ('PR', 'SC', 'RS') THEN 'South'
        WHEN state IN ('MT', 'MS', 'GO', 'DF') THEN 'Central-West'
        WHEN state IN ('BA', 'PE', 'CE', 'PB', 'MA', 'PI', 'RN', 'AL', 'SE') THEN 'Northeast'
        WHEN state IN ('PA', 'TO', 'AM', 'RO', 'AC', 'RR', 'AP') THEN 'North'
        ELSE 'Unknown'
    END AS macro_region
FROM {{ ref('stg_sellers') }}