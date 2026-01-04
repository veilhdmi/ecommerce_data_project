{{ config(materialized='table') }}

SELECT
    review_id,
    order_id,
    score,
    created_at,
    answered_at,
    -- Etiquetamos reviews negativas para análisis rápido
    CASE WHEN score <= 2 THEN TRUE ELSE FALSE END AS is_bad_review
FROM {{ ref('stg_reviews') }}