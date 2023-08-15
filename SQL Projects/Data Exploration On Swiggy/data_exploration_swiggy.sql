CREATE SCHEMA Swiggy;
USE Swiggy;
CREATE TABLE swiggy_data(
   restaurant_no   INTEGER  NOT NULL 
  ,restaurant_name VARCHAR(50) NOT NULL
  ,city            VARCHAR(9) NOT NULL
  ,address         VARCHAR(204)
  ,rating          NUMERIC(3,1) NOT NULL
  ,cost_per_person INTEGER 
  ,cuisine         VARCHAR(49) NOT NULL
  ,restaurant_link VARCHAR(136) NOT NULL
  ,menu_category   VARCHAR(66)
  ,item            VARCHAR(188)
  ,price           VARCHAR(12) NOT NULL
  ,veg_or_nonveg   VARCHAR(7)
);
-- LOAD DATA LOCAL INFILE
-- "Path"
-- INTO TABLE Swiggy.swiggy_data
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES;
-- show global variables like 'local_infile';
-- set global local_infile=true;
-- SET @@local.net_read_timeout=360;
Select * from Swiggy.swiggy_data;

-- Q1.
SELECT restaurant_name,COUNT(DISTINCT restaurant_name) AS high_rated_res_count FROM swiggy_data
WHERE rating > 4.5
GROUP BY restaurant_name;

-- Q2.
SELECT city, COUNT(DISTINCT restaurant_name) AS res_count FROM swiggy_data
GROUP BY city
ORDER BY res_count DESC
LIMIT 1;

-- Q3
SELECT restaurant_name,COUNT(DISTINCT restaurant_name) AS piz_name_count FROM swiggy_data
WHERE restaurant_name LIKE '%PIZZA%'
GROUP BY restaurant_name;

-- Q4
SELECT cuisine, COUNT(cuisine) AS cuisine_count FROM swiggy_data
GROUP BY cuisine
ORDER BY cuisine_count DESC
LIMIT 1;

-- Q5
SELECT city, AVG(rating) AS avg_rating FROM swiggy_data
GROUP BY city;

-- Q6
SELECT restaurant_name,menu_category,MAX(price) AS max_price FROM swiggy_data
WHERE menu_category LIKE 'RECOMMENDED'
GROUP BY restaurant_name,menu_category;

-- Q7
SELECT DISTINCT restaurant_name, MAX(cost_per_person) AS max_cost FROM swiggy_data
WHERE cuisine NOT LIKE'%INDIAN%'
GROUP BY restaurant_name
ORDER BY max_cost DESC,restaurant_name
LIMIT 5;

-- Q8
SELECT DISTINCT restaurant_name, cost_per_person FROM swiggy_data
WHERE cost_per_person > (SELECT AVG(cost_per_person) FROM swiggy_data);

-- Q9
SELECT distinct t1.restaurant_name,t1.city,t2.city
FROM swiggy_data t1
JOIN swiggy_data t2
ON t1.restaurant_name = t2.restaurant_name 
WHERE t1.city <> t2.city;

-- Q10
SELECT DISTINCT restaurant_name,COUNT(item) AS item_count FROM swiggy_data
WHERE menu_category = 'MAIN COURSE'
GROUP BY restaurant_name
ORDER BY item_count DESC
LIMIT 1;

-- Q11
SELECT DISTINCT restaurant_name,
(COUNT(CASE WHEN veg_or_nonveg = 'VEG' THEN 1 END)*100/count(*)) AS veg_percent
FROM swiggy_data
GROUP BY restaurant_name
HAVING veg_percent = 100
ORDER BY veg_percent;	

-- Q12
SELECT DISTINCT restaurant_name,AVG(price) AS avg_price FROM swiggy_data
GROUP BY restaurant_name
ORDER BY avg_price ASC
LIMIT 1;

-- Q13
SELECT DISTINCT restaurant_name,COUNT(DISTINCT menu_category) AS menu_category_count FROM swiggy_data
GROUP BY restaurant_name
ORDER BY menu_category_count DESC
LIMIT 5;

-- Q14
SELECT DISTINCT restaurant_name,
(COUNT(CASE WHEN veg_or_nonveg = 'Non-veg' THEN 1 END)*100/COUNT(*)) AS nonveg_percent
FROM swiggy_data
GROUP BY restaurant_name
ORDER BY nonveg_percent DESC 
LIMIT 1;
