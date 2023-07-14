USE malls;
SET sql_mode = '';

-- What are the distinct countries represented in the dataset?

SELECT DISTINCT country FROM mall_info;

-- What is the total number of malls in each country?

SELECT country, COUNT(mall_name) No_of_malls FROM mall_info
GROUP BY country
ORDER BY country;

-- What is the average area of the all the malls across each country?

SELECT country, ROUND(AVG(area_mt_square)) AVG_area_mt_sq, ROUND(AVG(area_sq_ft)) AVG_area_sq_ft FROM mall_info
GROUP BY country
ORDER BY country;


-- Which mall has the largest area in square feet?

SELECT mall_name, country, city, area_sq_ft FROM mall_info
ORDER BY area_sq_ft DESC
LIMIT 1;


-- Which is the oldest large mall in the world?

SELECT * FROM mall_info
ORDER BY yoe
LIMIT 1;


-- How many malls were established in each year?

SELECT yoe Year_of_establishment, COUNT(mall_name) No_of_malls FROM mall_info
GROUP BY yoe
ORDER BY yoe;


-- Which mall has the highest number of shops?

SELECT mall_name, country, city, shops FROM mall_info
WHERE shops = (SELECT MAX(shops) FROM mall_info);


-- How many malls have an area greater than 50,00,000 square meters?

SELECT COUNT(mall_name) No_of_malls FROM mall_info
WHERE area_sq_ft > 5000000;

/**************************************************************************************************************************************************/

-- Which city has the most malls?

SELECT city, COUNT(mall_name) No_of_malls FROM mall_info
GROUP BY city
ORDER BY No_of_malls DESC
LIMIT 1;


-- How many malls were established in each city?

SELECT city, COUNT(mall_name) No_of_malls FROM mall_info
GROUP BY city
ORDER BY city;


-- What is the percentage of malls in each country compared to the total?

WITH total_malls_cte(total_malls) AS
	(SELECT count(*) FROM mall_info)

SELECT m.country, COUNT(m.mall_name) No_of_malls, 
	CONCAT(ROUND((COUNT(m.mall_name)/ t.total_malls)*100, 2), ' %') Percentage_by_country
FROM mall_info m, total_malls_cte t
GROUP BY country
ORDER BY country;


-- How many malls were established in each decade?

SELECT decade Decade, COUNT(mall_name) No_of_malls FROM 
	(SELECT *, 
	CASE 
		WHEN yoe >= 1960 AND yoe < 1970 THEN '1960'
		WHEN yoe >= 1970 AND yoe < 1980 THEN '1970'
		WHEN yoe >= 1980 AND yoe < 1990 THEN '1980'
		WHEN yoe >= 1990 AND yoe < 2000 THEN '1990'
		WHEN yoe >= 2000 AND yoe < 2010 THEN '2000'
		WHEN yoe >= 2010 AND yoe < 2020 THEN '2010'
		WHEN yoe >= 2020 AND yoe < 2030 THEN '2020'
	END AS decade
	FROM mall_info) x
GROUP BY Decade
ORDER BY Decade;


-- What is the average number of shops in malls by country?

SELECT country , AVG(shops) AVG_shops FROM mall_info
GROUP BY country
ORDER BY country;


-- Which mall has the highest shop-to-area (meter square) ratio?

SELECT mall_name, ROUND((shops/area_mt_square)*100,2) Shops_to_area_ratio FROM mall_info
GROUP BY mall_name
ORDER BY Shops_to_area_ratio DESC
LIMIT 1;


-- How many malls were established in the last five years?

SELECT COUNT(*) No_of_malls FROM
	(SELECT mall_name, yoe, (EXTRACT(YEAR FROM SYSDATE()) - YOE) Age_years FROM mall_info
	WHERE (EXTRACT(YEAR FROM SYSDATE()) - YOE) < 6) X;


/**************************************************************************************************************************************************/

-- How many malls have an area larger than the average area (m²) of all malls?

SELECT count(*) FROM
	(SELECT mall_name, area_mt_square Area, 
	round(AVG(area_mt_square) OVER(), 2) Avg_area FROM mall_info) x
WHERE Area > Avg_area;


-- What is the average area(m²) per shop in each country?

SELECT country, area_mt_square, shops, CONCAT(ROUND(AVG(area_mt_square/shops), 2), ' m²') Avg_area_per_shop
FROM mall_info
GROUP BY country
ORDER BY country;


-- How many malls have an area larger than the average area of malls in their respective countries?

SELECT country, COUNT(*) No_of_malls FROM
	(SELECT country, area_mt_square Area, 
	round(AVG(area_mt_square) OVER(PARTITION BY country ORDER BY country), 2) Avg_area FROM mall_info) x
WHERE Area > AVG_area
GROUP BY country;


-- What is the rank of each mall based on its area compared to other malls globally?

SELECT mall_name, area_mt_square,
DENSE_RANK() OVER(ORDER BY area_mt_square DESC) rank_no
FROM mall_info;


-- Which country has the 2nd highest number of total shops inside the malls?

SELECT * FROM
	(SELECT country, Total_shops, 
	DENSE_RANK() OVER(ORDER BY Total_shops DESC) rnk_shops FROM
		(SELECT country, SUM(shops) Total_shops
		FROM mall_info
		GROUP BY country) x) xx
WHERE rnk_shops = 2;


-- How many pairs of malls have similar areas but are located in different countries?

SELECT count(*) FROM
	(SELECT DISTINCT m.mall_name mall1, i.mall_name mall2, m.country country1, i.country country2, m.area_sq_ft area FROM mall_info m
	JOIN mall_info i
	ON m.area_sq_ft = i.area_sq_ft AND m.country < i.country
	ORDER BY m.mall_name) x;
