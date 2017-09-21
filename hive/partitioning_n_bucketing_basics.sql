---
--	Hive DLL and DML using partitioned and bucketing
---
--lets see our current db on the commandline
set hive.cli.print.current.db=true;
use retail_db;
--create a managed table 
create table categories (cat_id int, cat_dept_id int, cat_name string) row format delimited fields terminated by ',';
--load data from local file system
load data local inpath '/home/cloudera/data/retail_db/categories/' into table categories;

--create a partitioned table
--not that Iam NOT including the partitioned column in the first bracket
create table categories_partitionedby_deptid (cat_id int,cat_name string) partitioned by (cat_dept_id int);
--must set to use dynamic partitioned
set hive.exec.dynamic.partition.mode=nonstrict;
--insert 
insert into categories_partitionedby_deptid partition(cat_dept_id) 
	select cat_id, cat_name, cat_dept_id from categories;
--insert values
insert into categories_partitionedby_deptid partition(cat_dept_id) 
	values (1,'one',11),(2,'two',22);
--validate
show partitions categories_partitionedby_cat_dept_id;

--create bucketed table
create table categories_bucketedby_deptid(cat_id int, cat_dept_id int, cat_name string) clustered by (cat_dept_id) into 3 buckets;
--must be true
set hive.enforce.bucketing = true;
--insert
insert into table categories_bucketedby_deptid 
	select * from categories;
