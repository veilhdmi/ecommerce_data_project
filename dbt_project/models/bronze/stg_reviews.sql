SELECT
    review_id,
    order_id,
    review_score as score,
    CAST(review_creation_date AS DATE) as created_at,
    CAST(review_answer_timestamp AS TIMESTAMP) as answered_at
FROM {{ source('olist_raw', 'raw_reviews') }}