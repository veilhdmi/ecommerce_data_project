SELECT
    geolocation_zip_code_prefix as zip_code,
    geolocation_lat as latitude,
    geolocation_lng as longitude,
    geolocation_city as city,
    geolocation_state as state
FROM {{ source('olist_raw', 'raw_geolocation') }}