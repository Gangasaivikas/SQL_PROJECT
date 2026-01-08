CREATE DATABASE RestaurantConsumer_DB;

USE RestaurantConsumer_DB;

-- CREATING CONSUMERS TABLE 

CREATE TABLE CONSUMERS (
    CONSUMER_ID VARCHAR(10) PRIMARY KEY,
    CITY VARCHAR(20),
    STATE VARCHAR(20),
    COUNTRY VARCHAR(10) DEFAULT 'MEXICO',
    LATITUDE DECIMAL(10 , 5 ),
    LONGITUDE DECIMAL(10 , 5 ),
    SMOKER VARCHAR(10),
    DRINK_LEVEL VARCHAR(20),
    TRANSPORTATION_METHOD VARCHAR(20),
    MARITAL_STATUS VARCHAR(10),
    CHILDREN VARCHAR(20),
    AGE INT,
    OCCUPATION VARCHAR(20),
    BUDGET VARCHAR(20)
);

 


-- CREATE CONSUMERS_PREFERENCES

CREATE TABLE consumers_preferences (
    CONSUMER_ID VARCHAR(10),
    Preferred_Cuisine VARCHAR(20),
    FOREIGN KEY (CONSUMER_ID)
        REFERENCES CONSUMERS (CONSUMER_ID)
);

SELECT 
    *
FROM
    CONSUMERS_PREFERENCES;


-- RESTAURANTS

CREATE TABLE Restaurants (
    Restaurant_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    CITY VARCHAR(30),
    STATE VARCHAR(50),
    COUNTRY VARCHAR(50),
    ZIP_CODE VARCHAR(10),
    LATITUDE DECIMAL(9,6),
    LONGITUDE DECIMAL(9,6),
    ALCOHOL_SERVICE VARCHAR(20),
    SMOKING_ALLOWED VARCHAR(20),
    PRICE VARCHAR(20),
    Franchise VARCHAR(20),
    Area VARCHAR(20),
    PARKING VARCHAR(20)
);



SELECT 
    COUNT(*)
FROM
    RESTAURANTS;
    
-- RESTAURANT_CUISINES

CREATE TABLE restaurant_cuisines (
    Restaurant_ID INT,
    Cuisine VARCHAR(30),
    FOREIGN KEY (Restaurant_ID)
        REFERENCES Restaurants (Restaurant_ID)
);


SELECT 
    COUNT(*)
FROM
    restaurant_cuisines;

-- RATINGS

CREATE TABLE RATINGS (
    Consumer_ID VARCHAR(20),
    Restaurant_ID INT,
    Overall_Rating INT,
    Food_Rating INT,
    Service_Rating INT,
    FOREIGN KEY (Restaurant_ID)
        REFERENCES Restaurants (Restaurant_ID),
        FOREIGN KEY (Consumer_ID)
        REFERENCES CONSUMERS (Consumer_ID)
);



SELECT 
    COUNT(*)
FROM
    RATINGS;
    
    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM CONSUMERS;
--
SELECT * FROM CONSUMERS_PREFERENCES;
-- 
SELECT * FROM RESTAURANTS;
--
SELECT * FROM restaurant_cuisines;
-- 
SELECT * FROM RATINGS;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Objective: 
 
-- Using the WHERE clause to filter data based on specific criteria.

-- 1. List all details of consumers who live in the city of 'Cuernavaca'.

SELECT 
    *
FROM
    CONSUMERS
WHERE
    CITY = 'Cuernavaca';

-- 2. Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.

SELECT 
    CONSUMER_ID, AGE, OCCUPATION, SMOKER
FROM
    CONSUMERS
WHERE
    (OCCUPATION = 'STUDENT')
        AND (SMOKER = 'Yes');

-- 3. List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level.

SELECT NAME, CITY, ALCOHOL_SERVICE,PRICE FROM RESTAURANTS WHERE ( ALCOHOL_SERVICE = 'Wine & Beer') AND (PRICE = 'MEDIUM');

-- 4. Find the names and cities of all restaurants that are part of a 'Franchise'. 

SELECT NAME,CITY,FRANCHISE FROM RESTAURANTS WHERE FRANCHISE='Yes';

-- 5. Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory' (which corresponds to a value of 2, according to the data dictionary)

SELECT CONSUMER_ID,RESTAURANT_ID,OVERALL_RATING  AS  'Highly Satisfactory' FROM RATINGS WHERE OVERALL_RATING = 2;


SELECT CONSUMER_ID,RESTAURANT_ID,OVERALL_RATING  FROM RATINGS WHERE OVERALL_RATING = 2 ;

-- Questions JOINs with Subqueries

-- 1. List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.
SELECT distinct R.NAME,R.CITY,O.OVERALL_RATING
FROM RESTAURANTS R 
INNER JOIN RATINGS O 
ON R.RESTAURANT_ID=O.RESTAURANT_ID
WHERE O.OVERALL_RATING=2;

-- 2. Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'. 
       
SELECT 
    distinct C.CONSUMER_ID, C.AGE
FROM
    CONSUMERS C
        INNER JOIN
    RATINGS R ON C.CONSUMER_ID = R.CONSUMER_ID
        INNER JOIN
    RESTAURANTS S ON R.RESTAURANT_ID = S.RESTAURANT_ID
WHERE
    C.CITY = 'San Luis Potosi';
    
    
-- 3. List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'. 

SELECT distinct  S.CONSUMER_ID,R.NAME,C.CUISINE FROM RESTAURANTS R 
INNER JOIN RESTAURANT_CUISINES C  
ON R.RESTAURANT_ID = C.RESTAURANT_ID
INNER JOIN RATINGS S  
ON R.RESTAURANT_ID = S.RESTAURANT_ID
WHERE 
(S.CONSUMER_ID = 'U1001') AND (CUISINE = 'Mexican');

-- 4. Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget. 

SELECT C.*
FROM CONSUMERS C  
INNER JOIN CONSUMERS_PREFERENCES P   
ON C.CONSUMER_ID = P.CONSUMER_ID
WHERE 
(P.PREFERRED_CUISINE = 'American') AND (C.BUDGET = 'Medium');

-- 5. List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.

SELECT DISTINCT
    R.NAME, R.CITY
FROM
    RESTAURANTS R
        INNER JOIN
    RATINGS S ON R.RESTAURANT_ID = S.RESTAURANT_ID
WHERE
    S.FOOD_RATING < (SELECT 
            AVG(FOOD_RATING)
        FROM
            RATINGS S);
            
-- 6. Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but have NOT rated any restaurant that serves 'Italian' cuisine.

SELECT C.CONSUMER_ID,C.AGE,C.OCCUPATION FROM CONSUMERS C 
INNER JOIN RATINGS R 
ON C.CONSUMER_ID = R.CONSUMER_ID 
WHERE C.CONSUMER_ID NOT IN (SELECT RE.CONSUMER_ID FROM RATINGS RE
INNER JOIN restaurant_cuisines RS
ON RS.RESTAURANT_ID = RE.RESTAURANT_ID
WHERE RS.CUISINE = 'Italian');


SELECT CONSUMER_ID, AGE, OCCUPATION
FROM CONSUMERS
WHERE CONSUMER_ID IN (
    SELECT CONSUMER_ID
    FROM RATINGS
)
AND CONSUMER_ID NOT IN (
    SELECT R.CONSUMER_ID
    FROM RATINGS R
    WHERE R.RESTAURANT_ID IN (
        SELECT RC.RESTAURANT_ID
        FROM RESTAURANT_CUISINES RC
        WHERE RC.CUISINE = 'Italian'
    )
);



-- 7. List restaurants (Name) that have received ratings from consumers older than 30.
 
 SELECT DISTINCT NAME FROM RESTAURANTS RE
 INNER JOIN RATINGS R
 ON RE.RESTAURANT_ID = R.RESTAURANT_ID WHERE R.CONSUMER_ID IN
 (SELECT CONSUMER_ID FROM CONSUMERS WHERE AGE > 30);
 
 
 -- 8. Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and 
 -- who have given an Overall_Rating of 0 to at least one restaurant (any restaurant). 
 
SELECT DISTINCT C.CONSUMER_ID,C.OCCUPATION 
FROM CONSUMERS C 
INNER JOIN CONSUMERS_PREFERENCES P
ON C.CONSUMER_ID = P.CONSUMER_ID
INNER JOIN RATINGS R 
ON C.CONSUMER_ID = R.CONSUMER_ID
WHERE P.Preferred_Cuisine = 'Mexican'  AND 
R.OVERALL_RATING = 0;

-- 9. List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city 
-- where at least one 'Student' consumer lives. 

SELECT DISTINCT R.NAME,R.CITY FROM RESTAURANTS R
INNER JOIN restaurant_cuisines RC
ON R.RESTAURANT_ID = RC.RESTAURANT_ID 
INNER JOIN CONSUMERS C 
ON C.CITY = R.CITY
WHERE RC.CUISINE = 'Pizzeria'AND C.OCCUPATION = 'STUDENT';

-- 10. Find consumers (Consumer_ID, Age) who are 'Social Drinkers' 
-- and have rated a restaurant that has 'No' parking.

SELECT DISTINCT C.CONSUMER_ID,C.AGE,C.DRINK_LEVEL 
FROM CONSUMERS C
INNER JOIN  RATINGS R
ON R.CONSUMER_ID = C.CONSUMER_ID
INNER JOIN restaurants rt
ON  rt.restaurant_id = r.restaurant_id
where C.DRINK_LEVEL = 'Social Drinker' AND RT.PARKING = 'NONE';

-----------------------------------------------------------------------------------------------------------------------

-- Questions Emphasizing WHERE Clause and Order of Execution 

-- 1. List Consumer_IDs and the count of restaurants they've rated, but only for consumers who 
 -- are 'Students'. Show only students who have rated more than 2 restaurants.
 
 
 SELECT C.CONSUMER_ID,COUNT(R.RESTAURANT_ID) AS COUNT_RES
 FROM CONSUMERS C
 INNER JOIN  RATINGS R
 ON C.CONSUMER_ID = R.CONSUMER_ID
 WHERE OCCUPATION = 'STUDENT'
 GROUP BY C.CONSUMER_ID
 HAVING COUNT(R.RESTAURANT_ID) > 2;
 
-- 2. We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 
-- 10 (integer division). List the Consumer_ID, Age, and this calculated Engagement_Score, but 
-- only for consumers whose Engagement_Score would be exactly 2 and who use 'Public' 
-- transportation.

SELECT Consumer_ID,Age, AGE DIV 10 AS Engagement_Score
FROM CONSUMERS
WHERE TRANSPORTATION_METHOD = 'PUBLIC'
AND  AGE DIV 10 = 2;

-- 3) For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name, 
-- City, and its calculated average Overall_Rating, but only for restaurants located in 
-- 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.

SELECT R.Name,R.CITY,AVG(RE.OVERALL_RATING) AS AVG_OVERALL_RATINGS
FROM restaurantS R 
INNER JOIN RATINGS RE
ON R.restaurant_ID = RE.restaurant_ID
WHERE R.CITY = 'Cuernavaca'
GROUP BY R.NAME
HAVING AVG_OVERALL_RATINGS > 1.0;

-- 4. Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any 
-- restaurant is equal to their Service_Rating for that same restaurant, but only consider ratings 
-- where the Overall_Rating was 2. 

SELECT distinct C.Consumer_ID,C.Age FROM CONSUMERS C
INNER JOIN RATINGS R 
ON C.CONSUMER_ID = R.CONSUMER_ID
WHERE C.MARITAL_STATUS = 'MARRIED' AND R.Food_Rating = R.Service_Rating AND R.Overall_Rating = 2;

-- 5. List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers 
-- who are 'Employed' and have given a Food_Rating of 0 to at least one restaurant located in 
-- 'Ciudad Victoria'.

SELECT C.CONSUMER_ID,C.AGE,R.NAME FROM 
CONSUMERS C 
INNER JOIN RATINGS RT
ON C.CONSUMER_ID = RT.CONSUMER_ID
INNER JOIN restaurantS R
ON R.restaurant_ID = RT.restaurant_ID
WHERE C.OCCUPATION = 'EMPLOYED' AND RT.FOOD_RATING = 0 AND R.CITY = 'Ciudad Victoria';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PRACTICE

SELECT COUNT(*) FROM
(SELECT RESTAURANT_ID,MAX(OVERALL_RATING) AS MAX_RATING FROM RATINGS
GROUP BY RESTAURANT_ID ) AS MAXP
WHERE MAX_RATING > 1;

WITH MP AS
(SELECT RESTAURANT_ID,MAX(OVERALL_RATING) AS MAX_RATING FROM RATINGS
GROUP BY RESTAURANT_ID
HAVING MAX_RATING > 1) 
SELECT COUNT(*) FROM MP;




SELECT *
FROM stock_prices;
 WITH RECURSIVE my_dates (dt) AS (SELECT '2024-06-01'
UNION ALL
SELECT dt + INTERVAL 1 DAY FROM my_dates
WHERE dt < '2024-06-06')
SELECT * FROM my_dates;


-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures.

-- 1. Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, 
-- Age, and the Name of any Mexican restaurant they have rated with an Overall_Rating of 2. 

WITH C_NAME AS(select CONSUMER_ID,AGE FROM CONSUMERS WHERE STATE = 'San Luis Potosi'),
		R_C AS (SELECT RESTAURANT_ID FROM restaurant_cuisines WHERE CUISINE = 'Mexican')

SELECT C.CONSUMER_ID,C.AGE,R.NAME 
FROM C_NAME C 
INNER JOIN RATINGS RT
ON RT.CONSUMER_ID = C.CONSUMER_ID
INNER JOIN RESTAURANTS R 
ON R.RESTAURANT_ID = RT.RESTAURANT_ID
INNER JOIN R_C RC
ON RC.RESTAURANT_ID = R.RESTAURANT_ID
WHERE RT.OVERALL_RATING = 2;

-- 2. For each Occupation, find the average age of consumers. Only consider consumers who 
-- have made at least one rating. (Use a derived table to get consumers who have rated).
 
 SELECT C.OCCUPATION, AVG(C.AGE) AS AVG_AGE
FROM ( SELECT DISTINCT CONSUMER_ID FROM RATINGS) R
INNER JOIN CONSUMERS C
    ON R.CONSUMER_ID = C.CONSUMER_ID
GROUP BY C.OCCUPATION;
 

-- 3. Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings within each 
-- restaurant based on Overall_Rating (highest first). Display Restaurant_ID, Consumer_ID, 
-- Overall_Rating, and the RatingRank.

WITH RATING_ALL AS (SELECT R.RESTAURANT_ID,RT.Consumer_ID,R.CITY,RT.OVERALL_RATING FROM 
RATINGS RT INNER JOIN restaurantS R 
ON R.restaurant_ID = RT.restaurant_ID
WHERE R.CITY = 'Cuernavaca')

select restaurant_ID, Consumer_ID,Overall_Rating, 
RANK() OVER(PARTITION BY restaurant_ID ORDER BY OVERALL_RATING DESC) AS RATING_RANK FROM RATING_ALL;


-- 4. For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and also display the 
-- average Overall_Rating given by that specific consumer across all their ratings.

 SELECT Consumer_ID, Restaurant_ID,
 Overall_Rating, AVG(OVERALL_RATING) 
 OVER (partition by CONSUMER_ID)  FROM RATINGS;
 
 
 -- 5. Using a CTE, identify students who have a 'Low' budget. Then, for each of these students, 
-- list their top 3 most preferred cuisines based on the order they appear in the 
-- Consumer_Preferences table (assuming no explicit preference order, use Consumer_ID, 
-- Preferred_Cuisine to define order for ROW_NUMBER).

WITH STUDENT AS (SELECT C.CONSUMER_ID, P.PREFERRED_CUISINE, 
ROW_NUMBER() OVER (PARTITION BY C.CONSUMER_ID
ORDER BY C.CONSUMER_ID, P.PREFERRED_CUISINE) AS SP
FROM CONSUMERS C
INNER JOIN CONSUMERS_PREFERENCES P  
ON C.CONSUMER_ID = P.CONSUMER_ID
WHERE C.OCCUPATION = 'STUDENT'
AND C.BUDGET = 'LOW')

SELECT CONSUMER_ID,PREFERRED_CUISINE FROM STUDENT WHERE SP <= 3;



--  6. Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the 
-- Restaurant_ID, Overall_Rating, and the Overall_Rating of the next restaurant they rated (if 
-- any), ordered by Restaurant_ID (as a proxy for time if rating time isn't available). Use a 
-- derived table to filter for the consumer's ratings first.


Select C.Restaurant_ID,C.Overall_Rating, LEAD(C.Overall_Rating) OVER
(ORDER BY C.Restaurant_ID) AS NXT_RATING
FROM (
SELECT Restaurant_ID, Overall_Rating FROM RATINGS
WHERE CONSUMER_ID = 'U1008') AS C; 


-- 7. Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, 
-- and City of all Mexican restaurants that have an average Overall_Rating greater than 1.5.

CREATE VIEW HighlyRatedMexicanRestaurants AS 
SELECT R.Restaurant_ID,R.NAME,R.CITY,AVG(RT.OVERALL_RATING) AS AVG_OVERALL_RATING
FROM RESTAURANTS R
INNER JOIN  RATINGS RT
ON R.Restaurant_ID = RT.Restaurant_ID
INNER JOIN restaurant_cuisines C  
ON C.Restaurant_ID = RT.Restaurant_ID
WHERE C.Cuisine = 'Mexican'
GROUP BY R.Restaurant_ID,R.NAME,R.CITY
HAVING AVG(RT.OVERALL_RATING) > 1.5;
SELECT * FROM HighlyRatedMexicanRestaurants;

-- DROP VIEW HighlyRatedMexicanRestaurants;

-- 8. First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, Using a CTE to 
-- find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) who have 
-- not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.

WITH mex_c AS (
SELECT distinct C.CONSUMER_ID FROM CONSUMERS_PREFERENCES C
WHERE C.Preferred_Cuisine = 'MEXICAN')

SELECT M.CONSUMER_ID FROM MEX_C M  
WHERE M.CONSUMER_ID NOT IN (
SELECT R.CONSUMER_ID FROM RATINGS R 
INNER JOIN HighlyRatedMexicanRestaurants H 
ON H.Restaurant_ID = R.Restaurant_ID);


-- 9. Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a 
-- Restaurant_ID and a minimum Overall_Rating as input. It should return the Consumer_ID, 
-- Overall_Rating, Food_Rating, and Service_Rating for that restaurant where the Overall_Rating 
-- meets or exceeds the threshold. 

DELIMITER // 
CREATE PROCEDURE GetRestaurantRatingsAboveThreshold (IN RESTAURANT INT,IN RATING INT )
BEGIN 
SELECT Consumer_ID, Overall_Rating, Food_Rating, 
Service_Rating
 FROM RATINGS 
 WHERE Restaurant_ID = RESTAURANT AND OVERALL_RATING >= RATING;
 END //
 DELIMITER ;
 CALL GetRestaurantRatingsAboveThreshold(135038,2);
 CALL GetRestaurantRatingsAboveThreshold(132564,1);
 
-- 10. Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. If there 
-- are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and 
-- Overall_Rating. 

WITH CuisineRatings AS ( SELECT RC.CUISINE,R.RESTAURANT_ID,R.NAME AS Restaurant_Name,R.CITY,
RT.OVERALL_RATING, DENSE_RANK() OVER ( PARTITION BY RC.CUISINE ORDER BY RT.OVERALL_RATING DESC
) AS RNK
FROM RATINGS RT
INNER JOIN RESTAURANTS R
ON R.RESTAURANT_ID = RT.RESTAURANT_ID
INNER JOIN RESTAURANT_CUISINES RC
ON RC.RESTAURANT_ID = RT.RESTAURANT_ID
)
SELECT CUISINE,Restaurant_Name,CITY,OVERALL_RATING
FROM CuisineRatings
WHERE RNK <= 2;


-- 11. First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their 
 -- average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by their 
-- average overall rating. For these top 5 consumers, list their Consumer_ID, their average 
-- rating, and the number of 'Mexican' restaurants they have rated.

CREATE VIEW ConsumerAverageRatings AS SELECT CONSUMER_ID, AVG(OVERALL_RATING) 
AS AVG_RATING
FROM RATINGS
GROUP BY CONSUMER_ID;

WITH RankedConsumers AS ( SELECT CONSUMER_ID, AVG_RATING, DENSE_RANK() 
OVER (ORDER BY AVG_RATING DESC) AS RNK
FROM ConsumerAverageRatings
),
TopConsumers AS ( SELECT CONSUMER_ID, AVG_RATING FROM RankedConsumers
    WHERE RNK <= 5
)
SELECT TC.CONSUMER_ID,TC.AVG_RATING,COUNT(DISTINCT R.RESTAURANT_ID) 
AS Mexican_Restaurants_Rated
FROM TopConsumers TC
LEFT JOIN RATINGS R
    ON TC.CONSUMER_ID = R.CONSUMER_ID
LEFT JOIN RESTAURANT_CUISINES RC
    ON R.RESTAURANT_ID = RC.RESTAURANT_ID
    AND RC.CUISINE = 'Mexican'
GROUP BY TC.CONSUMER_ID,TC.AVG_RATING;


-- 12. Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input. 
-- The procedure should: 
-- 1. Determine the consumer's "Spending Segment" based on their Budget: 
-- ○ 'Low' -> 'Budget Conscious' 
-- ○ 'Medium' -> 'Moderate Spender' 
-- ○ 'High' -> 'Premium Spender' 
-- ○ NULL or other -> 'Unknown Budget' 
-- 2. For all restaurants rated by this consumer: 
-- ○ List the Restaurant_Name. 
-- ○ The Overall_Rating given by this consumer. 
-- ○ The average Overall_Rating this restaurant has received from all consumers (not just the input consumer). 
-- ○ A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 'At Average', or 'Below Average' compared to 
-- the restaurant's overall average rating. 
-- ○ Rank these restaurants for the input consumer based on the Overall_Rating 
-- they gave (highest rating = rank 1). 

DELIMITER //

CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance (
    IN p_consumer_id VARCHAR(10)
)
BEGIN
    DECLARE v_spending_segment VARCHAR(30);

    SELECT 
        CASE 
            WHEN BUDGET = 'Low' THEN 'Budget Conscious'
            WHEN BUDGET = 'Medium' THEN 'Moderate Spender'
            WHEN BUDGET = 'High' THEN 'Premium Spender'
            ELSE 'Unknown Budget'
        END
    INTO v_spending_segment
    FROM CONSUMERS
    WHERE CONSUMER_ID = p_consumer_id;

    SELECT 
        v_spending_segment AS Spending_Segment,
        R.NAME AS Restaurant_Name,
        RT.OVERALL_RATING AS Consumer_Overall_Rating,
        AVG(RT2.OVERALL_RATING) AS Restaurant_Avg_Rating,
        CASE
            WHEN RT.OVERALL_RATING > AVG(RT2.OVERALL_RATING) THEN 'Above Average'
            WHEN RT.OVERALL_RATING = AVG(RT2.OVERALL_RATING) THEN 'At Average'
            ELSE 'Below Average'
        END AS Performance_Flag,
        RANK() OVER (
            ORDER BY RT.OVERALL_RATING DESC
        ) AS Rating_Rank
    FROM RATINGS RT
    INNER JOIN RESTAURANTS R
        ON RT.RESTAURANT_ID = R.RESTAURANT_ID
    INNER JOIN RATINGS RT2
        ON RT.RESTAURANT_ID = RT2.RESTAURANT_ID
    WHERE RT.CONSUMER_ID = p_consumer_id
    GROUP BY 
        R.RESTAURANT_ID,
        R.NAME,
        RT.OVERALL_RATING;

END //

DELIMITER ;

CALL GetConsumerSegmentAndRestaurantPerformance('U1008');


SELECT * FROM CONSUMERS;
SELECT * FROM RATINGS;
SELECT * FROM RESTAURANTS;
SELECT * FROM restaurant_cuisines;
SELECT * FROM CONSUMERS_PREFERENCES;
SELECT * FROM CONSUMERS;


