-- Write your MySQL query statement below
select product_id
from products
where low_fats = 'Y'
  and recyclable = 'Y';

-- Write your MySQL query statement below
select name
from customer
where referee_id != 2 or referee_id is null;


-- Write your MySQL query statement below
select name, population, area
from world
where area >= 3000000
   or population >= 25000000;


select distinct viewer_id as id
from views
where author_id = viewer_id
order by 1;

select tweet_id
from tweets
where length(content) > 15;

select b.unique_id, e.name
from employees e
         left join employeeuni b on e.id = b.id;

select product_name, year, price
from sales
    join product using (product_id);

select customer_id, count(1) as count_no_trans
from visits
         left join transactions using (visit_id)
where transaction_id is null
group by 1;

select w1.id as id
from weather w1
         join weather w2 on w1.recordDate = w2.recordDate + INTERVAL '1 day'
where w1.temperature > w2.temperature;



select machine_id, ROUND(avg(duration::numeric), 3) as processing_time
from (with ends as (select *
                    from activity
                    where activity_type = 'end')
      select a.process_id,
             a.machine_id,
             e.timestamp - a.timestamp as duration
      from activity a
               join ends e on a.process_id = e.process_id and a.machine_id = e.machine_id
      where a.activity_type = 'start') t
group by 1;

select e.name, bonus
from employee e
         left join bonus b using (empId)
where b.bonus < 1000
   or b.bonus is null;

-- Students and examinations
select s.student_id,
       s.student_name,
       sb.subject_name,
       count(e.subject_name) as attended_exams
from students s
         cross join subjects sb
         left join examinations e on e.student_id = s.student_id
    and e.subject_name = sb.subject_name
group by 1, 2, 3
order by 1, 3;

-- manager report more thant 5
select e2."name"
from (select managerId, count(1) as qt
      from employee e
      group by 1
      Having count(1) >= 5) t
         join employee e2 on t.managerId = e2.id
where t.managerId is not null;



-- confirmation rate
-- Write your PostgreSQL query statement below
-- calcula total confirmations
-- filtra confirmeds e divide pelo total
select user_id,
   case
       when confirmation_rate is null then 0
       else confirmation_rate end
from (with total as (select user_id,
                        (select count(1) from confirmations where action = 'confirmed' and c.user_id = user_id) as confirmed,
 (select count(1) from confirmations where c.user_id = user_id) as total_req from confirmations c
)
select s.user_id,
   max(round(confirmed::numeric / total_req, 2)) as confirmation_rate
from signups s
     left join total t on t.user_id = s.user_id
group by 1);


-- not boring movies
select *
from cinema
where id % 2 = 1 and description != 'boring'
order by rating desc;


-- Write your PostgreSQL query statement below
SELECT product_id,
       case
           when average_price is null then 0
           else average_price end,
       ROUND(SUM(pu)::numeric / NULLIF(SUM
from (select product_id(units), 0), 2) AS average_price
      from (select p.product_id,
                   p.start_date,
                   p.end_date,
                   p.price,
                   case
                       when u.units is null then 0
                       else u.units end,
                   case
                       when u.units is null then 0
                       else p.price * u.units end as pu
            from prices p
                     left join unitssold u on p.product_id = u.product_id
                and u.purchase_date >= p.start_date and u.purchase_date <= p.end_date) t
      group by 1) x;



select project_id,
       round(avg(experience_years)::numeric, 2) as average_years
from project p
         join employee e on p.employee_id = e.employee_id
group by 1


-- total users per contest divided by total users
    with total as (
    select contest_id,
    count(1) as tot,
    (select count(1) from users) as tot_users
    from register
    group by 1
)
select contest_id,
       round((tot::numeric / tot_users::numeric) * 100, 2) as "percentage"
from total
order by 2 desc, 1 asc

-- quality
SELECT query_name,
       ROUND(AVG(rating::numeric / position::numeric), 2) AS quality,
       ROUND(
               (COUNT(*) FILTER (WHERE rating < 3)::numeric / COUNT(*) * 100),
               2
       )                                                  AS poor_query_percentage
FROM queries
GROUP BY query_name;


select final.month,
       case
           when final.country = 'unknown' then null
           else final.country end,
       final.trans_count,
       final.approved_count,
       final.trans_total_amount,
       final.approved_total_amount

from (with with_month as (select t.*,
                                 coalesce(country, 'unknown') as country_transformed,
                                 TO_CHAR(trans_date, 'YYYY-MM') as month
      from transactions t)
select w2.month,
       w2.country_transformed                                                        as country,
       count(1)                                                                      as trans_count,
       (select count(1)
        from with_month w
        where state = 'approved'
          and w.month = w2.month
          and w.country_transformed = w2.country_transformed)                        as approved_count,
       (select sum(amount)
        from with_month w
        where w.month = w2.month and w.country_transformed = w2.country_transformed) as trans_total_amount,
       (select coalesce(sum(amount), 0)
        from with_month w
        where state = 'approved'
          and w.month = w2.month
          and w.country_transformed = w2.country_transformed)                        as approved_total_amount
from with_month w2
group by 1, 2) final


with first_orders as (
    select
    *, case
    when order_date = customer_pref_delivery_date then 1
    else 0 end as count_immediate, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date asc) as rn
    from delivery
    )
select round(sum(count_immediate) / sum(rn) * 100, 2) as immediate_percentage
from first_orders
where rn = 1


-- Write your PostgreSQL query statement below
select round(sum(count_log_day_after) / count(count_log_day_after)::numeric, 2)
           as fraction
from (with first_log as (select *,
                                ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date asc) as rn
                         from activity)
      select case
                 when (select count(1)
                       from activity a
                       where a.event_date - 1 = first_log.event_date and a.player_id = first_log.player_id) >= 1 then 1
                 else 0
                 end as count_log_day_after
      from first_log
      where rn = 1) t;

select activity_date as day, count(distinct(user_id)) as active_users
from activity
where activity_date <= '2019-07-27' and activity_date > '2019-07-27':: date - INTERVAL '30 days'
group by 1;


-- Write your PostgreSQL query statement below
SELECT product_id, year AS first_year, quantity, price
FROM
    sales
WHERE
    (product_id
    , year) IN (
    select
    product_id
    , MIN (year) AS year
    from sales
    group by 1
    );


select class
from courses
group by 1
HAVING count(student) >= 5;



select user_id, count(follower_id) as followers_count
from followers
group by 1
order by 1


with numbers as (
    select num, count(1) as n_count from mynumbers
    group by 1
)
select max(num) as num
from numbers
where n_count = 1;



with rec as (
    select
        customer_id,
        count(distinct(product_key)) as t_product
    from customer
    group by 1
)
select customer_id from rec
where t_product = (select count(1) from product)

select * from (
select
  e.employee_id,
  e.name,
  (select count(1) from employees e2 where e2.reports_to = e.employee_id) as reports_count,
  (select round(avg(e2.age), 0) from employees e2 where e2.reports_to = e.employee_id) as average_age
from employees e) t
where t.reports_count > 0
order by employee_id



-- Write your PostgreSQL query statement below
    with deps as (
    select
    employee_id,
    count(distinct(department_id)) as count_dep from employee
    group by 1
)
select employee_id,  department_id from employee e
                                            join deps d using(employee_id)
where d.count_dep = 1
union all
select employee_id,  department_id from employee
where primary_flag = 'Y'
