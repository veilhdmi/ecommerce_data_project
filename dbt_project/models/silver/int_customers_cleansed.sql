{{ config(materialized='table') }}

SELECT 
    customer_id,
    customer_unique_id,
    zip_code,  -- Usamos el nombre que definiste en stg_customers
    city,
    state
FROM {{ ref('stg_customers') }}