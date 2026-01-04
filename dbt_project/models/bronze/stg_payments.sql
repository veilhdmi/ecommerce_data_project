SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value as amount
FROM {{ source('olist_raw', 'raw_payments') }}