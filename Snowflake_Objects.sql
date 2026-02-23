

---Loading CSV files
--Step 1: Create Target Table
create or replace table investment_banking
(broker_id varchar(100),
city varchar(100),
broker_type varchar(100),
fund_category varchar(100),
email_opened varchar(100),
webex_meet varchar(100),
sales_call varchar(100),
firm_sales integer,
global_sales integer);

--Step 2: Create Stage
--Opt 1 Internal Stage (Quick & Simple)
create or replace stage ksr;

---Upload file (from SnowSQL or Snowflake UI):
PUT file:E://KSR Assignmnets//KSRDataSets-main//investment_banking.csv @ksr;

--opt 2 External Stage (S3 Example)
CREATE OR REPLACE STAGE my_s3_stage
URL='s3://my-bucket/data/'
CREDENTIALS=(AWS_KEY_ID='xxx' AWS_SECRET_KEY='xxx');


--Step 3: Create File Format (Best Practice)
CREATE OR REPLACE FILE FORMAT my_csv_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

--Step 4: Load Data Using COPY INTO
COPY INTO investment_banking
FROM @KSR/investment_banking.csv
FILE_FORMAT = my_csv_format;

select * from investment_banking;--

select * from investment_banking_clu;


select * from investment_banking where email_opened='Y';
--Cluster
create or replace table investment_banking_clu
(broker_id varchar(100),
city varchar(100),
broker_type varchar(100),
fund_category varchar(100),
email_opened varchar(100),
webex_meet varchar(100),
sales_call varchar(100),
firm_sales integer,
global_sales integer)
 cluster by (broker_id) ;

 --Step 4: Load Data Using COPY INTO
COPY INTO investment_banking_clu
FROM @KSR/investment_banking.csv
FILE_FORMAT = my_csv_format;

list @KSR;
show stages;

--Check status of files loaded and failed
select * from snowflake.account_usage.copy_history where table_name='INVESTMENT_BANKING';

select * from snowflake.account_usage.load_history where table_name='INVESTMENT_BANKING';

select * from snowflake.account_usage.metering_history  where service_type ='PIPE' ;

select $1,$2, $3,$4 from @ksr;

 select * from investment_banking;

----Cluster Alters
 
show tables like '%investment_banking%';

--Adding cluster to exiting table
alter table investment_banking cluster by (broker_id);

--suspend the cluster to exiting table
alter table investment_banking suspend recluster ;

--Resume cluster to exiting table
alter table investment_banking resume recluster ;

--Drop cluster 
alter table investment_banking drop clustering key;

--Clustering depth
select system$clustering_depth('investment_banking_clu');

--Clustering information
select system$clustering_information('investment_banking');

--Snowpipe 

create or replace pipe demo_pipe as
COPY INTO investment_banking
FROM @KSR/investment_banking.csv
FILE_FORMAT = my_csv_format;

--check status 
select system$pipe_status('demo_pipe');

--refresh pipe
alter pipe demo_pipe refresh;

---pause pipe
alter pipe demo_pipe set pipe_execution_paused = true;

---resume pipe
alter pipe demo_pipe set pipe_execution_paused = false;

--Check status of files loaded and failed
select * from snowflake.account_usage.copy_history  where pipe_name ='demo_pipe';

select * from snowflake.account_usage.metering_history  where service_type ='PIPE' ;

---Tasks 
create or replace table cust_dim(
id number,
f_name varchar,
l_name varchar,
dob date,
flag boolean,
time_stamp timestamp default current_timestamp()
);

select * from cust_dim;

--create a sequence object 
create or replace sequence cust_seq
start 2 
increment 2;

--Check seq object
select cust_seq.nextval;


--Now create task
Create or replace task demo_task
warehouse='COMPUTE_WH'
schedule = '1 minute'
as 
insert into cust_dim(id,f_name,l_name,dob,flag)
values (cust_seq.nextval,'vijay','kumar',current_date(),true);

show tasks ;--definition,WH,owener,state-->by defualt suspended

select * from cust_dim;

--to resume task
alter task demo_task resume;
show tasks ;---Stat -->started

--post 1 minuts
select * from cust_dim;

--suspend task
alter task demo_task suspend;


--We can change alter task and change attributes
alter task demo_task set warehouse='TASTY_DWH';
alter task demo_task set schedule = '2 minuts';

--we can clone 
create task demo_clone clone demo_task;

show tasks;-->clone suspended

--How to check if it is running
select * from table(information_schema.task_history()) where name='DEMO_TASK';


--cron schedule
*-->minut(0-59)
**-->Hour(0-23)
***-->day of month(1-31)
****-->month(1-12,JAN-DEC)
*****-->day of week(0-6,SUN-SAT);

Create or replace task cron_task_1min
warehouse='COMPUTE_WH'
schedule = 'USING CRON * * * * SUN America/Los_Angeles'
as 
insert into cust_dim(id,f_name,l_name,dob,flag)
values (cust_seq.nextval,'vijay','kumar',current_date(),true);

alter task cron_task_1min resume;

show tasks;

select * from table(information_schema.task_history()) where name='CRON_TASK_1MIN';

--5min
Create or replace task cron_task_5min
warehouse='COMPUTE_WH'
schedule = 'USING CRON 5 * * * SUN America/Los_Angeles'
as 
insert into cust_dim(id,f_name,l_name,dob,flag)
values (cust_seq.nextval,'vijay','kumar',current_date(),true);

alter task cron_task_5min resume;

show tasks;

select * from table(information_schema.task_history()) where name='CRON_TASK_5MIN';
alter task cron_task_1min suspend;
alter task cron_task_5min suspend;

--Tasks Tree
create or replace table cust_tree(
level varchar,
f_name varchar,
l_name varchar,
dob date,
flag boolean,
time_stamp timestamp default current_timestamp()
);

--Task 1--L1
Create or replace task parent_task_l1
warehouse='COMPUTE_WH'
schedule = '1 minute'
as 
insert into cust_tree(level,f_name,l_name,dob,flag)
values ('Level-1','vijay','kumar',current_date(),true);

--Task 2 --L2

Create or replace task child_task_l2
warehouse='COMPUTE_WH'
after parent_task_l1
as 
insert into cust_tree(level,f_name,l_name,dob,flag)
values ('Child_level-2','vijay','kumar',current_date(),true);

show tasks;

select * from cust_tree;

alter task parent_task_l1 suspend;

--Limitations
--task support only minuts does not suppot secound/hours
--grant excute task,excute managed task on account to role
--we can schedule inly 11520 min (8 days)
--Task does not create for none existent WH
--Need to run 1st parent then child defalut run
