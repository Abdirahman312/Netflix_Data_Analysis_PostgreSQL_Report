CREATE TABLE netflix_titles (
    show_id VARCHAR PRIMARY KEY,
    type VARCHAR,
    title VARCHAR,
    director VARCHAR,
    "cast" TEXT,
    country VARCHAR,
    date_added DATE,
    release_year INT,
    rating VARCHAR,
    duration VARCHAR,
    listed_in VARCHAR,
    description TEXT
);


COPY netflix_titles
FROM 'C:\Users\<you>\Documents\netflix_titles.csv'
DELIMITER ','
CSV HEADER;


UPDATE netflix_titles
SET country = TRIM(country),
    rating = TRIM(rating),
    type = TRIM(type),
    title = TRIM(title);


UPDATE netflix_titles
SET rating = UPPER(rating);


UPDATE netflix_titles
SET date_added = NULL
WHERE date_added = '';


DELETE FROM netflix_titles a
USING netflix_titles b
WHERE a.ctid < b.ctid
AND a.show_id = b.show_id;


SELECT 
    SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS missing_type,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS missing_title,
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS missing_director,
    SUM(CASE WHEN "cast" IS NULL THEN 1 ELSE 0 END) AS missing_cast,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS missing_country,
    SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS missing_date_added,
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS missing_release_year,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS missing_rating,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS missing_duration,
    SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS missing_listed_in,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS missing_description
FROM netflix_titles;


SELECT type, COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY type
ORDER BY total_titles DESC;


SELECT country, COUNT(*) AS total_titles
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;


SELECT listed_in, COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY listed_in
ORDER BY total_titles DESC
LIMIT 10;


SELECT DISTINCT date_added
FROM netflix_titles
WHERE date_added IS NOT NULL
AND date_added !~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$';


UPDATE netflix_titles
SET date_added = NULL
WHERE date_added IS NULL
   OR date_added = ''
   OR date_added !~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$';


ALTER TABLE netflix_titles
ALTER COLUMN date_added TYPE DATE
USING TO_DATE(date_added, 'Month DD, YYYY');


SELECT date_added FROM netflix_titles LIMIT 10;


SELECT 
    EXTRACT(YEAR FROM date_added) AS year_added,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;


SELECT director, COUNT(*) AS total_titles
FROM netflix_titles
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;


SELECT type, ROUND(AVG(release_year), 1) AS avg_release_year
FROM netflix_titles
GROUP BY type;


SELECT title, release_year, type
FROM netflix_titles
ORDER BY release_year ASC
LIMIT 5;


SELECT title, release_year, type
FROM netflix_titles
ORDER BY release_year DESC
LIMIT 5;


SELECT 
    EXTRACT(YEAR FROM date_added) AS year_added,
    type,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added, type
ORDER BY year_added, type;


SELECT 
    TO_CHAR(date_added, 'Month') AS month_name,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY month_name
ORDER BY total_titles DESC;


WITH genre_split AS (
    SELECT UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
    FROM netflix_titles
)
SELECT genre, COUNT(*) AS total_titles
FROM genre_split
GROUP BY genre
ORDER BY total_titles DESC
LIMIT 15;


SELECT 
    country,
    type,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country, type
ORDER BY total_titles DESC
LIMIT 15;


SELECT 
    director,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;


WITH actor_split AS (
    SELECT UNNEST(STRING_TO_ARRAY("cast", ', ')) AS actor
    FROM netflix_titles
)
SELECT actor, COUNT(*) AS total_titles
FROM actor_split
GROUP BY actor
ORDER BY total_titles DESC
LIMIT 15;


WITH genre_split AS (
    SELECT 
        UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre,
        release_year
    FROM netflix_titles
)
SELECT 
    genre,
    ROUND(AVG(release_year), 1) AS avg_release_year
FROM genre_split
GROUP BY genre
ORDER BY avg_release_year DESC
LIMIT 15;


SELECT 
    country,
    COUNT(*) AS total_recent_titles
FROM netflix_titles
WHERE date_added >= '2020-01-01'
GROUP BY country
ORDER BY total_recent_titles DESC
LIMIT 10;


SELECT rating, COUNT(*) AS total_titles
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY total_titles DESC;


SELECT 
    type,
    MIN(duration) AS shortest,
    MAX(duration) AS longest
FROM netflix_titles
GROUP BY type;
