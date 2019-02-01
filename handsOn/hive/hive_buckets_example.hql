use default;

--- Buckets Creation Example .
CREATE TABLE rating_bkt
(userId string,
movieId string,
rating STRING,
timestamp string)
CLUSTERED BY (rating) into
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Enable Bucket in Hive
 set.hive.enforce.bucketing=true;

-- Inserting Data from  rating table into bucketed Rating Table.
insert into  rating_bkt
select * from  rating;
