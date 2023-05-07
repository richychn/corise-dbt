{{
  config(
    materialized='table'
  )
}}

with bring_in_products as (
    SELECT
        product_id,
        name,
        price,
        inventory
    FROM {{ ref('stg_products') }}
)

SELECT * FROM bring_in_products