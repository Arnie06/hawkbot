-- bad_example.sql
-- This file intentionally violates the hawkbot.md styling rules.
-- Use it to test the PR review service.

with order_src as (
    select *
    from raw.orders
),

user_src as (
    select *
    from raw.users
)
-- ignore this thing
select
    o.id
    ,o.status
    ,o.amount
    ,u.name customer_name
    ,u.email customer_email
    ,case when o.amount > 100 then true else false end is_large_order
    ,o.created_at as order_date
    ,_rescued_data
    ,adduser
    ,adddatetime
from order_src o
right join user_src u on o.uid = u.id
where o.status = 'active'
  and u.name is not null
union
select
	o.id
	,o.status
	,o.amount
	,u.name customer_name
	,u.email customer_email
	,case when o.amount > 100 then true else false end is_large_order
	,o.created_at as order_date
	,_rescued_data
	,adduser
	,adddatetime
from order_src o
join user_src u on o.uid = u.id
where o.status = 'pending'
