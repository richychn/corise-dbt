{{
  config(
    materialized='table'
  )
}}

with user_sessions as (
    SELECT
        CONCAT(user_id, session_id) as user_session_id,
        user_id,
        session_id,
        min(created_at) as created_at,
        sum((event_type = 'page_view')::int) as page_views,
        sum((event_type = 'add_to_cart')::int) as add_to_carts,
        sum((event_type = 'checkout')::int) as checkouts,
        sum((event_type = 'package_shipped')::int) as packages_shipped,
        count(distinct page_url) as pages_visited,
        page_views > 0 as has_page_view,
        add_to_carts > 0 as has_atc,
        checkouts > 0 as has_checkout,
        packages_shipped > 0 as has_package_shipped
    FROM {{ ref('stg_events') }}
    GROUP BY 1, 2, 3
)

SELECT * FROM user_sessions