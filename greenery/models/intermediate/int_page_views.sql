{{
  config(
    materialized='table'
  )
}}

with bring_in_events as (
    SELECT
        event_id,
        session_id,
        user_id,
        created_at,
        product_id
    FROM {{ ref('stg_events' )}} 
    WHERE event_type = 'page_view'
)

SELECT * FROM bring_in_events
