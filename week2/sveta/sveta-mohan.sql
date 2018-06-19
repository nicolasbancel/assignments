question 1

select charge_amount, completed_at
from fact_order
where completed_at is not null
and charge_amount > 500
order by completed_at desc
limit 10


________________________________________________

question 2

select co.name, fo.country_id, date_trunc('week', fo.created_at) as orders_made,
sum(fo.charge_amount) as weekly_gmv
from fact_order fo
join countries co
on fo.country_id = co.id
where co.name ilike 'Canada%'
and fo.created_at > DATEADD('week', -8, GETDATE())
group by 1, 2, 3
order by 3 desc
limit 8

______________________________________________

question 3


select age_range, 100 * age_count/total as percentage
from
(select
case when DATEDIFF(year, birthday, GETDATE()) < 20 then '0-20'
when DATEDIFF(year, birthday, GETDATE()) between 20 and 30 then '20-30'
when DATEDIFF(year, birthday, GETDATE()) between 30 and 40 then '30-40'
when DATEDIFF(year, birthday, GETDATE()) between 40 and 50 then '40-50'
when DATEDIFF(year, birthday, GETDATE()) between 50 and 60 then '50-60'
when DATEDIFF(year, birthday, GETDATE()) > 60 then '60+' end as age_range,
count(id) as age_count,
SUM(count(id)) OVER () AS total
from drivers
where active = true
and birthday is not null
group by 1
) as age_distribution
order by age_range


------------------------------------------------------------------
question 4


with age_plus_deliveries as (
select d.id,
si.total_deliveries_count,
si.total_mpi,
DATEDIFF(year, d.birthday, GETDATE()) as age,
case when DATEDIFF(year, d.birthday, GETDATE()) < 20 then '0-20'
when DATEDIFF(year, d.birthday, GETDATE()) between 20 and 30 then '20-30'
when DATEDIFF(year, d.birthday, GETDATE()) between 30 and 40 then '30-40'
when DATEDIFF(year, d.birthday, GETDATE()) between 40 and 50 then '40-50'
when DATEDIFF(year, d.birthday, GETDATE()) between 50 and 60 then '50-60'
when DATEDIFF(year, d.birthday, GETDATE()) > 60 then '60+' end as age_range
from drivers d
left join shopper_metrics si
on d.id = si.shopper_id
where birthday is not null
and active = true
)

select avg(total_deliveries_count) as average_deliveries,
avg(total_mpi) as average_mpi,
age_range
from age_plus_deliveries
group by age_range
order by avg(total_mpi) desc


----------------------------------------------------------
question 5

select  d.id, count(d.id) as number_of_occurances
from drivers d
left join fact_batch fb
on fb.shopper_id = d.id
group by d.id
having count(d.id) > 1
order by count(d.id) desc
limit 10 
