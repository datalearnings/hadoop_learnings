-- Dataset is present in Data Folder.

CREATE TABLE rating
(userId string,
movieId string,
rating STRING,
timestamp string)
 COMMENT 'This is the rating view table'
 ROW FORMAT DELIMITED
 FIELDS TERMINATED BY ','
 STORED AS TEXTFILE;

 LOAD DATA LOCAL INPATH '/home/cloudera/Documents/Data/ratings.csv' INTO TABLE rating ;

-- External table Creation Example .
CREATE EXTERNAL TABLE movies_ext
(movieId string,
  title string,
  genres string
 )
  COMMENT 'This is the Movie view table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ‘,’
LOCATION '/user/cloudera/hive/movies';

--join example

select movieId, rating, title from
movies_ext m
join rating r
on m.movieId = r.movieId
limit 5;

select m.movieId, rating, title from
movies_ext m
join rating r
on m.movieId = r.movieId
limit 5;

--group by

select userId, count(*) num_movies from rating
group by userId limit 5;

--top 10 users rated most movies

select userId, count(*) num_movies from rating
group by userId
order by num_movies desc
limit 10;

--avg rating for all movies

select m.movieId, avg(rating) avg_rating, title from
movies_ext m
join rating r
on m.movieId = r.movieId
group by m.movieId, title
limit 5;
