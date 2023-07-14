CREATE SCHEMA `malls` ;

USE malls;
SET sql_mode = '';

CREATE TABLE mall_info (
    mall_name VARCHAR(255), -- Mall Name
    country VARCHAR(255), -- Country location of the mall
    city VARCHAR(255), -- City location of the mall
    yoe INT, -- Year of establishment
    area_mt_square INT, -- Area of the mall in meter squares
    area_sq_ft INT, -- Area of the mall in square feet
    shops INT -- No. of shops inside the mall
);
COMMIT;

DESC mall_info;

-- Import the modified csv file into the table (55 records)

-- Show all data from mall_info table

SELECT * FROM mall_info;

