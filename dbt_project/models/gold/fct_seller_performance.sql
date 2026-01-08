{{ config(materialized='table') }}

WITH seller_metrics AS (
    SELECT
        i.seller_id,
        COUNT(DISTINCT i.order_id) AS total_orders,
        SUM(i.price) AS total_revenue,
        AVG(i.freight_cost) AS avg_shipping_cost,
        COUNT(CASE WHEN i.shipping_limit_at < o.delivered_at THEN 1 END) AS delayed_shippings
    FROM {{ ref('int_items_cleansed') }} i
    JOIN {{ ref('int_orders_cleansed') }} o ON i.order_id = o.order_id
    GROUP BY 1
),

seller_reviews AS (
    -- Agregamos la lógica de reviews
    SELECT
        i.seller_id,
        AVG(r.score) AS avg_review_score
    FROM {{ ref('int_items_cleansed') }} i
    JOIN {{ ref('int_reviews_cleansed') }} r ON i.order_id = r.order_id
    GROUP BY 1
),

seller_top_category AS (
    -- Calculamos cuál es la categoría que más ingresos le da a cada vendedor
    SELECT 
        seller_id,
        macro_category,
        ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY SUM(price) DESC) as rank_cat
    FROM {{ ref('int_items_cleansed') }} i
    JOIN {{ ref('dim_products') }} p ON i.product_id = p.product_id
    GROUP BY 1, 2
)

SELECT
    s.seller_id,
    -- Traemos la Macro-región del vendedor para que el filtro de Looker funcione
    s.macro_region, 
    -- Traemos la categoría más vendida (donde rank_cat = 1)
    stc.macro_category AS top_selling_category,
    sm.total_orders,
    sm.total_revenue,
    sm.avg_shipping_cost,
    sm.delayed_shippings,
    sr.avg_review_score,
    1 - (CAST(sm.delayed_shippings AS FLOAT) / NULLIF(sm.total_orders, 0)) AS punctuality_rate
FROM {{ ref('int_sellers_cleansed') }} s
LEFT JOIN seller_metrics sm ON s.seller_id = sm.seller_id
LEFT JOIN seller_reviews sr ON s.seller_id = sr.seller_id
LEFT JOIN seller_top_category stc ON s.seller_id = stc.seller_id AND stc.rank_cat = 1