{{ config(materialized='table') }}

SELECT
    seller_id,
    zip_code,
    UPPER(city) AS city,
    state
FROM {{ ref('stg_sellers') }}