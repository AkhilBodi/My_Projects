set global local_infile=true;
USE music_store;
LOAD DATA LOCAL INFILE
'File Path'
INTO TABLE music_store.album
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- 1.1
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1;

-- 1.2
SELECT billing_country, COUNT(*) as count
FROM invoice
GROUP BY 1
ORDER BY 2 DESC;

-- 1.3
SELECT total FROM invoice
ORDER BY 1 DESC
LIMIT 3;

-- 1.4
SELECT billing_city AS city, SUM(total) AS sum_invoice_total
FROM invoice
GROUP BY 1
ORDER BY 2 DESC;

-- 1.5
SELECT c.customer_id,c.first_name, c.last_name, SUM(total) AS total
FROM customer c
JOIN invoice i
ON i.customer_id = c.customer_id
GROUP BY 1,2,3
ORDER BY 4 DESC;


-- 2.1
SELECT DISTINCT c.email, c.first_name, c.last_name, g.name AS genre
FROM customer c
JOIN invoice
ON invoice.customer_id = c.customer_id
JOIN invoice_line
ON invoice_line.invoice_id = invoice.invoice_id
JOIN track
ON track.track_id = invoice_line.track_id
JOIN genre g
ON g.genre_id = track.genre_id
WHERE g.name = 'ROCK'
ORDER BY email;

-- 2.2
SELECT a.name, COUNT(t.name) AS no_of_songs
FROM artist a
JOIN album
ON album.artist_id = a. artist_id
JOIN track t
ON t.album_id = album.id
WHERE t.genre_id = 
	(SELECT genre_id 
    FROM genre
    WHERE name = 'Rock')
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 2.3
SELECT name, milliseconds AS track_length_milliseconds
FROM track
WHERE milliseconds > 
	(SELECT AVG(milliseconds)
    FROM track)
ORDER BY 2 DESC;

-- 3.1
WITH t1 AS 
	(SELECT a.artist_id,a.name AS artist_name, SUM(i.unit_price*i.quantity) AS total_sales
	FROM artist a
	JOIN album
	ON album.artist_id = a.artist_id
	JOIN track
	ON track.album_id = album.id
	JOIN invoice_line i
	ON i.track_id = track.track_id
	GROUP BY 1,2
	ORDER BY 3 DESC
	LIMIT 1)

SELECT c.customer_id, c.first_name, c.last_name, t1.artist_name, SUM(i.unit_price*i.quantity) AS total_amt_spent
FROM customer c
JOIN invoice
ON invoice.customer_id = c.customer_id
JOIN invoice_line i
ON i.invoice_id = invoice.invoice_id
JOIN track
ON track.track_id = i.track_id
JOIN album
ON album.id = track.album_id
JOIN t1
ON t1.artist_id = album.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- 3.2
WITH t1 AS
	(SELECT c.country, g.genre_id, g.name, COUNT(i.quantity) AS purchases,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(i.quantity) DESC) AS rnk
	FROM customer c
	JOIN invoice
	ON invoice.customer_id = c.customer_id
	JOIN invoice_line i
	ON i.invoice_id = invoice.invoice_id
	JOIN track
	ON track.track_id = i.track_id
	JOIN genre g
	ON g.genre_id = track.genre_id
	GROUP BY 1,2,3
	ORDER BY 1,4 DESC)

SELECT * FROM t1
WHERE rnk =1;

-- 3.3
WITH t1 AS 
	(SELECT c.country, c.first_name, c.last_name,c.customer_id, ROUND(SUM(i.total)) AS total,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY SUM(i.total) DESC) AS rnk
	FROM customer c
	JOIN invoice i
	ON i.customer_id = i.customer_id
	GROUP BY 1,2,3,4
	ORDER BY 5 DESC, 1 ASC)

SELECT * FROM t1
WHERE rnk <=1;