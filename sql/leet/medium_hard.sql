-- managers with at least five direct reports
select name
from (select e.managerId, e2.name
      from employee e
               join employee e2 on e.managerId = e2.id
      group by 1, 2
      HAVING count(*) >= 5) t;

-- confirmation rate v1
select
    user_id,
    case
        when total = 0 then 0
        else round(confirmed::numeric / total::numeric, 2)
        end as confirmation_rate
from (
         select
             s.user_id,
             (select count(1) from confirmations c where c.user_id = s.user_id) as total,
             (select count(1) from confirmations c where c.user_id = s.user_id and c.action = 'confirmed') as confirmed
         from signups s
         group by 1) t


-- confirmation rate v2
select user_id,
       case
           when confirmation_rate is null then 0
           else confirmation_rate end
from (
         with total as (
             select user_id,
                    (select count(1) from confirmations where action = 'confirmed' and c.user_id = user_id) as confirmed,
     (select count(1) from confirmations where c.user_id = user_id) as total_req
    from confirmations c
)
select
    s.user_id,
    max(round(confirmed::numeric / total_req, 2)) as confirmation_rate
from signups s
         left join total t on t.user_id = s.user_id
group by 1);


-- monthly transactions
select
    final.month,
    case
        when final.country = 'unknown' then null
        else final.country end,
    final.trans_count,
    final.approved_count,
    final.trans_total_amount,
    final.approved_total_amount

from (
         with with_month as (
             select
                 t.*,
                 coalesce(country, 'unknown') as country_transformed,
                 TO_CHAR(trans_date, 'YYYY-MM') as month
         from transactions t
     )
select
    w2.month,
    w2.country_transformed as country,
    count(1) as trans_count,
    (select count(1) from with_month w where state = 'approved' and w.month = w2.month and w.country_transformed = w2.country_transformed) as approved_count,
    (select sum(amount) from with_month w where w.month = w2.month and w.country_transformed = w2.country_transformed) as trans_total_amount,
    (select coalesce(sum(amount), 0) from with_month w where state = 'approved' and w.month = w2.month and w.country_transformed = w2.country_transformed) as approved_total_amount
from with_month w2
group by 1, 2) final

