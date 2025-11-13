-- Table: Seat
--
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | student     | varchar |
-- +-------------+---------+
-- id is the primary key (unique value) column for this table.
-- Each row of this table indicates the name and the ID of a student.
-- The ID sequence always starts from 1 and increments continuously.
--
--
-- Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.
--
-- Return the result table ordered by id in ascending order.
--
-- The result format is in the following example.
--
--
--
-- Example 1:
--
-- Input:
-- Seat table:
-- +----+---------+
-- | id | student |
-- +----+---------+
-- | 1  | Abbot   |
-- | 2  | Doris   |
-- | 3  | Emerson |
-- | 4  | Green   |
-- | 5  | Jeames  |
-- +----+---------+
-- Output:
-- +----+---------+
-- | id | student |
-- +----+---------+
-- | 1  | Doris   |
-- | 2  | Abbot   |
-- | 3  | Green   |
-- | 4  | Emerson |
-- | 5  | Jeames  |
-- +----+---------+
-- Explanation:
-- Note that if the number of students is odd, there is no need to change the last one's seat.

-- se o numero for impar id + 1
-- se o numero for par id - 1
with count_mov_user as (
    select
        m.user_id,
        u.name,
        count(movie_id)
    from MovieRating m
             join Users u using(user_id)
    group by 1, 2
    order by 3 desc, 2 asc
    limit 1
    ),
    avg_movies as (
select
    m1.movie_id,
    m2.title,
    avg(rating) from MovieRating m1
    join movies m2 using(movie_id)
where created_at Between '2020-02-01' and '2020-02-29'
group by 1, 2
order by 3 desc, 2 asc
    limit 1
    )
select name as results from count_mov_user
union all
select title from avg_movies;
