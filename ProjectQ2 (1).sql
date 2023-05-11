
--1. find businesses in Las Vegas with valet parking, 5 stars, and open on Friday, ordered by business name:

-- Select the business name and review count from the businesses table

SELECT b.business_name, b.review_count
FROM Business b

-- Join the Business_location table to filter by city
JOIN Business_location bl ON   b.business_id = bl.business_id

-- Join the Business_parking_type table to filter by valet parking
JOIN Business_parking_type bpt ON b.business_id = bpt.business_id
JOIN Parking_type pt ON bpt.parking_type_id = pt.parking_type_id

-- Join the Business_hours table to filter by businesses open on Friday
JOIN Business_hours  bh ON b.business_id =bh.business_id
JOIN Day_of_week dow ON bh.day_id =  dow.day_id

WHERE bl.city_name = 'Las Vegas'
  AND pt.parking_type_description  = 'Valet'
  AND b.stars =5
  AND b.is_open ='1'
  AND dow.day_name ='Friday'
ORDER BY b.business_name ;


--=============================================================================
--2. find the top-10 businesses in California according to the number of stars, with business name and stars,
-- sorted in descending order by stars and business names in alphabetical order:

SELECT b.business_name, b.stars
FROM Business b

-- Join the Business_location table to filter by state
JOIN Business_location bl ON  b.business_id = bl.business_id
WHERE bl.state_name ='CA'

ORDER BY b.stars DESC , b.business_name
FETCH FIRST 10  ROWS ONLY ;

--=============================================================================

--7. For each state, find the number of distinct businesses having the tag "vegetarian". List the state name and the number of businesses
-- (state_name, business_count). Order by the number of businesses in descending order.


SELECT bl.state_name, COUNT(DISTINCT b.business_id) as business_count
FROM Business b

-- Join the Business_location table to group by state
JOIN Business_location bl ON  b.business_id = bl.business_id

--join the Business_has_categories and Business_categories tables to filter by vegetarian businesses
JOIN  Business_has_categories bhc  ON b.business_id = bhc.business_id
JOIN Business_categories bc ON bhc.category_id = bc.category_id

WHERE bc.category_name ='Vegetarian'
GROUP BY bl.state_name
ORDER BY business_count DESC;



--=============================================================================

--8. Find the minimum, maximum, mean, and median number of categories per business. Return 4 columns (min_categories, max_categories, mean_categories, median_categories).
SELECT MIN(cat_count) as min_categories,
       MAX(cat_count) as max_categories,
       AVG(cat_count) as mean_categories,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cat_count) as median_categories
FROM (
  SELECT b.business_id, COUNT(bhc.category_id) as cat_count
  FROM Business b
  --Join the Business_has_categories table to count categories per business
  JOIN Business_has_categories bhc  ON b.business_id = bhc.business_id
  GROUP BY b.business_id
);

--=============================================================================

--9. What is the maximum number of categories assigned to a business? Return one column "count".
SELECT MAX(cat_count)  as count
FROM (
  SELECT b.business_id, COUNT(bhc.category_id) as cat_count
  FROM Business b
  -- Join the Business_has_categories table to count categories per business
  JOIN Business_has_categories bhc ON b.business_id = bhc.business_id
  GROUP BY b.business_id
);

--=============================================================================

--10 How many businesses labeled as "Dry Cleaners" are open on the weekend? Return one column "count".

SELECT COUNT(DISTINCT b.business_id) as count
FROM Business b

-- Join the Business_has_categories and Business_categories tables to filter by Dry Cleaners
JOIN Business_has_categories bhc  ON b.business_id = bhc.business_id
JOIN Business_categories bc  ON bhc.category_id = bc.

-- Join the Busines_hours and Day_of_week tables to filter by businesses open on the weekend
JOIN Business_hours bh ON  b.business_id = bh.business_id
JOIN Day_of_week dow ON bh.day_id = dow.day_id

WHERE bc.category_name ='Dry Cleaners'
  AND dow.day_name IN ('Saturday', 'Sunday')
  AND b.is_open = '1' ;



--===================================================================================================================
--===================================================================================================================

--                                        Advanced insights

--===================================================================================================================
--===================================================================================================================


--=============================================================================
--1. find the  cities where all businesses work less than 5 days a week. List only the names of the cities (city_name) and sort the results in alphabetical order.

--query for cities with businesses working less than 5 days a week
SELECT   c.city_name
FROM Cities c
WHERE NOT EXISTS (
    --subquery to check for businesses working 5 or more days a week
    SELECT 1
    FROM Business b
    JOIN Business_location bl ON b.business_id = bl.business_id
    JOIN Business_hours bh ON b.business_id = bh.business_id
    WHERE bl.city_name =c.city_name
    GROUP BY b.business_id
    HAVING COUNT(DISTINCT bh.day_id) >=  5
)
ORDER BY c.city_name;




--=============================================================================
--2. find the top-10 states with the highest number of registered businesses. List only the state and the number of businesses (state_name, num_businesses) and sort the results in descending order according to the number of businesses.

--Query for top-10 states with the highest number of registered businesses
SELECT bl.state_name, COUNT(b.business_id) as num_businesses
FROM Business  b
JOIN Business_location bl ON b.business_id = bl.business_id
GROUP BY  bl.state_name
ORDER BY num_businesses DESC
FETCH FIRST 10 ROWS ONLY;



--=============================================================================
--7 Compute the diference between the average stars of businesses considered 'good for dinner' with a (1) "divey" and (2) an "upscale" ambience. Name the column of the result 'DIFFERENCE_OF_AVERAGES'.

--CTE for average stars of businesses with 'Divey' ambience
WITH Divey_Avg AS (
  SELECT AVG(b.stars) AS avg_divey
  FROM Business b
  JOIN Business_good_for_meal  bgfm ON b.business_id = bgfm.business_id
  JOIN Good_for_meal gfm  ON bgfm.good_for_meal_id = gfm.good_for_meal_id
  JOIN Business_ambiance ba ON b.business_id = ba.business_id
  JOIN Ambiance a ON ba.ambiance_id = a.ambiance_id
  WHERE gfm.good_for_meal_description ='Dinner' AND a.ambiance_description = 'Divey'
),

--CTE for average stars of businesses with 'Upscale' ambience
Upscale_Avg AS (
  SELECT AVG(b.stars) AS avg_upscale
  FROM Business b
  JOIN Business_good_for_meal bgfm ON b.business_id = bgfm.business_id
  JOIN Good_for_meal gfm ON bgfm.good_for_meal_id = gfm.good_for_meal_id
  JOIN Business_ambiance ba ON b.business_id = ba.business_id
  JOIN Ambiance a ON ba.ambiance_id = a.ambiance_id
  WHERE gfm.good_for_meal_description = 'Dinner' AND a.ambiance_description = 'Upscale'
)

-- Query to calculate the difference between the average stars of both categories
SELECT (avg_upscale - avg_divey) AS DIFFERENCE_OF_AVERAGES
FROM Divey_Avg, Upscale_Avg;


--=============================================================================
--8. Find the names of the cities that satisfy the following: the combined number of reviews for the top-100 (wrt to reviews) businesses in the city is at least double the combined number of reviews for the rest of the businesses in the city.
-- Return one column 'city'.


-- CTE for top-100 businesses' reviews in each city
WITH Top_100_Reviews  AS (
  SELECT bl.city_name, SUM(b.review_count) AS top_100_reviews
  FROM (
    SELECT business_id, review_count, city_name,
           ROW_NUMBER() OVER (PARTITION BY city_name ORDER BY review_count DESC) AS review_rank
    FROM Business b
    JOIN Business_location bl  ON b.business_id = bl.business_id
  ) ranked_businesses
  WHERE review_rank <=100
  GROUP BY city_name
),


--CTE for the rest of busineses' reviews in each city
Rest_Reviews AS (
  SELECT bl.city_name, SUM(b.review_count) AS rest_reviews
  FROM (
    SELECT business_id, review_count, city_name,
           ROW_NUMBER() OVER (PARTITION BY city_name ORDER BY review_count DESC) AS review_rank
    FROM Business b
    JOIN Business_location bl ON b.business_id = bl.business_id
  ) ranked_businesses
  WHERE review_rank > 100
  GROUP BY city_name
)

-- Query to find the cities satisfying the condition
SELECT t.city_name as city
FROM  Top_100_Reviews t
JOIN  Rest_Reviews r ON t.city_name = r.city_name
WHERE t.top_100_reviews >= 2 * r.rest_reviews;


--=============================================================================
--9. For each of the top-10 (in terms of number of reviews) businesses, find the top-3 reviewers: among those who reviewed the business,
-- the ones that have the three highest numbers of total reviews across all businesses. Return 3 columns: the business id (as business_id),
-- rank (1-3) of the top reviewer (as reviewer_rank) and the number of reviews made (as review_count). Order the results by business id in alphabetical order,
-- and then rank (1 - 3).


WITH Top_10_Businesses AS (
  -- CTE for top-10 businesses based on reviews
  SELECT business_id
  FROM  Business
  ORDER BY review_count DESC
  FETCH FIRST 10 ROWS ONLY
),

Reviewer_Reviews AS (
  -- CTE for total reviews of each reviewer who reviewed the top-10 businesses
  SELECT r.user_id, COUNT(*) AS review_count
  FROM Review r
  JOIN Top_10_Businesses  t ON r.business_id = t.business_id
  GROUP BY r.user_id
)

--query to find top-3 reviewers for each of the top-10 businesses
SELECT r.business_id,  ROW_NUMBER() OVER (PARTITION BY r.business_id ORDER BY rr.review_count DESC) AS reviewer_rank, rr.review_count
FROM Review r

JOIN Reviewer_Reviews rr ON r.user_id = rr.user_id
WHERE r.business_id IN (SELECT business_id FROM Top_10_Businesses)
AND ROW_NUMBER() OVER (PARTITION BY r.business_id ORDER BY rr.review_count DESC)<= 3
ORDER BY r.business_id, reviewer_rank;


--=============================================================================

--10. Find the city whose businesses have the lowest combined number of reviews;
-- only reviews from users with less than 3 friends should be taken into account. If there is a tie,
--choose the first city by alphabetical order. Return 2 columns, the number of reviews (as review_count) and the city name (as city_name).

--CTE for users with less than 3 friends
WITH Users_Less_Than_3_Friends AS (
  SELECT user_id
  FROM User
  WHERE friend_count < 3
),

-- CTE for reviews from users with less than 3 friends
Filtered_Reviews AS (
  SELECT r.business_id, r.user_id
  FROM Review  r

  JOIN Users_Less_Than_3_Friends u  ON r.user_id = u.user_id
),

-- CTE for the number of reviews in each city considering only the filtered reviews
City_Review_Counts AS (
  SELECT bl.city_name, COUNT(fr.business_id) as review_count
  FROM Filtered_Reviews fr

  JOIN Business_location bl ON fr.business_id = bl.business_id
  GROUP BY bl.city_name
)
-- query to find the city with the lowest combined number of reviews
SELECT MIN(review_count) as review_count,  city_name
FROM City_Review_Counts

WHERE review_count =(SELECT MIN(review_count)  FROM City_Review_Counts)
ORDER BY city_name
FETCH FIRST 1  ROWS ONLY;
