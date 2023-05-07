{{
  config(
    materialized='table'
  )
}}

with bring_in_users as (
    SELECT
        user_id,
        first_name,
        last_name,
        email,
        phone_number,
        address_id,
        created_at
    FROM {{ ref('stg_users') }}
)

SELECT * FROM bring_in_users