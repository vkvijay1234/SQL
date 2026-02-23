

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

--Data Masking
use role sysadmin;
-- step-1
-- create databse and schema

-- step-2 Create a customer table and load the data using webui.
create or replace table data_mask_customer (
 customer_id varchar(),
 customer_first_name varchar(),
 customer_last_name varchar(),
 gender varchar(6),
 govt_id varchar(),
 date_of_birth date,
 annual_income number(38,2),
 credit_card_number varchar(20),
 card_provider varchar(20),
 mobile_number varchar,
 address varchar(),
 created_on timestamp_ntz(9)
);

-- lets describe the table and also view the table under object explorer
desc table data_mask_customer;

-- now load the sample data ... and query the table.
select * from data_mask_customer limit 10;

--Load option failed due to timestamp issue

create or replace stage data_mask;

CREATE OR REPLACE FILE FORMAT my_csv_format
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
TIMESTAMP_FORMAT = 'MM/DD/YYYY HH24:MI';

COPY INTO data_mask_customer
FROM @data_mask
FILE_FORMAT = my_csv_format;

select * from data_mask_customer limit 10;

use role sysadmin;
select * from data_mask_customer limit 10;
use role public; -- will not be accessible
select * from data_mask_customer limit 10;
use role useradmin; -- will not be accessible
select * from data_mask_customer limit 10;

use role accountadmin;

create or replace masking policy pii_masking_policy as (pii_text string)
    returns string ->
    case
        when current_role() in ('ACCOUNTADMIN')
            then pii_text
        when current_role() in ('USERADMIN') then 
            regexp_replace(pii_text,substring(pii_text,1,7),'xxx-xx-')
        else '***Masked***'
end;

alter table data_mask_customer modify column govt_id set masking policy pii_masking_policy;

-- how to list all policies
show masking policies;

-- how to describe a masking policy
desc masking policy pii_masking_policy;

-- get_ddl function support masking policy?
select get_ddl('POLICY','pii_masking_policy');

-- where it is stored in information schema
-- account usage schema.

-- map this masking policy to a column in a table.
alter table data_mask_customer modify column govt_id set masking policy pii_masking_policy;

select * from data_mask_customer;

--Card Number Hide
create or replace masking policy card_number_pii as (card_number string)
    returns string ->
    case
        when current_role() in ('ACCOUNTADMIN')
            then card_number
        when current_role() in ('USERADMIN') then regexp_replace(card_number,substring(card_number,1,15),'xxxx-xxxx-xxxx-')
        else '***Card-No-Masked***'
end;

alter table data_mask_customer modify column credit_card_number set masking policy card_number_pii;

--Date of Birth Hide
create or replace masking policy dob_pii as (date_of_birth date)
    returns date ->
    case
        when current_role() in ('SYSADMIN')
            then date_of_birth
        else '1999-01-01'::date
end;
alter table data_mask_customer modify column date_of_birth set masking policy dob_pii;

use role accountadmin;
use role public;

select * from data_mask_customer;

--Phone Number Hide
--Not workinh
--ALTER TABLE data_mask_customer
--ALTER COLUMN mobile_number SET DATA TYPE VARCHAR;


create or replace masking policy phone_pii as (ph_num  varchar)
    returns varchar ->
           case when current_role() in ('ACCOUNTADMIN')
           then ph_num
           else left(ph_num,2) || repeat('X',8) || right(ph_num,2) end;

alter table data_mask_customer modify column mobile_number  set masking policy phone_pii; 

select * from data_mask_customer;

select mobile_number,regexp_replace(mobile_number,substr(mobile_number,1,10),'XXXXXX') from data_mask_customer;

select mobile_number,left(mobile_number,2) || repeat('X',8) || right(mobile_number,2) as mask_num from data_mask_customer;

SELECT mobile_number,
    REPEAT('X', 6) ||
     right(mobile_number, 4) 
FROM data_mask_customer;

select distinct cast(mobile_number as varchar(10)) FROM data_mask_customer;

--Conditional masking
create or replace table data_mask_customer_cond (
 customer_id varchar(),
 customer_first_name varchar(),
 customer_last_name varchar(),
 gender varchar(6),
 govt_id varchar(),
 date_of_birth date,
 annual_income number(38,2),
 credit_card_number varchar(20),
 card_provider varchar(20),
 mobile_number varchar,
  region varchar,
 address varchar(),
 created_on timestamp_ntz(9)
);


COPY INTO data_mask_customer_cond
FROM @data_mask/Data_Mask_Conditional.csv
FILE_FORMAT = my_csv_format;

select * from data_mask_customer_cond;

create or replace masking policy cond_mask_daata_pii as  (id string, reg string) 
returns string ->
     case when reg <> 'Europe' then id 
     else '** ID Masked **' end;

alter table data_mask_customer_cond
modify column GOVT_ID set masking policy cond_mask_daata_pii using (GOVT_ID,REGION);


select * from data_mask_customer_cond;

--Tag based masking --Here we can update which all tag associated with tables

ㆍDate filtering using functions like DATE_SUB
DATE_SUB() is used to subtract a specific time interval from a date to filter recent records.
📌 Brief Explanation:
It helps retrieve data for a dynamic period like last 7 days, last 30 days, etc., by subtracting days from the current date.

SELECT *
FROM Orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

select DATE_SUB(CURDATE(), INTERVAL 7 DAY);
