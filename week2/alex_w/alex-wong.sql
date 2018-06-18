-- ========================================================================
-- Student Name: Alex Wong
-- Date: 6/17/18

-- SQL Assignment
-- ========================================================================




-- ========================================================================
-- Question 1
-- ========================================================================

SELECT id, charge_amount, created_at
FROM fact_order
WHERE completed_at IS NOT NULL
AND charge_amount > 500.00
ORDER BY created_at desc
LIMIT 1

-- ========================================================================
-- Question 2
-- ========================================================================

SELECT SUM(fo.charge_amount) GMV,
    COUNT(distinct fo.id) order_count,
    DATE_TRUNC('week', fo.created_at) week
FROM fact_order fo
JOIN zones z
    ON z.id = fo.zone_id
JOIN regions r
    ON z.region_id = r.id
JOIN countries c
    ON c.id = r.country_id
WHERE c.id = 124
AND fo.created_at > now() - interval'8 weeks'
GROUP BY 3
ORDER BY 3 DESC

-- ========================================================================
-- Question 3
-- ========================================================================

with data AS (SELECT id,
                CASE WHEN age BETWEEN 0 AND 20 THEN '0-20'
                    WHEN age BETWEEN 20 AND 30 THEN '20-30'
                    WHEN age BETWEEN 30 AND 40 THEN '30-40'
                    WHEN age BETWEEN 40 AND 50 THEN '40-50'
                    WHEN age BETWEEN 50 AND 60 THEN '50-60'
                    ELSE '60+' END AS age_range
                FROM (SELECT id,
                        DATEDIFF(year, birthday, now()) as age
                        FROM drivers
                        WHERE active = 'Y'
                        AND birthday IS NOT NULL)
                GROUP BY 1,2
                ORDER BY 1,2 ASC),

num AS (SELECT age_range, COUNT(*) as num_shopper
        FROM data
        GROUP BY 1),

total_num AS ( SELECT SUM(num_shopper) as total
                FROM num)

SELECT n.age_range, (CAST(num_shopper AS float) / CAST(total AS float)) * 100
FROM num n
JOIN (SELECT distinct age_range, (SELECT total FROM total_num) as total
    FROM data) co
ON co.age_range = n.age_range
GROUP BY 1, 2
ORDER BY 1 ASC

-- ========================================================================
-- Question 4
-- ========================================================================

SELECT
    CASE WHEN DATEDIFF(year, d.birthday, now()) <= 20 THEN '0-20'
        WHEN DATEDIFF(year, d.birthday, now()) > 20 AND DATEDIFF(year, d.birthday, now()) <= 30 THEN '20-30'
        WHEN DATEDIFF(year, d.birthday, now()) > 30 AND DATEDIFF(year, d.birthday, now()) <= 40 THEN '30-40'
        WHEN DATEDIFF(year, d.birthday, now()) > 40 AND DATEDIFF(year, d.birthday, now()) <= 50 THEN '40-50'
        WHEN DATEDIFF(year, d.birthday, now()) > 50 AND DATEDIFF(year, d.birthday, now()) <= 60 THEN '50-60'
        ELSE '60+' END AS age_range,
    AVG(s.total_deliveries_count) avg_total_delieves,
    AVG(s.total_mpi) avg_total_mpi
FROM drivers d
JOIN shopper_metrics s
    ON s.shopper_id = d.id
WHERE active = 'Y'
AND birthday IS NOT NULL
GROUP BY 1
ORDER BY 1 ASC

-- ========================================================================
-- Question 5
-- ========================================================================

SELECT batch_id, COUNT(*) as count_instances
FROM fact_batch
GROUP BY 1
HAVING COUNT(*) > 1
LIMIT 10
