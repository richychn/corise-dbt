{{
  config(
    materialized='table'
  )
}}

with orders as (
    SELECT
        order_id,
        promo_id,
        user_id,
        address_id,
        created_at,
        order_cost,
        shipping_cost,
        order_total,
        tracking_id,
        shipping_service,
        estimated_delivery_at,
        delivered_at,
        status,
        promo_id IS NOT NULL as has_promo
    FROM {{ ref('stg_orders' )}}
),

items as (
    SELECT
        order_id,
        count(distinct product_id) as num_products,
        sum(quantity) as num_items
    FROM {{ ref('stg_order_items' )}}
    GROUP BY 1
),

bring_in_items as (
    SELECT
        o.*,
        i.num_products,
        i.num_items
    FROM orders o
    LEFT JOIN items i
        ON o.order_id = i.order_id
)

SELECT * FROM bring_in_items