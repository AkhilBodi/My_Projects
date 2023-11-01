-- SET GLOBAL local_infile=TRUE;
-- LOAD DATA LOCAL INFILE
-- 'File Path'
-- INTO TABLE superstore.superstore_data
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES;

SELECT * FROM superstore_data;

SELECT EXTRACT(YEAR FROM ship_date)AS year, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) total_profit
FROM superstore_data
GROUP BY 1;

SELECT 
EXTRACT(YEAR FROM order_date) AS year,
CASE WHEN EXTRACT(MONTH FROM order_date) IN (1,2,3) THEN 'Q1'
	WHEN EXTRACT(MONTH FROM order_date) IN (4,5,6) THEN 'Q2'
    WHEN EXTRACT(MONTH FROM order_date) IN (7,8,9) THEN 'Q3'
    WHEN EXTRACT(MONTH FROM order_date) IN (10,11,12) THEN 'Q4' 
    END AS quarter,
ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit
FROM superstore_data
GROUP BY 1,2
ORDER BY 1,2;

SELECT region, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit
FROM superstore_data
GROUP BY 1
ORDER BY 3 DESC, 2 DESC;

SELECT region , ROUND((SUM(profit)/SUM(sales)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1
ORDER BY 2 DESC;

SELECT state, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

SELECT state, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1
ORDER BY 3 ASC
LIMIT 10;

SELECT city, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

SELECT city, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1
ORDER BY 3 ASC
LIMIT 10;

SELECT discount, ROUND(AVG(sales),2) AS avg_sales
FROM superstore_data
GROUP BY 1
ORDER BY 1;

SELECT category, ROUND(SUM(discount),2) AS total_discount
FROM superstore_data
GROUP BY 1
ORDER BY 2 DESC;

SELECT category,sub_category, ROUND(SUM(discount),2) AS total_discount
FROM superstore_data
GROUP BY 1,2
ORDER BY 3 DESC;

SELECT category, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1
ORDER BY 4 DESC;

SELECT region, category, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1,2
ORDER BY 5 DESC;

SELECT state, category, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1,2
ORDER BY 5 DESC;

SELECT state, category, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1,2
ORDER BY 5 ASC;

SELECT sub_category, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1
ORDER BY 4 DESC;

SELECT region, sub_category, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1,2
ORDER BY 5 DESC;

SELECT region, sub_category, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1,2
ORDER BY 5 ASC;

SELECT state, sub_category, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1,2
ORDER BY 5 DESC;

SELECT state, sub_category, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit, ROUND((SUM(sales)/SUM(profit)) * 100,2) AS profit_margin
FROM superstore_data
GROUP BY 1,2
ORDER BY 5 ASC;

SELECT * FROM superstore_data;

SELECT product_name, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit
FROM superstore_data
GROUP BY 1
ORDER BY 3 DESC;

SELECT product_name, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit
FROM superstore_data
GROUP BY 1
ORDER BY 3 ASC;

SELECT segment, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit
FROM superstore_data
GROUP BY 1 
ORDER BY 3 DESC;

SELECT COUNT(DISTINCT(customer_id)) AS total_customers
FROM superstore_data;

SELECT region,COUNT(DISTINCT(customer_id)) AS total_customers
FROM superstore_data
GROUP BY 1
ORDER BY 2 DESC;

SELECT state,COUNT(DISTINCT(customer_id)) AS total_customers
FROM superstore_data
GROUP BY 1
ORDER BY 2 DESC;

SELECT state,COUNT(DISTINCT(customer_id)) AS total_customers
FROM superstore_data
GROUP BY 1
ORDER BY 2 ASC;

SELECT customer_id, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit
FROM superstore_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

SELECT ROUND(AVG(ship_date - order_date),2) AS avg_shipping_time
FROM superstore_data;

SELECT ship_mode, ROUND(AVG(EXTRACT(DAY FROM ship_date) - EXTRACT(DAY FROM order_date)),1) * 10 AS avg_shipping_time
FROM superstore_data
GROUP BY 1
ORDER BY 2 ASC;

SELECT AVG(EXTRACT(DAY FROM ship_date) - EXTRACT(DAY FROM order_date))
FROM superstore_data
