+-- ========================================================================
+-- Student Name: Michael Prescott
+-- Date: 2018-06-12
+
+-- SQL Assignment
+-- ========================================================================
+
+
+
+
+-- ========================================================================
+-- Question 1 - Find the most recent completed order where the basket size was > $500.
+-- ========================================================================
+
+SELECT *
+
+FROM fact_order
+
+WHERE completed_at is not NULL
+AND charge_amount > 500
+
+ORDER BY completed_at DESC
+LIMIT 1
+
+-- ========================================================================
+-- Question 2 - What GMV have we generated, how many orders were made per week in the last 8 weeks in Canada?
+-- ========================================================================
+
+SELECT
+    DATE_TRUNC('week', fo.created_at) as date
+    , COUNT(DISTINCT fo.id) as OrderCount
+    , SUM(fo.charge_amount) as GMV
+
+FROM
+    fact_order fo
+LEFT JOIN zones z on fo.zone_id = z.id
+LEFT JOIN regions r on r.id = z.region_id
+LEFT JOIN countries c on c.id = r.country_id
+
+WHERE c.name LIKE 'Canada'
+AND fo.created_at > DATEADD('week',-8,DATE_TRUNC('week',getdate()))
+-- AND fo.created_at < DATE_TRUNC('week',getdate()) --Include this line to add this week's current OrderCount and GMV
+GROUP BY 1
+ORDER BY 1 desc
+
+-- ========================================================================
+-- Question 3 - What percentage of our active shoppers are in each age range?
+-- ========================================================================
+
+SELECT
+    CASE WHEN FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) <= 20 THEN '-20'
+        WHEN FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) > 20 and FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) <= 30 THEN '20-30'
+        WHEN FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) > 30 and FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) <= 40 THEN '30-40'
+        WHEN FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) > 40 and FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) <= 50 THEN '40-50'
+        WHEN FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) > 50 and FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) <= 60 THEN '50-60'
+        WHEN FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) > 60 THEN '60+'
+        ELSE NULL
+    END AS AgeRange
+    , ROUND((COUNT(distinct id) * 100)::numeric / (SELECT COUNT(distinct id) FROM drivers WHERE active in ('true') AND birthday is NOT NULL)::numeric,2)
+FROM drivers
+WHERE active in ('true')
+AND birthday is not NULL
+GROUP BY 1
+
+-- ========================================================================
+-- Question 4
+-- ========================================================================
+
+with shopper_age AS
+(
+SELECT id, FLOOR(ROUND(DATEDIFF('day',birthday,getdate()) / 365 ,2)) as age
+FROM drivers
+WHERE active in ('true')
+AND birthday is not NULL
+)
+
+SELECT
+    CASE WHEN age <= 20 THEN '-20'
+        WHEN age > 20 and age <= 30 THEN '20-30'
+        WHEN age > 30 and age <= 40 THEN '30-40'
+        WHEN age > 40 and age <= 50 THEN '40-50'
+        WHEN age > 50 and age <= 60 THEN '50-60'
+        WHEN age > 60 THEN '60+'
+        ELSE NULL
+    END AS AgeRange
+    , AVG(total_deliveries_count) as AverageDeliveriesCount
+    , AVG(total_mpi) as AverageMPI
+FROM shopper_metrics sm
+INNER JOIN shopper_age sa on sm.shopper_id = sa.id
+GROUP BY 1
+ORDER BY 3 DESC
+
+-- ========================================================================
+-- Question 5
+-- ========================================================================
+
+-- Query for duplicate driver IDs
+SELECT
+    id
+    , COUNT(id)
+FROM drivers
+GROUP BY 1
+HAVING COUNT(id) > 1
+ORDER BY 2 DESC
+LIMIT 10
+
+-- There are no duplicate driver IDs, as this is the Primary Key for the drivers table
+
+--Query for duplicate batch_ids
+SELECT
+    batch_id
+    , COUNT(batch_id)
+FROM fact_batch
+GROUP BY 1
+HAVING COUNT(batch_id) > 1
+ORDER BY 2 DESC
+LIMIT 10
+
+-- There are duplicate batch_ids. Appears that a new row is created whenever a new user (admin) adjusts the batch
+
+-- ========================================================================
+-- Bonus Questions
+-- ========================================================================
+
+-- 1.
+SELECT
+    *
+    , 'https://admin.instacart.com/admin/customers/' || id AS link
+FROM users
+WHERE email LIKE '<my_email>'
+
+-- RESULT: https://admin.instacart.com/admin/customers/22814892 -- Thats me!
+
+-- 2.
+SELECT
+    COUNT(distinct o.id)
+FROM orders o
+INNER JOIN users u on o.user_id = u.id
+WHERE u.id = 22438411
+
+-- RESULT: 32, but it could change if he places another
+
+-- 3.
+SELECT
+    *
+FROM orders
+WHERE total > 500
+ORDER BY created_at DESC
+LIMIT 1
+
+-- RESULT: Varies depending on when the query is run!
+
+-- 4.
+SELECT
+    COUNT(distinct id)
+FROM order_deliveries
+WHERE warehouse_id = 1000
+AND delivered_at > dateadd('day',-1,getdate())
+
+-- RESULT: None! Makes sense as we use the Garden for testing
+
+-- 5.
+SELECT
+    first_name || ' ' || last_name AS Name
+    , phone
+    , email
+FROM order_deliveries od
+INNER JOIN orders o on o.id = od.order_id
+INNER JOIN users u on u.id = o.user_id
+WHERE warehouse_id = 1000
+AND od.workflow_state IN ('delivered')
+ORDER BY od.updated_at ASC
+LIMIT 10
+
+-- RESULT: Private info!
+
+-- ========================================================================
+-- Thats all folks!
+-- ========================================================================
