CREATE TABLE User_Yelp -- changed from the original, 'User'
(
    user_id CHAR(22),
    yelping_since DATE,
    useful INTEGER,
    review_count INTEGER,
    user_name VARCHAR2(100), -- changed from the original, 'name'
    funny INTEGER,
    fans INTEGER,
    cool INTEGER,
    compliment_writer INTEGER,
    compliment_profile INTEGER,
    compliment_plan INTEGER,
    compliment_photos INTEGER,
    compliment_note INTEGER,
    compliment_more INTEGER,
    compliment_list INTEGER,
    compliment_hot INTEGER,
    compliment_funny INTEGER,
    compliment_cute INTEGER,
    compliment_cool INTEGER,
    average_stars NUMBER(2),
    CONSTRAINT User_PK PRIMARY KEY (user_id)
);

CREATE TABLE Friends
(
    user_id CHAR(22),
    friends_id CHAR(22),
    CONSTRAINT Friends_PK PRIMARY KEY (user_id,friends_id),
    CONSTRAINT Friends_User_FK FOREIGN KEY (user_id) REFERENCES User_Yelp(user_id),
    CONSTRAINT Friends_User_FK2 FOREIGN KEY (friends_id) REFERENCES User_Yelp(user_id)
);

CREATE TABLE Elite_years
(
    elite_id INTEGER,   -- changed from the original, 'id'
    elite_year NUMBER,  -- changed from the original, 'year'                      
    CONSTRAINT Elite_years_PK PRIMARY KEY (elite_id)
);

CREATE TABLE User_elite
(
    user_id CHAR(22),
    elite_year_id INTEGER,
    CONSTRAINT User_elite_PK PRIMARY KEY (user_id,elite_year_id),
    CONSTRAINT User_elite_User_FK FOREIGN KEY (user_id) REFERENCES User_Yelp(user_id),
    CONSTRAINT User_elite_Elite_years_FK FOREIGN KEY (elite_year_id) REFERENCES Elite_years(elite_id)
);

CREATE TABLE Business
(
    business_id CHAR(22),   -- changed from the original, 'id'
    business_name VARCHAR2(100),  -- changed from the original, 'name'
    stars FLOAT,
    review_count INTEGER,
    is_open CHAR(1),
    CONSTRAINT Business_PK PRIMARY KEY (business_id)
);

CREATE TABLE Reviews
(
    business_id CHAR(22),
    review_id CHAR(22),
    user_id CHAR(22),
    cool INTEGER,
    funny INTEGER,
    stars INTEGER,
    useful INTEGER,
    review_text VARCHAR2(2000), -- changed from the original, 'text'
    review_date DATE, -- changed from the original, 'date'
    CONSTRAINT Reviews_PK PRIMARY KEY (review_id),
    CONSTRAINT Reviews_User_FK FOREIGN KEY (user_id) REFERENCES User_Yelp(user_id),
    CONSTRAINT Reviews_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE Tips
(
    user_id CHAR(22),
    business_id CHAR(22),
    tip_date DATE,  -- changed from the original, 'date'
    compliment_count INTEGER,
    tip_text VARCHAR2(2000), -- changed from the original 'text'
    CONSTRAINT Tips_PK PRIMARY KEY (user_id,business_id, tip_date),
    CONSTRAINT Tips_User_FK FOREIGN KEY (user_id) REFERENCES User_Yelp(user_id),
    CONSTRAINT Tips_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE States
(
    state_name VARCHAR2(5),
    CONSTRAINT States_PK PRIMARY KEY (state_name)
);

CREATE TABLE Cities 
(
    state_name VARCHAR2(5),
    city_name VARCHAR2(50),
    CONSTRAINT Cities_PK PRIMARY KEY (state_name, city_name),
    CONSTRAINT Cities_States_FK FOREIGN KEY (state_name) REFERENCES States(state_name)
);

CREATE TABLE Regions
(
    state_name VARCHAR2(5),
    city_name VARCHAR2(50),
    postal_code VARCHAR2(20),
    CONSTRAINT Regions_PK PRIMARY KEY (state_name, city_name, postal_code),
    CONSTRAINT Regions_Cities_FK FOREIGN KEY(state_name, city_name)  REFERENCES Cities(state_name,city_name)
);

CREATE TABLE Business_location
(
    business_id CHAR(22),
    state_name VARCHAR2(5), -- changed from the original, 'state'
    city_name VARCHAR2(50), -- changed from the original, 'city'
    postal_code VARCHAR2(20),
    lat FLOAT,
    lon FLOAT,
    CONSTRAINT Business_location_PK PRIMARY KEY (business_id, state_name, city_name, postal_code),
    CONSTRAINT Business_location_Regions_FK FOREIGN KEY (state_name, city_name, postal_code) REFERENCES Regions(state_name, city_name, postal_code),
    CONSTRAINT Business_location_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE Day_of_week 
(
    day_id INTEGER, -- changed from the original, 'id'
    day_name VARCHAR2(10),  -- changed from the original, 'day'
    CONSTRAINT Day_of_week_PK PRIMARY KEY (day_id)
);

CREATE TABLE Business_hours
(
    business_id CHAR(22),
    day_id INTEGER,
    hours_from VARCHAR2(5), -- changed from the original, 'from'
    hours_to VARCHAR2(5),   -- changed from the original, 'to'
    CONSTRAINT Business_hours_PK PRIMARY KEY (business_id, day_id),
    CONSTRAINT Business_hours_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id),
    CONSTRAINT Business_hours_Day_of_week_FK FOREIGN KEY (day_id) REFERENCES Day_of_week(day_id)
);

CREATE TABLE Business_categories 
(
    category_id INTEGER,    -- changed from the original, 'id'
    category_name VARCHAR2(50), -- changed from the original, 'category'
    CONSTRAINT Business_categories_PK PRIMARY KEY (category_id)
);

CREATE TABLE Business_has_categories
(
    category_id INTEGER,    -- changed from the original, 'cat_id'
    business_id CHAR(22),   -- changed from the original, 'b_id'
    CONSTRAINT Business_has_categories_PK PRIMARY KEY (category_id, business_id),
    CONSTRAINT Business_has_categories_Business_categories_FK FOREIGN KEY (category_id) REFERENCES Business_categories(category_id),
    CONSTRAINT Business_has_categories_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE Ambiance   -- changed from the original, 'Ambience'
(
    ambiance_id INTEGER,    -- changed from the original, 'id'
    ambiance_description VARCHAR2(30),  -- changed from the original, 'description'
    CONSTRAINT Ambiance_PK PRIMARY KEY (ambiance_id)
);

CREATE TABLE Business_ambiance
(
    business_id CHAR(22),
    ambiance_id INTEGER,
    CONSTRAINT Business_ambiance_PK PRIMARY KEY (business_id, ambiance_id),
    CONSTRAINT Business_ambiance_Ambiance_FK FOREIGN KEY (ambiance_id) REFERENCES Ambiance(ambiance_id),
    CONSTRAINT Business_ambiance_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE Parking_type
(
    parking_type_id INTEGER,    -- changed from the original, 'id'
    parking_type_description VARCHAR2(30),  -- changed from the original, 'description'
    CONSTRAINT Parking_type_PK PRIMARY KEY (parking_type_id)
);

CREATE TABLE Business_parking_type
(
    business_id CHAR(22),
    parking_type_id INTEGER,    -- changed from the original, 'parking id'
    CONSTRAINT Business_parking_type_PK PRIMARY KEY (business_id, parking_type_id),
    CONSTRAINT Business_parking_type_Parking_type_FK FOREIGN KEY (parking_type_id) REFERENCES Parking_type(parking_type_id),
    CONSTRAINT Business_parking_type_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE Noise_level
(
    noise_id INTEGER,   -- changed from the original, 'id'
    noise_description VARCHAR2(30), -- changed from the original, 'noise_description'
    CONSTRAINT Noise_level_PK PRIMARY KEY (noise_id)
);

CREATE TABLE Business_noise_level
(
    business_id CHAR(22),   -- changed from the original, 'b_id'
    noise_id INTEGER,
    CONSTRAINT Business_noise_level_PK PRIMARY KEY (business_id, noise_id),
    CONSTRAINT Business_noise_level_Noise_level_FK FOREIGN KEY (noise_id) REFERENCES Noise_level(noise_id),
    CONSTRAINT Business_noise_level_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE Good_for_meal
(
    good_for_meal_id INTEGER,   -- changed from the original 'good_for_meal_id'
    good_for_meal_description VARCHAR2(30), -- changed from the original 'description'
    CONSTRAINT Good_for_meal_PK PRIMARY KEY (good_for_meal_id)
);

CREATE TABLE Business_good_for_meal
(
    business_id CHAR(22),
    good_for_meal_id INTEGER,
    CONSTRAINT Business_good_for_meal_PK PRIMARY KEY (business_id, good_for_meal_id),
    CONSTRAINT Business_good_for_meal_Good_for_meal_FK FOREIGN KEY (good_for_meal_id) REFERENCES Good_for_meal(good_for_meal_id),
    CONSTRAINT Business_good_for_meal_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE Dietary_restrictions
(
    dietary_rest_id INTEGER,    -- changed from the original, 'id'
    dietary_rest_description VARCHAR2(30),  -- changed from the original, 'description'
    CONSTRAINT Dietary_restrictions_PK PRIMARY KEY (dietary_rest_id)
);

CREATE TABLE Business_dietary_restrictions
(
    business_id CHAR(22),   -- changed from the original, 'b_id'
    dietary_rest_id INTEGER,
    CONSTRAINT Business_dietary_restrictions_PK PRIMARY KEY (business_id, dietary_rest_id),
    CONSTRAINT Business_dietary_restrictions_Dietary_restrictions_FK FOREIGN KEY (dietary_rest_id) REFERENCES Dietary_restrictions(dietary_rest_id),
    CONSTRAINT Business_dietary_restrictions_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE Music
(
    music_id INTEGER,   -- changed from the original, 'id'
    music_description VARCHAR2(30), -- changed from the original, 'description'
    CONSTRAINT Music_PK PRIMARY KEY (music_id)
);

CREATE TABLE Business_music
(
    business_id CHAR(22),
    music_id INTEGER,
    CONSTRAINT Business_music_PK PRIMARY KEY (business_id, music_id),
    CONSTRAINT Business_music_Music_FK FOREIGN KEY (music_id) REFERENCES Music(music_id),
    CONSTRAINT Business_music_Business_FK FOREIGN KEY (business_id) REFERENCES Business(business_id)
);


--================================================================================================
--                                OPTIMIZATION
--================================================================================================

-- Assuming 'valet' is a parking_type_id
-- Adding an index to business_name, review_count, parking_type_id and day_id
CREATE INDEX idx_business_1 ON Business (business_name, review_count);
CREATE INDEX idx_parking ON Business_parking_type (parking_type_id);
CREATE INDEX idx_hours ON Business_hours (day_id);

-- Query 1:
SELECT b.business_name, b.review_count
FROM Business b
JOIN Business_parking_type bpt ON b.business_id = bpt.business_id
JOIN Business_hours bh ON b.business_id = bh.business_id
JOIN Business_location bl ON b.business_id = bl.business_id
WHERE bl.city_name = 'Las Vegas' AND b.stars = 5 AND bpt.parking_type_id = 'valet' AND bh.day_id = 5
ORDER BY b.business_name;

-- Assuming 'CA' is the abbreviation for California
-- Adding an index to state_name, stars and business_name
CREATE INDEX idx_location ON Business_location (state_name);
CREATE INDEX idx_business_2 ON Business (stars, business_name);

-- Query 2:
SELECT b.business_name, b.stars
FROM Business b
JOIN Business_location bl ON b.business_id = bl.business_id
WHERE bl.state_name = 'CA'
ORDER BY b.stars DESC, b.business_name
FETCH FIRST 10 ROWS ONLY;

-- Adding an index to business_id
CREATE INDEX idx_reviews ON Reviews (business_id);

-- Query 3:
SELECT r.business_id
FROM Reviews r
GROUP BY r.business_id
HAVING COUNT(DISTINCT r.user_id) > 1030
ORDER BY r.business_id;





