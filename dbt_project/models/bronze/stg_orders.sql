SELECT
    order_id,
    customer_id,
    order_status as status,
    CAST(order_purchase_timestamp AS TIMESTAMP) as purchase_at,
    CAST(order_delivered_customer_date AS TIMESTAMP) as delivered_at
FROM {{ source('olist_raw', 'raw_orders') }}