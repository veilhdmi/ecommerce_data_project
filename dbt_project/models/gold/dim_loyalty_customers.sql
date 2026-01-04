{{ config(materialized='table') }}

SELECT
    customer_unique_id,
    times_purchased,
    total_spent,
    CASE 
        WHEN times_purchased >= 3 THEN 'Platinum Fan'
        WHEN times_purchased = 2 THEN 'Returning Customer'
        ELSE 'One-time Visitor'
    END AS loyalty_segment,
    CASE 
        WHEN total_spent > 500 THEN 'High Spender'
        ELSE 'Standard Spender'
    END AS value_segment
FROM {{ ref('fct_customer_retention') }}
WHERE times_purchased > 1 -- Enfocamos el análisis en los que sí volvieron