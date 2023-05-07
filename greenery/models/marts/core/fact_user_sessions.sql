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
        {{ sum_events('page_view') }} as page_views,
        {{ sum_events('add_to_cart') }} as add_to_carts,
        {{ sum_events('checkout') }} as checkouts,
        {{ sum_events('package_shipped') }} as packages_shipped,
        count(distinct page_url) as pages_visited,
        page_views > 0 as has_page_view,
        add_to_carts > 0 as has_atc,
        checkouts > 0 as has_checkout,
        packages_shipped > 0 as has_package_shipped
    FROM {{ ref('stg_events') }}
    {{ dbt_utils.group_by(n=3) }}
)

SELECT * FROM user_sessions