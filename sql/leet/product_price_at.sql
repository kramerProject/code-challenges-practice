-- Table: Products
--
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | new_price     | int     |
-- | change_date   | date    |
-- +---------------+---------+
-- (product_id, change_date) is the primary key (combination of columns with unique values) of this table.
-- Each row of this table indicates that the price of some product was changed to a new price at some date.
-- Initially, all products have price 10.
--
-- Write a solution to find the prices of all products on the date 2019-08-16.
--
-- Return the result table in any order.
--
-- The result format is in the following example.
--
--
--
-- Example 1:
--
-- Input:
-- Products table:
-- +------------+-----------+-------------+
-- | product_id | new_price | change_date |
-- +------------+-----------+-------------+
-- | 1          | 20        | 2019-08-14  |
-- | 2          | 50        | 2019-08-14  |
-- | 1          | 30        | 2019-08-15  |
-- | 1          | 35        | 2019-08-16  |
-- | 2          | 65        | 2019-08-17  |
-- | 3          | 20        | 2019-08-18  |
-- +------------+-----------+-------------+
-- Output:
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 2          | 50    |
-- | 1          | 35    |
-- | 3          | 10    |
-- +------------+-------+
with cte as (
    select product_id,
           max(change_date) as max_change_date
    from products
    where change_date <= '2019-08-16'
    group by 1)
select p.product_id,
       coalesce(p.new_price, 10) as price
from products p
         left join cte c on p.product_id = c.product_id
where p.change_date = c.max_change_date
union all
select
    distinct product_id, 10
from products
where product_id not in (
    select product_id from cte
) and change_date > '2019-08-16'
