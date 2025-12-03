# 🎬Netflix Titles Data Analysis (PostgreSQL) <img src="https://github.com/user-attachments/assets/3e1005cd-5a97-4625-b1e4-cdc84b535ffd" width="40px">

This project explores and analyzes the Netflix Titles dataset using PostgreSQL in VS Code.  
It focuses on data cleaning, transformation, and SQL-based insights to uncover patterns in Netflix's global catalog of Movies and TV Shows.

---
## 🧰 Tools Used
[![My Skills](https://skillicons.dev/icons?i=postgres,vscode)](https://skillicons.dev)

---

## 🗂️ Dataset Overview
The dataset contains information on Movies and TV Shows available on Netflix, including:
- `show_id`
- `type`
- `title`
- `director`
- `cast`
- `country`
- `date_added`
- `release_year`
- `rating`
- `duration`
- `listed_in`
- `description`

---

# 🧹 Data Cleaning Steps

1. **Created a new PostgreSQL database**
   ```sql
   CREATE DATABASE netflix_analysis;
   ```

2. **Created table schema**
   ```sql
   CREATE TABLE netflix_titles (
       show_id VARCHAR PRIMARY KEY,
       type VARCHAR,
       title VARCHAR,
       director VARCHAR,
       cast TEXT,
       country VARCHAR,
       date_added DATE,
       release_year INT,
       rating VARCHAR,
       duration VARCHAR,
       listed_in VARCHAR,
       description TEXT
   );
   ```
---
3. **Imported dataset from CSV**
   ```sql
   COPY netflix_titles
   FROM 'C:\Users\<yourname>\Documents\netflix_titles.csv'
   DELIMITER ','
   CSV HEADER;
   ```
---
4. **Cleaned whitespace and standardized text**
   ```sql
   UPDATE netflix_titles
   SET country = TRIM(country),
       rating = TRIM(rating),
       type = TRIM(type),
       title = TRIM(title);
   ```
---
5. **Converted `date_added` to proper DATE type**
   ```sql
   ALTER TABLE netflix_titles
   ALTER COLUMN date_added TYPE DATE
   USING TO_DATE(date_added, 'Month DD, YYYY');
   ```
---
6. **Replaced invalid or blank date values with NULL**
   ```sql
   UPDATE netflix_titles
   SET date_added = NULL
   WHERE date_added IS NULL
      OR date_added = ''
      OR date_added !~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$';
   ```

---

# 🧮 SQL Queries Used

### 1️⃣ Count of Movies vs TV Shows
```sql
SELECT type, COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY type
ORDER BY total_titles DESC;
```
---
### 2️⃣ Top 10 Countries with Most Titles
```sql
SELECT country, COUNT(*) AS total_titles
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;
```
---
### 3️⃣ Titles Added per Year
```sql
SELECT 
    EXTRACT(YEAR FROM date_added) AS year_added,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;
```
---
### 4️⃣ Number of Titles per Year by Type
```sql
SELECT 
    EXTRACT(YEAR FROM date_added) AS year_added,
    type,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added, type
ORDER BY year_added, type;
```
---
### 5️⃣ Monthly Trend of New Titles Added
```sql
SELECT 
    TO_CHAR(date_added, 'Month') AS month_name,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY month_name
ORDER BY total_titles DESC;
```
---
### 6️⃣ Most Popular Genres
```sql
WITH genre_split AS (
    SELECT UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
    FROM netflix_titles
)
SELECT genre, COUNT(*) AS total_titles
FROM genre_split
GROUP BY genre
ORDER BY total_titles DESC
LIMIT 15;
```
---
### 7️⃣ Countries Producing Most Movies vs TV Shows
```sql
SELECT 
    country,
    type,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country, type
ORDER BY total_titles DESC
LIMIT 15;
```
---
### 8️⃣ Top 10 Directors
```sql
SELECT 
    director,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;
```
---
### 9️⃣ Most Frequent Actors/Actresses
```sql
WITH actor_split AS (
    SELECT UNNEST(STRING_TO_ARRAY("cast", ', ')) AS actor
    FROM netflix_titles
)
SELECT actor, COUNT(*) AS total_titles
FROM actor_split
GROUP BY actor
ORDER BY total_titles DESC
LIMIT 15;
```
---
### 🔟 Average Release Year per Genre
```sql
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
```
---
# 1️⃣ Countries Adding Most Titles Recently
```sql
SELECT 
    country,
    COUNT(*) AS total_recent_titles
FROM netflix_titles
WHERE date_added >= '2020-01-01'
GROUP BY country
ORDER BY total_recent_titles DESC
LIMIT 10;
```
---
### 2️⃣ Most Common Ratings
```sql
SELECT rating, COUNT(*) AS total_titles
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY total_titles DESC;
```
---
### 3️⃣ Longest vs Shortest Duration by Type
```sql
SELECT 
    type,
    MIN(duration) AS shortest,
    MAX(duration) AS longest
FROM netflix_titles
GROUP BY type;
```
---

## 📊 Movies vs TV Shows
<img width="1800" height="1200" alt="movies_vs_tvshows" src="https://github.com/user-attachments/assets/275c3f18-78f4-4aca-9839-aaa46a02e63e" />

## 🌍 Top 10 Countries by Number of Titles
<img width="3000" height="1800" alt="countries_distribution" src="https://github.com/user-attachments/assets/6ca9fcfe-24ae-47a9-b3f6-4e576c2c4afb" />

## 📈 Releases Over the Years
<img width="3000" height="1800" alt="releases_over_years" src="https://github.com/user-attachments/assets/3ee5369a-d32a-483a-9840-8e44fdffc160" />

---

## 📌 Insights

### 1. Movies dominate Netflix content  
Movies make up the majority of Netflix titles. This shows Netflix’s strong investment in film content.

### 2. The United States produces the most content  
The U.S. has the highest number of Netflix titles, followed by India and the UK.

### 3. Content production grew after 2015  
There is a strong increase in releases between 2015 and 2020, showing Netflix’s global expansion.

### 4. Drama is the top genre  
Drama leads all categories, followed by Comedy and Documentary.

### 5. Rising production of TV Shows  
Even though movies are more common overall, TV show releases have been rising quickly in recent years.

---

## 🔧 How to Run This Project (Reproduce the Analysis)

Follow these steps to recreate the Netflix PostgreSQL analysis on your own machine.

### 1. Install PostgreSQL
Download PostgreSQL from:  
https://www.postgresql.org/download/

Make sure pgAdmin is installed as well.

---

### 2. Create a new database
Open pgAdmin and run:

```sql
CREATE DATABASE netflix;
CREATE TABLE netflix_titles (
    show_id TEXT,
    type TEXT,
    title TEXT,
    director TEXT,
    "cast" TEXT,
    country TEXT,
    date_added TEXT,
    release_year INT,
    rating TEXT,
    duration TEXT,
    listed_in TEXT,
    description TEXT
);

COPY netflix_titles
FROM 'C:/path/to/netflix_titles.csv'
DELIMITER ','
CSV HEADER;
```

---

## 🧾 Credits
Dataset source: [Netflix Titles on Kaggle](https://www.kaggle.com/shivamb/netflix-shows)

---

## 📬 Contact Me on:

- 💼 **LinkedIn:** [linkedin.com/in/abdirahman-ahmed-b7841a343](https://www.linkedin.com/in/abdirahman-ahmed-b7841a343)  
- 📧 **Email:** [abdirahmanahmed2728@email.com](mailto:abdirahmanahmed2728@email.com)   
---
⭐ **Author:** _Abdirahman_

🗓️ **Year:** 2025  
