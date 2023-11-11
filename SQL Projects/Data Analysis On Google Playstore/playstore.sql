-- USE play_store;
-- SET GLOBAL local_infile=TRUE;
-- LOAD DATA LOCAL INFILE
-- 'File Path'
-- INTO TABLE play_store.playstore_data
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES;

SELECT * FROM playstore_data;

-- Top 10 most popular apps (based on Installs).
	SELECT DISTINCT app, installs
	FROM playstore_data
	ORDER BY 2 DESC, 1
	LIMIT 10; 

-- Distribution of apps across different categories.
	SELECT category, COUNT(*) AS no_of_apps
	FROM playstore_data
	GROUP BY 1
	ORDER BY 2 DESC;
    
-- Average ratings of paid versus free apps.
	SELECT 
	CASE WHEN type = 'Paid' THEN 'Paid' ELSE 'Free' END AS app_type , ROUND(AVG(rating),2) avg_ratings
	FROM playstore_data
	GROUP BY 1;

-- Average rating for paid apps by category.
	SELECT DISTINCT category, AVG(rating) AS avg_rating
	FROM playstore_data
	WHERE type = 'Paid'
	GROUP BY 1
	ORDER BY 2 DESC;

-- Genres with the highest average rating for both free and paid apps.
	SELECT genre, type, AVG(rating) AS avg_rating
	FROM playstore_data
	GROUP BY 1,2
	ORDER BY 3 DESC;

-- Top 5 genres with the highest average app size.
	SELECT genre, CONCAT(ROUND(AVG(size_mb),2),' MB') AS avg_app_size
	FROM playstore_data
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5;

-- Average number of reviews for apps with a rating above 4.5
	SELECT CEIL(AVG(reviews)) AS avg_number_of_reviews
	FROM playstore_data
	WHERE rating > 4.5;
    
-- Top 5 genres with the highest proportion(installs) of paid apps.
	SELECT genre, COUNT(installs) AS no_of_apps
	FROM playstore_data
	WHERE type = 'Paid'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5;
    
-- Top 10 apps with the highest number of reviews relative to their number of installs.
	SELECT app, reviews/installs AS reviews_to_installs_ratio
	FROM playstore_data
	GROUP BY 1,2
	ORDER BY 2 DESC
	LIMIT 10;
    
-- Top 10 paid apps with the highest rating among apps with equal/over 100,000 installs.
	SELECT app, rating
	FROM playstore_data
	WHERE type = 'Paid'
	AND installs >= 100000
	ORDER BY 2 DESC, 1 ASC
	LIMIT 10;
    
-- Number of apps with content rating of 'Kids' in each genre
	SELECT genre, COUNT(*) AS number_of_apps
	FROM playstore_data
	WHERE content_rating = 'Kids'
	GROUP BY 1
	ORDER BY 2 DESC;
    
-- Average number of installs for apps in each category that have a content rating of 'Kids'.
	SELECT category,ROUND(AVG(installs)) AS avg_installs
	FROM playstore_data
	WHERE content_rating = 'Kids'
	GROUP BY 1
	ORDER BY 2 DESC;
    
-- Average rating for each content rating category.
	SELECT content_rating, ROUND(AVG(rating),2) AS avg_rating
	FROM playstore_data
	GROUP BY 1
	ORDER BY 2 DESC, 1 ASC;
    
-- Average price of apps for each category by each content rating
	SELECT category, content_rating, AVG(price_usd) AS avg_price_usd
	FROM playstore_data
	WHERE type = 'Paid'
	GROUP BY 1,2
	ORDER BY 3 DESC;
    
-- Genres with the highest average number of reviews for both free and paid apps.
	SELECT genre, type, ROUND(AVG(reviews)) AS avg_reviews
	FROM playstore_data
	GROUP BY 1,2
	ORDER BY 3 DESC;

-- Top 10 apps with the most significant increase in installs over the past year(2018).
	SELECT app, 
	SUM(CASE WHEN last_updated BETWEEN '2018/01/01' AND '2018/12/31' THEN installs ELSE 0 END) -
	SUM(CASE WHEN last_updated BETWEEN '2011/01/01' AND '2017/12/31' THEN installs ELSE 0 END) AS increase_in_installs
	FROM playstore_data
	GROUP BY 1
	ORDER BY 2 DESC, 1 ASC
    LIMIT 10;
    
-- Top 5 apps in each category with the highest percentage increase in the number of reviews over the last month(August/2018)
	WITH top_5 AS
	(SELECT category,
	SUM(CASE WHEN last_updated BETWEEN '2018/07/08' AND '2018/08/08' THEN reviews END)/
	NULLIF(SUM(CASE WHEN last_updated NOT BETWEEN '2018/07/08' AND '2018/08/08' THEN reviews END),0) * 100 AS reviews_increase
	FROM playstore_data
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5)

	SELECT category, ROUND(CONCAT(reviews_increase, " %"),2) AS reviews_increase_in_percent
	FROM top_5;
    
-- Top 5 categories with the highest number of installs per app in the last 6 months.
	WITH app_count AS
	(SELECT app, category,
	SUM(CASE WHEN last_updated BETWEEN '2018/02/08' AND '2018/08/08' THEN installs END) AS total_installs
	FROM playstore_data
	GROUP BY 1,2
	ORDER BY 3 DESC)

	SELECT category, SUM(total_installs) AS total_installs
	FROM app_count
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5;
    
-- Impact of app size of top 10 apps on the number of installs, taking into account different genre and content ratings.
	SELECT DISTINCT genre, content_rating, size_mb, SUM(installs) AS sum_of_installs -- In this query, size MB '0' refers to 'the size of the application varies with device'
	FROM playstore_data
	WHERE size_mb != 0
	GROUP BY 1,2,3
	ORDER BY 4 DESC
    LIMIT 10;
    
-- Top 10 apps with the highest review-to-installs ratio among apps with equal/over 5 million installs in both types.
	SELECT app, type, SUM(reviews)/SUM(installs) as ratio
	FROM playstore_data
	WHERE installs >= 5000000
	GROUP BY 1,2
	ORDER BY 3 DESC
	LIMIT 10;

-- Top 10 genres with the highest percentage increase in the average rating over the last year.
	SELECT DISTINCT genre, rating
	FROM playstore_data
	WHERE rating > (SELECT AVG(rating) FROM playstore_data WHERE last_updated BETWEEN '2016/08/03' AND '2017/08/02')
	AND last_updated BETWEEN '2017/08/03' AND '2018/08/03'
	ORDER BY 2 DESC
	LIMIT 10;

-- Apps with the longest streak of consecutive days with no updates.
	WITH ranked_apps AS
	(SELECT app,DATEDIFF((SELECT MAX(last_updated) FROM playstore_data), last_updated) AS days_last_updated,
	RANK() OVER(ORDER BY last_updated ASC) as rnk
	FROM playstore_data)

	SELECT * 
	FROM ranked_apps
	WHERE rnk <= 10;
    
-- Average number of installs per day for the top 10 apps.
	SELECT app, ROUND(AVG(installs/ DATEDIFF((SELECT MAX(last_updated) FROM playstore_data), last_updated))) AS avg_installs_per_day
	FROM (SELECT DISTINCT app,installs,last_updated 
			FROM playstore_data 
			ORDER BY installs DESC 
			LIMIT 10) sub1
	GROUP BY 1
	ORDER BY 2 DESC;