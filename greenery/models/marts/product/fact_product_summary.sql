{{
  config(
    materialized='table'
  )
}}

with order_items as (
    SELECT
        created_at::date as created_on,
        product_id,
        product,
        sum(quantity) as product_quantity,
        count(distinct order_id) as orders
    FROM {{ ref('int_order_items' )}}
    GROUP BY 1, 2, 3
),

events as (
    SELECT
        created_at::date as created_on,
        product_id, 
        sum((event_type = 'page_view')::int) as page_views,
        sum((event_type = 'add_to_cart')::int) as add_to_carts
    FROM {{ ref('stg_events') }}
    GROUP BY 1, 2
),

join_events_to_order_items as (
    SELECT
        oi.*,
        e.page_views,
        e.add_to_carts
    FROM order_items oi
    LEFT JOIN events e
        ON oi.created_on = e.created_on
        AND oi.product_id = e.product_id
)

SELECT * FROM join_events_to_order_items