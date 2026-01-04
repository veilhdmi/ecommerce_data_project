{{ config(materialized='table') }}

WITH seller_metrics AS (
    SELECT
        i.seller_id,
        COUNT(DISTINCT i.order_id) AS total_orders,
        SUM(i.price) AS total_revenue,
        AVG(i.freight_cost) AS avg_shipping_cost,
        -- Calculamos si el envío se hizo a tiempo comparando con el límite
        COUNT(CASE WHEN i.shipping_limit_at < o.delivered_at THEN 1 END) AS delayed_shippings
    FROM {{ ref('int_items_cleansed') }} i
    JOIN {{ ref('int_orders_cleansed') }} o ON i.order_id = o.order_id
    GROUP BY 1
),

seller_reviews AS (
    SELECT
        i.seller_id,
        AVG(r.score) AS avg_review_score
    FROM {{ ref('int_items_cleansed') }} i
    JOIN {{ ref('int_reviews_cleansed') }} r ON i.order_id = r.order_id
    GROUP BY 1
)

SELECT
    s.seller_id,
    sm.total_orders,
    sm.total_revenue,
    sm.avg_shipping_cost,
    sm.delayed_shippings,
    sr.avg_review_score,
    -- Ratio de puntualidad
    1 - (CAST(sm.delayed_shippings AS FLOAT) / NULLIF(sm.total_orders, 0)) AS punctuality_rate
FROM {{ ref('int_sellers_cleansed') }} s
LEFT JOIN seller_metrics sm ON s.seller_id = sm.seller_id
LEFT JOIN seller_reviews sr ON s.seller_id = sr.seller_id