{{
  config(
    materialized='table'
  )
}}

with order_items as (
    SELECT
        CONCAT(o.order_id, oi.product_id) as order_item_id,
        o.order_id,
        o.promo_id,
        o.user_id,
        o.address_id,
        o.created_at,
        o.tracking_id,
        o.shipping_service,
        o.estimated_delivery_at,
        o.delivered_at,
        o.status,
        oi.product_id,
        oi.quantity
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_order_items' )}} oi
        ON o.order_id = oi.order_id
),

bring_in_product as (
    SELECT
        oi.*,
        p.name as product
    FROM order_items oi
    LEFT JOIN {{ ref('stg_products' )}} p
        ON oi.product_id = p.product_id
)

SELECT * FROM bring_in_product
