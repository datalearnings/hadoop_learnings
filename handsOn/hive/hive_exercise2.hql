-- Create Managed  Table  | Comma Delimited Data

CREATE TABLE emp_ext(Fname string, Lname string,
     city STRING, dept string)
 COMMENT 'This is the employee view table'
 ROW FORMAT DELIMITED
 FIELDS TERMINATED BY ','
 STORED AS TEXTFILE;

 -- Load Data from  Local to Hive Table
 LOAD DATA LOCAL INPATH '/home/cloudera/Documents/Data/load_data.txt' INTO TABLE emp_ext ;


-- Create Managed Table | Comma delimited Data.
 CREATE TABLE emp_dept(Fname string, Lname string,
city STRING)
 COMMENT 'This is the employee view table'
 PARTITIONED BY(dept STRING)
 ROW FORMAT DELIMITED
 FIELDS TERMINATED BY ','
 STORED AS TEXTFILE;


 -- Insert Data from  Between Partition Tables.

 insert into table emp_dept partition (dept)
 select * from emp_ext;

--  To Enable Dynamic Partition
 set hive.exec.dynamic.partition.mode=nonstrict;

-- Create Dir in HDFS for DEPT=400
hadoop fs -mkdir /user/cloudera/hive/emp_dept/dept=400/

--  Copy Data file into  HDFS for DEPT=400
hadoop fs -copyFromLocal /home/cloudera/Documents/Data/ptn_data.txt /user/cloudera/hive/emp_dept/dept=400/

hadoop fs -ls /user/cloudera/hive/emp_dept

-- Alter Table By Adding the Partition .
alter table emp_dept add partition (dept = 400);


show partitions emp_dept;

CREATE TABLE emp_updt(Fname string, Lname string,
     city STRING, dept string)
 COMMENT 'This is the employee view table'
 ROW FORMAT DELIMITED
 FIELDS TERMINATED BY ','
 STORED AS TEXTFILE;

 LOAD DATA LOCAL INPATH '/home/cloudera/Documents/Data/ptn_data_updt.txt' INTO TABLE emp_updt ;

insert into table emp_dept partition (dept)
select * from emp_updt;
