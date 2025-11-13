-- Table: Customer
--
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | name          | varchar |
-- | visited_on    | date    |
-- | amount        | int     |
-- +---------------+---------+
-- In SQL,(customer_id, visited_on) is the primary key for this table.
-- This table contains data about customer transactions in a restaurant.
-- visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
-- amount is the total paid by a customer.
--
--
-- You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
--
-- Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
--
-- Return the result table ordered by visited_on in ascending order.
--
-- The result format is in the following example.
--
--
--
-- Example 1:
--
-- Input:
-- Customer table:
-- +-------------+--------------+--------------+-------------+
-- | customer_id | name         | visited_on   | amount      |
-- +-------------+--------------+--------------+-------------+
-- | 1           | Jhon         | 2019-01-01   | 100         |
-- | 2           | Daniel       | 2019-01-02   | 110         |
-- | 3           | Jade         | 2019-01-03   | 120         |
-- | 4           | Khaled       | 2019-01-04   | 130         |
-- | 5           | Winston      | 2019-01-05   | 110         |
-- | 6           | Elvis        | 2019-01-06   | 140         |
-- | 7           | Anna         | 2019-01-07   | 150         |
-- | 8           | Maria        | 2019-01-08   | 80          |
-- | 9           | Jaze         | 2019-01-09   | 110         |
-- | 1           | Jhon         | 2019-01-10   | 130         |
-- | 3           | Jade         | 2019-01-10   | 150         |
-- +-------------+--------------+--------------+-------------+
-- Output:
-- +--------------+--------------+----------------+
-- | visited_on   | amount       | average_amount |
-- +--------------+--------------+----------------+
-- | 2019-01-07   | 860          | 122.86         |
-- | 2019-01-08   | 840          | 120            |
-- | 2019-01-09   | 840          | 120            |
-- | 2019-01-10   | 1000         | 142.86         |
-- +--------------+--------------+----------------+
with has_7_days as (
    select
        c1.visited_on,
        (select count(1) from customer c2 where c2.visited_on = c1.visited_on - INTERVAL '6 DAYS') as count_windown,
    (select sum(amount) from customer c2 where c2.visited_on BETWEEN c1.visited_on - INTERVAL '6 DAYS' and c1.visited_on) as amount
from customer c1
group by 1
    )
select
    visited_on,
    amount,
    round(amount::numeric / 7, 2) as average_amount
from has_7_days
where count_windown > 0
order by 1
