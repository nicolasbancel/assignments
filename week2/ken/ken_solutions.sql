
-- ========================================================================
-- Student Name:Ken Weed
-- Date:6/12/2018

-- SQL Assignment
-- ========================================================================


-- ========================================================================
-- Question 1
-- ========================================================================

SELECT * FROM fact_order 
where charge_amount > 500
AND completed_at is NOT null
order by completed_at desc
limit 1

-- ========================================================================
-- Question 2
-- ========================================================================


select co.name, fo.country_id, date_trunc('week', fo.created_at) as WEEK, COUNT(DISTINCT fo.id) as OrderCount, sum(fo.charge_amount) as GMV_Per_Week 
from fact_order fo
join countries co
on fo.country_id = co.id
where co.name ilike 'Canada%'
and fo.created_at > DATEADD('week', -8, GETDATE())
group by 1, 2, 3
order by 3 desc
limit 8

-- ========================================================================
-- Question 3
-- ========================================================================
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
-- ========================================================================
-- Question 4
-- ========================================================================

with age_plus_deliveries as (
select d.id,
sm.total_deliveries_count,
sm.total_mpi,
DATEDIFF (year, d.birthday, GETDATE()) as age,
case when DATEDIFF(year, birthday, GETDATE()) < 20 then '0-20'
when DATEDIFF(year, d.birthday, GETDATE()) between 20 and 30 then '20-30'
when DATEDIFF(year, d.birthday, GETDATE()) between 30 and 40 then '30-40'
when DATEDIFF(year, d.birthday, GETDATE()) between 40 and 50 then '40-50'
when DATEDIFF(year, d.birthday, GETDATE()) between 50 and 60 then '50-60'
when DATEDIFF(year, d.birthday, GETDATE()) > 60 then '60+' end as age_range
from drivers d
left join shopper_metrics sm 
on d.id = sm.shopper_id
where active = true
and birthday is not null 
) 



SELECT avg(total_deliveries_count) as average_deliveries,
avg(total_mpi) as average_mpi, 
age_range
FROM age_plus_deliveries
group by age_range
order by avg(total_mpi) desc 
-- ========================================================================
-- Question 5

--No duplicate drivers


--SELECT id, COUNT(id)  
--FROM drivers
--GROUP BY id
--HAVING COUNT(id) > 1

SELECT batch_id, COUNT(batch_id) AS batch_count
FROM fact_batch
GROUP BY batch_id
HAVING COUNT(batch_id) > 1
order by 2 desc
limit 10
-- ========================================================================