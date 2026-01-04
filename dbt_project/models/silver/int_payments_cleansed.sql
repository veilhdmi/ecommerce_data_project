{{ config(materialized='table') }}

WITH payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
)

SELECT
    order_id,
    UPPER(payment_type) AS payment_method,
    payment_installments,
    amount AS total_paid  -- Cambio aquí
FROM payments