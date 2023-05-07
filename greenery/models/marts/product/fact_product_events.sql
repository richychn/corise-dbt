{{
  config(
    materialized='table'
  )
}}

with page_views as (
    SELECT
        CONCAT('page_view', event_id) as product_event_id,
        user_id,
        product_id,
        'page_view' as event_type
    FROM {{ ref('int_page_views' )}}
),

product_name as (
    SELECT distinct
        product_id,
        name
    FROM {{ ref('stg_products') }}
),

bring_in_product as (
    SELECT
        pv.*,
        name as product
    FROM page_views pv
    LEFT JOIN product_name pn
        ON pv.product_id = pn.product_id
),

order_items as (
    SELECT
        CONCAT('order', order_item_id) as product_event_id,
        user_id,
        product_id,
        'order' as event_type,
        product
    FROM {{ ref('int_order_items' )}}
),

bring_in_order_items as (
    SELECT * FROM bring_in_product

    UNION 

    SELECT * FROM order_items
)

SELECT * FROM bring_in_order_items