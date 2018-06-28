-- ========================================================================
-- Student Name: Matt Goff
-- Date: 6/19/18

-- SQL Assignment
-- ========================================================================




-- ========================================================================
-- Question 1
-- ========================================================================
SELECT *
    FROM fact_order
        WHERE charge_amount > 500
        AND completed_at IS NOT null
    ORDER BY completed_at DESC

LIMIT 1

-- ========================================================================
-- Question 2
-- ========================================================================
SELECT
    DATE_TRUNC('week',fact_order.completed_at)  AS week
    ,SUM(charge_amount)                         AS gmv
    ,COUNT(*)                                   AS orders

    FROM fact_order

    JOIN zones ON fact_order.zone_id = zones.id
    JOIN regions ON zones.region_id = regions.id
    JOIN countries ON regions.country_id = countries.id

        WHERE countries.name = 'Canada'
        AND DATE_TRUNC('week',fact_order.completed_at) IS NOT null
    GROUP BY week
    ORDER BY week DESC

LIMIT 8
-- ========================================================================
-- Question 3
-- ========================================================================
--I need help on this one...
WITH age_groups AS (
SELECT
    CASE
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) < 20 then '0-20'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) BETWEEN 20 AND 30 then '20-30'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) BETWEEN 31 AND 40 then '31-40'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) BETWEEN 41 AND 50 then '41-50'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) BETWEEN 51 AND 60 then '51-60'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) > 60 then '61+'
    END as age_range
    ,COUNT(*) AS age_num

    FROM drivers
        WHERE drivers.active = 'true'
        AND drivers.birthday IS NOT null

    GROUP BY age_range
    ORDER BY age_range
    )

    SELECT
        age_range
        ,age_num/(SELECT SUM(age_num) FROM age_groups) * 100 AS percentage
            FROM age_groups

            ORDER BY age_range
-- ========================================================================
-- Question 4
-- ========================================================================
--This one too. Not sure how to join the shopper_metrics table here
WITH age_groups AS (
SELECT
    CASE
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) < 20 then '0-20'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) BETWEEN 20 AND 30 then '20-30'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) BETWEEN 31 AND 40 then '31-40'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) BETWEEN 41 AND 50 then '41-50'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) BETWEEN 51 AND 60 then '51-60'
        WHEN DATEDIFF(year,drivers.birthday,GETDATE()) > 60 then '61+'
    END as age_range
    ,COUNT(*) AS age_num

    FROM drivers
        WHERE drivers.active = 'true'
        AND drivers.birthday IS NOT null

    GROUP BY age_range
    ORDER BY age_range
    )

    SELECT
        age_range
        ,AVG(shopper_metrics.total_delivery_count)
        ,AVG(shopper_metrics.total_mpi)
            FROM age_groups
                JOIN shopper_metrics ON ????

            GROUP BY age_range
            ORDER BY age_range
-- ========================================================================
-- Question 5
-- ========================================================================
--Returned 0 results on this one... did I do this right?
SELECT
    drivers.id
    ,fact_batch.batch_id
    FROM drivers
            JOIN fact_batch ON drivers.id = fact_batch.shopper_id

        GROUP BY drivers.id, fact_batch.batch_id
        HAVING COUNT(drivers.id)>1
        OR COUNT(fact_batch.batch_id)>1
