-- Antes: {{ config(materialized='table') }}
-- Después:
{{ config(materialized='ephemeral') }}

WITH customer_orders AS (
    SELECT
        customer_unique_id,
        COUNT(order_id) AS times_purchased,
        SUM(total_order_value) AS total_spent,
        MIN(purchase_at) AS first_purchase_at,
        MAX(purchase_at) AS last_purchase_at
    FROM {{ ref('int_customers_cleansed') }}
    JOIN {{ ref('fct_sales') }} USING (customer_id)
    GROUP BY 1
)

SELECT
    *,
    DATEDIFF('day', first_purchase_at, last_purchase_at) AS customer_lifetime_days,
    CASE 
        WHEN times_purchased > 1 THEN 'Repeat Customer'
        ELSE 'One-time Buyer'
    END AS customer_segment,
    CASE 
        WHEN DATEDIFF('day', last_purchase_at, CURRENT_TIMESTAMP()) > 180 THEN 'Churned'
        ELSE 'Active'
    END AS retention_status
FROM customer_orders