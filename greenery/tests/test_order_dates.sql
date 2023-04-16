SELECT * 
FROM {{ ref('stg_orders') }}
WHERE delivered_at < created_at