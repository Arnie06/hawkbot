-- good_example.sql
-- This file follows the hawkbot.md styling rules.
-- Use it to verify the PR review service passes clean SQL.

WITH orders_source AS (
    SELECT
        order_id,
        user_id,
        order_status,
        order_amount,
        is_large_order,
        created_at,
        adduser AS created_by,
        adddatetime AS created_at,
        landingcreatedate AS landing_created_at,
        etlfilename AS etl_file_name,
        CURRENT_TIMESTAMP() AS etl_created_at,
        CURRENT_TIMESTAMP() AS etl_updated_at
    FROM {{ source('warehouse', 'orders') }}
),

users_source AS (
    SELECT
        user_id,
        user_name,
        user_email,
        is_active,
        has_verified_email,
        created_at
    FROM {{ ref('stg_users') }}
)
-- This query retrieves order and user information, joining the orders_source and users_source CTEs.
SELECT
    orders_source.order_id,
    orders_source.user_id,
    orders_source.order_status,
    orders_source.order_amount,
    orders_source.is_large_order,
    users_source.user_name,
    users_source.user_email,
    users_source.is_active,
    users_source.has_verified_email,
    orders_source.created_at AS order_created_at,
    users_source.created_at AS user_created_at,
    orders_source.landing_created_at,
    orders_source.etl_file_name,
    orders_source.etl_created_at,
    orders_source.etl_updated_at
FROM orders_source
INNER JOIN users_source
    ON orders_source.user_id = users_source.user_id
WHERE orders_source.order_status != 'cancelled'
GROUP BY ALL
