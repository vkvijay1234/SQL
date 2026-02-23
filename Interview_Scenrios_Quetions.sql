--https://ksrdatavision.com/
---Remove duplicate records
--To remove duplicates in SQL, we typically use ROW_NUMBER() with PARTITION BY and delete records where the row number is greater than one
create or replace table test2 (id int,name varchar(10));

insert overwrite into  test2 select distinct * from test2;

insert into test2(id,name) values(8,'Vijay'),(7,'Vijay'),(6,'Kumar'),(5,'Raj'),(4,'Raj');
select * from test2;

insert into test1 values(8);
select * from test1;

select * from test2;

--delete from test1 where id
select id,count(id) from test1 group by 1
;

DELETE FROM test2 t
USING (
    SELECT id,name,count(*)
    FROM test2
    GROUP BY id,name
    HAVING COUNT(*) > 1
) d
WHERE t.id = d.id;


DELETE FROM test2
WHERE id IN (
    SELECT id,name
    FROM (
        SELECT id,name,
               ROW_NUMBER() OVER (
                   PARTITION BY id,name
                   ORDER BY id
               ) rn
        FROM test2
        
    ) t
    WHERE rn > 1
);

with cte as (
    SELECT id,name
    FROM (
        SELECT id,name, COUNT(1),
               ROW_NUMBER() OVER (
                   PARTITION BY id
                   ORDER BY id
               ) rn
        FROM test2 GROUP BY 1,2
        
    ) 
    
)    SELECT * FROM CTE;



--Both same columns overwrite
--insert overwrite into  test2 select distinct * from test2;

--Swap
--create or replace table abc as
--select distinct * from test2;

--alter table test2 swap with abc;

---1.Query for Missing Numbers 
 I/p=(1),(2),(3),(6),(7),(9) o/p=4,5,8

SELECT r.num,n.num
FROM (
  SELECT SEQ4()+1 AS num
  FROM TABLE(GENERATOR(ROWCOUNT => 10))
) r
LEFT JOIN (
  SELECT column1 AS num
  FROM VALUES (1),(2),(3),(6),(7),(9)
) n
ON r.num = n.num
WHERE n.num IS NULL
ORDER BY r.num;

with cte1 as(
select seq4()+1 num from table(generator(rowcount => 09))),
       cte2 as (select column1 as num from values (1),(2),(3),(6),(7),(9))

select a.num from cte1 a
left join cte2 b on a.num=b.num
where b.num is null
;

-------------------------
--2.Order the values in required formate
-- i/p-12,13,14,-14,-2,-10
--o/p-14,13,12,-14,-10,-2


--create table test_num (id integer);
--insert into test_num values (12),(13),(14),(-14),(-2),(-10);

select * from (
select * from test_num  where id>=0 order by 1 desc)
union all
select * from (
select * from test_num  where id<0 order by 1 asc);


select * from TEST_DATABASE.TEST_SCHEMA.TEST_NUM  
order by CASE WHEN id > 0 THEN 1 ELSE 2 END, 
case when id<0 then id end asc,
case when id>0 then id end desc
;

SELECT *
FROM test_num
ORDER BY 
    SIGN(id) DESC,    -- +1 first, then -1
    ABS(id) DESC;

    SELECT *,SIGN(id),  ABS(id) 
FROM test_num;

----------------------------------------------------
--3.Split name and show in row by values for each name

create or replace table test_database.test_schema.test_customers
(names varchar(100),Country varchar(10));

insert into test_database.test_schema.test_customers values
('Mike,David','USA');

select * from test_database.test_schema.test_customers;

select split_part(names,',',1),country
from test_database.test_schema.test_customers
union all
select split_part(names,',',2),country
from test_database.test_schema.test_customers
order by 2;

select substr(names,'1',regexp_instr(names,',') -1),country from test_database.test_schema.test_customers
union all
select substr(names,'6',regexp_instr(names,',') ),country from test_database.test_schema.test_customers
order by 2;



/*orders
------------------------
order_id        BIGINT
customer_id     BIGINT
order_amount    DECIMAL
order_date      DATE
status          VARCHAR
 
For each customer, find the second largest order amount that has been placed only for ‘COMPLETED’ orders in the last 6 months.
If a customer has less than 2 completed orders, show NULL  */

select * from orders;

select dateadd(month,-6,current_date);

select add_months(current_date,-6);
 
create or replace table orders (order_id BIGINT,
customer_id   BIGINT,
order_amount    DECIMAL,
order_date  DATE,
status    VARCHAR);

insert into orders(order_id,customer_id,order_amount,order_date,status) values 
(123,1,24000,'2025-10-12','COMPLETED'),
(1443,2,21000,'2025-10-15','NOT COMPLETED'),
(124,3,23000,'2025-10-14','COMPLETED'),
(1423,2,21000,'2025-12-15','NOT COMPLETED'),
(1211,1,22000,'2025-12-12','COMPLETED'),
(1433,3,21000,'2025-12-15','NOT COMPLETED'),
(1113,1,22000,'2025-11-12','COMPLETED'),
(1413,2,21000,'2025-11-15','NOT COMPLETED'),
(1223,8,22000,'2026-01-12','COMPLETED'),
(14453,8,21000,'2026-01-15','NOT COMPLETED');

select customer_id ,max(case when rnk=2 then order_amount end) second_largest_order_amount from
(select *,row_number() over(partition by customer_id order by order_amount desc) as rnk from  orders
where status='COMPLETED' and order_date >= add_months(current_date,-6))
group by 1
 ;

select * from orders;
WITH ranked_orders AS (
    SELECT
        customer_id,
        order_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_amount DESC
        ) AS rn
    FROM orders
    WHERE status = 'COMPLETED'
      AND order_date >= DATEADD(month, -6, CURRENT_DATE)
)
SELECT
    customer_id,
    MAX(CASE WHEN rn = 2 THEN order_amount END) AS second_largest_order_amount
FROM ranked_orders
GROUP BY customer_id;

/*For each customer, find the second largest order amount that has been placed only for ‘COMPLETED’ orders in the last 6 months.
If a customer has less than 2 completed orders, show NULL  */

select * from orders;

select dateadd(month,-6,current_date);

select add_months(current_date,-6);

select customer_id ,max(case when rnk=2 then order_amount end) from
(select *,row_number() over(partition by customer_id order by order_amount desc) as rnk from  orders
where status='COMPLETED' and order_date <=add_months(current_date,-1))
group by 1
 ;
-- Write SQL to get customers who spent the most in the last month (based on order_date)

 select customer_id,date_trunc('month',order_date),sum(order_amount) as total_spent from orders 
where date_trunc('month',order_date)=DATE_TRUNC('MONTH',add_months(current_date,-1))
group by customer_id,order_date
order by 1,2;

-- Medium-level SQL query: Calculate total revenue per customer using Orders and Order_Items tables
select customer,sum(price*qtny)
 from( 
select a.customer,b.price,b.qtny from Orders a
left Order_Items b on a.o_id = b.o_id)
group by 1;

--------------------
-- i/p-->1,2,3,4,6,10   o/p-->5,7,8,9


with cte1 as(
select SEQ4()+1 as num from table(generator(ROWCOUNT => 10))),
    cte as ( select column1 as num from values  (1),(2),(3),(4),(6),(10) )

select a.num from cte1 a
left join cte b on a.num=b.num 
where b.num is null;

---------------

--Table1 1,2,3,6
--Table2 1,2,7,9,4,3
--Join outputs
with cte1 as(
select column1 as num from values  (1),(1),(2),(2),(3),(3),(6)),
   cte2 as (select column1 as num2 from values  (1),(2),(7),(9),(4),(3))
   
select * from cte1 a  left join cte2 b on a.num=b.num2;--3 Records-->Only matching records  

--select * from cte1 a  left join cte2 b on a.num=b.num2;--5 Reords--> from left Matching 3 reocrd and 2 Not matching
 
--select * from cte1 a  right join cte2 b on a.num=b.num2;--6 Records--> from right Matching 3 reocrd and 3 Not matching
  
--select * from cte1 a  full join cte2 b on a.num=b.num2;--8 Records--> total matching and not matching record count from both
   
select * from cte1 a  cross join cte2 b ;--No ON condition in cross join--30 Records-->5*6=30 Records  

 -----------------------
 --How to save the show tables output in table?
show tables in database  ksr_db;
--01c20e81-0307-9f74-0017-5a5f009d94de


show tables in database  ksr_db;
create table abc2 as select * from table(result_scan(last_query_id()));

select (last_query_id());

select * from abc2;
show tables in database  ksr_db;
create or replace table abc2 as 
select * from table(result_scan(last_query_id()));

select * from table(result_scan(last_query_id()));

---------------------------------------
--How to proocess an object in json file?
--Object values key pair
CREATE OR REPLACE TABLE emp_json (
    emp_data VARIANT
);


INSERT INTO emp_json
SELECT PARSE_JSON('{
  "id": 102,
  "name": "Ravi",
  "role": "Python Developer",
  "salary": 80000
}');

INSERT INTO emp_json
SELECT PARSE_JSON('{
  "id": 103,
  "name": "Aswini",
  "role": ["SQL Developer","BI Developer"],
  "salary": 85000
}');
---Fetch data with dot notations
select emp_data:id::NUMBER as emp_id,
emp_data:name::STRING as emp_name,
emp_data:role::STRING as emp_role,
emp_data:salary::NUMBER as emp_sal
from emp_json;

--filter data with dot notations
SELECT *
FROM emp_json
WHERE emp_data:role = 'Data Engineer';


--Convert JSON Object to Structured Columns
CREATE OR REPLACE TABLE emp_structured AS
SELECT
    emp_data:id::NUMBER   AS emp_id,
    emp_data:name::STRING AS emp_name,
    emp_data:role::STRING AS role,
    emp_data:salary::NUMBER AS salary
FROM emp_json;

select * from emp_structured;

desc table emp_json;

--Array Values
--FLATTEN is used when the JSON contains an ARRAY and you want to convert array elements into rows.
CREATE OR REPLACE TABLE orders_json (
    data VARIANT
);

INSERT INTO orders_json
SELECT PARSE_JSON('{
  "order_id": 101,
  "name": [
    {"product": "Laptop", "price": 80000},
    {"product": "Mouse", "price": 1500}
  ]
}'
);

select * from orders_json;

SELECT
    data:order_id::INT AS order_id,
    item.value:product::STRING AS product,
    item.value:price::NUMBER AS price
FROM orders_json,
LATERAL FLATTEN(input => data:name) item;


select * from orders_json;

select data:order_id::INT as id,
item.value:product::STRING as product
from orders_json,
lateral flatten(input => data:name) item;

---------------------------------------------------
---grade wise sal

create or replace table emp_sal_grade 
(emp_id integer,
emp_name varchar(100),
emp_salary integer);

insert into emp_sal_grade(emp_id,emp_name,emp_salary) values 
(1,'Vijay',3540),(2,'Raj',1540),(3,'Ravi',2330),(4,'Anessh',2240),(5,'Gopal',3240),(6,'Arjun',5240);

--grade
-->A--Sal between 1000 to 1999
-->B--Sal between 2000 to 2999
-->C--Sal betwen 3000 to 3999
--else d
create table sal_grade (grade varchar(10),min_sal integer,max_sal integer);

insert into sal_grade values
('A',1000,1999),('B',2000,2999),('C',3000,3999),('D',4000,4999);

select * from sal_grade;

select emp_id,emp_name,emp_salary,grade
from emp_sal_grade e left join sal_grade g
on  emp_salary between min_sal and max_sal
order by grade;

----------------------------------------------------
---->Numbers
create table test1 (id integer);
insert into test1 values (1),(2),(3),(4);

select * from test1;

--O/P 1234
select listagg(id) from test1;

--O/P 1,2,3,4
select listagg(id,',') as ord from test1;

--O/P 4,3,2,1
select listagg(id,',') within group (order by id desc) ord from test1 ;

select * from sys.columns
where table_name = 'test1';

show tables like 'test1';
-------------------------
ALTER table test1
SET DATA_RETENTION_TIME_IN_DAYS = 1;

desc table sal_grade;

merge into target_tb a
using source_tb b
on a.id = b.id
when matched then
update set a.col=b.col,
a.col=b..col
when not matched then 
insert(col1,col2,..)
values(1,2);


merge into t1 a
using t2 b
on a.col=b.col
and a.is_current = True
when matched then
update set a.col=b.col;


----------------------
-->Count(*)--Count the all values including null values 
-->Count(col name)--Count the column values excluding null values

select count(*) from test1;

select count(id) from test1;

-----------Stream will captures the CDC of insert,delete,updated

CREATE OR REPLACE STREAM test_stream
ON TABLE test1;

select * from test1;

delete from test1 where id=9;
update test1 set id=9 where id=8;

insert into test1 values(8);
select count(id) from test1;

select * from test_stream;

----------Pivot and Unpivot
create or replace table pivot_table 
(region varchar(10),quarter varchar(10),amount integer);

insert into pivot_table(region,quarter,amount) values 
('West','Q1',200),('East','Q1',400),('South','Q1',600),('South','Q2',700),('West','Q2',300),('East','Q2',500);

select * from pivot_table;


---Pivot converts row values into columns.
SELECT *
FROM pivot_table
PIVOT (
        SUM(amount)
    FOR quarter IN ('Q1', 'Q2')
);

--Univot converts columns into rows.

create or replace table unpivot_table as
SELECT *
FROM pivot_table
PIVOT (
        SUM(amount)
    FOR quarter IN ('Q1', 'Q2')
);

select * from unpivot_table;

SELECT *
FROM unpivot_table
UNPIVOT (
    amount FOR quarter IN (Q1, Q2)
);

/*Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:

Equilateral: It's a triangle with  sides of equal length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle*/


SELECT
    CASE
        WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
        WHEN A = B AND B = C THEN 'Equilateral'
        WHEN A = B OR B = C OR A = C THEN 'Isosceles'
        ELSE 'Scalene'
    END AS triangle_type
FROM TRIANGLES;

---------Exchange Seats of Students
create or replace table seats_ex
(id integer, name varchar(10));

insert into seats_ex(id,name) values 
(1,'A'),(2,'B'),(3,'C'),(4,'D'),(5,'E');
;

select * from seats_ex;

SELECT
    id,
    CASE
        WHEN id % 2 = 1 THEN LEAD(name, 1, name) OVER (ORDER BY id)
        ELSE LAG(name) OVER (ORDER BY id)
    END AS student
FROM seats_ex;

---
Even Numbers 
Mod(Col,2) = 0 
col%2 = 0 ;
----------
--Query the list of CITY names starting with vowels (i.e., a, e, i, o,u) from STATION. Your result cannot contain duplicates
select distinct city from station
where left(city,1) in ('a', 'e', 'i', 'o', 'u');


select distinct city from station
where substr(city,1,1) in ('a', 'e', 'i', 'o', 'u');


Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.

select distinct city from station
where right(city,1) in ('a', 'e', 'i', 'o', 'u');


--You have a Snowflake table with customer purchase data. Write a SQL query to identify customers who made their first --purchase in 2023 and their total spending since then

WITH purchase_cte AS (
    SELECT
        customer_id,
        purchase_date,
        purchase_amount,
        MIN(purchase_date) OVER (PARTITION BY customer_id) AS first_purchase_date
    FROM customer_purchases
)
SELECT
    customer_id,
    first_purchase_date,
    SUM(purchase_amount) AS total_spending
FROM purchase_cte
WHERE YEAR(first_purchase_date) = 2023
GROUP BY customer_id, first_purchase_date
ORDER BY total_spending DESC;

---
select last_day(order_date) from orders ;
----------
----Dataset prep
CREATE OR REPLACE TABLE match_results (
 match_id   INT ,
 team1      VARCHAR(50),
 team2      VARCHAR(50),
 winner     VARCHAR(50),        -- NULL for draw
 result     VARCHAR(20),        -- 'WIN', 'DRAW', 'NO_RESULT'
 match_date DATE
);
INSERT INTO match_results (match_id, team1, team2, winner, result, match_date) VALUES
-- India matches
(1,  'IND', 'AUS', 'IND',  'WIN',  '2024-01-01'),
(2,  'IND', 'ENG', NULL,   'DRAW', '2024-01-03'),
(3,  'IND', 'SA',  'IND',  'WIN',  '2024-01-05'),
(4,  'AUS', 'ENG', 'AUS',  'WIN',  '2024-01-02'),
(5,  'AUS', 'SA',  NULL,   'DRAW', '2024-01-04'),
(6,  'ENG', 'SA',  'ENG',  'WIN',  '2024-01-06'),
(7,  'IND', 'NZ',  'NZ',   'WIN',  '2024-01-07'),
(8,  'PAK', 'SL',  NULL,   'DRAW', '2024-01-08');

select * from match_results;
--o/p Eaxample
--Team-IND, Played-4,wins-2,losss-1,Draws-1,Points-5

With match_points as ( select team1 as team, winner, result from match_results 
union all
Select team2 as team, winner, result from match_results)
Select team, count(*) as played,
Sum (case when team= winner then 1 else 0 end) as Wins,
Sum( case when result = 'DRAW' then 1 else 0 end) as draws,
Sum ( case when team <> winner and result<> 'DRAW' then 1 else 0 end) as losses,
Sum (case when team =winner then 2
When result = 'DRAW' then 1 else 0 end) as points 
From match_points
Group by team
order by points desc;

---
--customer_id | business_date | updated_ts | amount
--Question:
--Write a SQL query to keep only the latest record per customer per day.

select current_timestamp;

Create or replace table transactions
(customer_id int,business_date date,update_ts timestamp,amount int);

insert into transactions (customer_id,business_date,update_ts,amount) values
(101,'2026-02-02','2026-02-02 18:10:32.302 -0800',18),(101,'2026-02-02','2026-02-02 20:10:32.302 -0800',20),
(102,'2026-01-18','2026-01-18 18:10:32.302 -0800',22),(102,'2026-01-18','2026-01-18 23:10:32.302 -0800',24),
(103,'2025-12-14','2025-12-14 12:10:32.302 -0800',25),(103,'2025-12-14','2025-12-14 10:10:32.302 -0800',26);

--Without updated timestamp
select customer_id,business_date,max(business_date) from transactions
group by 1,2;

--with updated timestamp
SELECT customer_id,business_date,update_ts,amount FROM 
(SELECT *,ROW_NUMBER() OVER (PARTITION BY customer_id, business_date ORDER BY update_ts DESC) AS rn FROM transactions)
WHERE rn = 1;

select * from transactions 
qualify row_number() over (PARTITION by customer_id,business_date order by update_ts desc) =1;

--write SQL query to get price corrospounding to latest purchase date for each column id

Create or replace table purchase_price
(ID int,purchase_date date,price int);

insert into purchase_price (id,purchase_date,price) values
(101,'2026-02-02',18),(101,'2026-02-03',20),(102,'2026-01-18',22),
(102,'2026-01-20',24),(103,'2026-12-14',25),(103,'2025-12-15',26);

select * from purchase_price;

select * from 
(select *,row_number() over(partition by id order by purchase_date desc) rnk from purchase_price)
where rnk=1;

select * from purchase_price qualify row_number() over(partition by id order by purchase_date desc)=1;


--Find users whose transaction amount is strictly increasing day over day.
--user_id | txn_date | amount

create or replace table transactions2 
(user_id int,txn_date date,amount int);

insert into transactions2 (user_id,txn_date,amount) values
(101,'2026-02-02',18),(101,'2026-02-03',20),(102,'2026-01-18',22),
(102,'2026-01-20',24),(103,'2026-12-14',25),(103,'2026-12-15',26),
(104,'2026-04-16',22),(104,'2026-04-18',27),(105,'2026-01-15',28);

select * from transactions2;

SELECT DISTINCT user_id
FROM (SELECT user_id,txn_date,amount,LAG(amount) OVER (PARTITION BY user_id ORDER BY txn_date) AS prev_amount
    FROM transactions2) 
WHERE prev_amount IS NOT NULL
GROUP BY user_id
HAVING MIN(amount - prev_amount) > 0;

with cte1 as 
( select *,lag(amount) over(partition by user_id order by txn_date) as prv_amount from transactions2)
select user_id from cte1
where PRV_AMOUNT is not null
group by user_id
having min(amount-PRV_AMOUNT)>0;

---Find count P values 
create or replace table test_table
(Col1 varchar(1),Col2 varchar(1),Col3 varchar(1),Col4 varchar(1));

insert into test_table values
('A','B','P','D'),('P','G','P','F'),('R','P','C','U'),('P','O','I','P');

select * from test_table;

select * from test_table;

select sum(regexp_count(concat(col1,col2,col3,col4),'P')) as p_count from test_table;

select regexp_count(listagg(concat(col1,col2,col3,col4)),'P')  as p_count from test_table;

--Temprature 
--How to find out all the ID's where temp was higher then previous day
--id | record_date | temp

create or replace table temp_table 
(id int,record_dt date,temp int);

insert into temp_table(id,record_dt,temp) values 
(1,'2025-10-01',20),(2,'2025-10-02',25),(3,'2025-10-04',22),
(4,'2025-10-05',30),(5,'2025-10-06',28),(6,'2025-10-08',26);

--truncate table temp_table;

select * from temp_table;


select id from 
(select *,lag(temp) over( order by record_dt) as rnk from temp_table)
--group by id
where temp>rnk;


---Numer and Null joins

create  table t1  (id int);
truncate table t1;

create table t2  (id int);
truncate table t2;

insert into t1 values (1),(1),(1),(NULL),(NULL);--6

select * from t1;


insert into t2 values (1),(1),(NULL);--4

select * from t2;

select * from t1 a  join t2 b on a.id=b.id;

--inner 6 ,Rigt 7, left 8, outer 9

----inner 12 ,Rigt 13, left 14, outer 15

--Running total
create or replace table emp_transactions
(transaction_id int,type varchar(20),amount int,transaction_date date);

insert into emp_transactions(transaction_id,type,amount,transaction_date) values
(1,'deposit',5000,'2026-02-02'),(2,'withdrawal',1500,'2026-02-03'),(3,'deposit',2000,'2026-02-05'),(4,'withdrawal',1000,'2026-02-06'),(5,'deposit',4000,'2026-02-07');


select * from emp_transactions;

Select transaction_id,type,amount,transaction_date,sum(case when type='deposit' then amount
	 when type='withdrawal' then -amount end) over(order by transaction_date,transaction_id) as runningtotal
		from emp_transactions
		order by transaction_date;
 
SELECT transaction_id,type, amount,transaction_date,
    SUM( CASE WHEN type = 'deposit' THEN amount
            ELSE -amount END) OVER (ORDER BY transaction_date, transaction_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS running_total
FROM emp_transactions ORDER BY transaction_date, transaction_id;

-----Write SQL query to find customers who have made two consecutive orders?

SELECT DISTINCT customer_id
FROM (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS prev_order_date
    FROM ORDERS
) t
WHERE order_date = prev_order_date + INTERVAL '1 day';

--prev_order_date + INTERVAL '1 day' checks whether the current order date is exactly one day after the previous order, identifying consecutive-day orders.

-->Find patients who switched insurance providers between 2024 and 2025

--A patient is considered switched if they had more than one provider during that period.

SELECT patient_id
FROM insurance_history
WHERE start_date <= '2025-12-31'
  AND end_date   >= '2024-01-01'
GROUP BY patient_id
HAVING COUNT(DISTINCT provider_name) > 1;

-->Average claim amount per provider (only providers with >100 claims)

SELECT
    provider_name,
    AVG(claim_amount) AS avg_claim_amount,
    COUNT(*) AS total_claims
FROM claims
GROUP BY provider_name
HAVING COUNT(*) > 100;

--Find duplicate patient records (name, DOB, address)
SELECT
    patient_name,
    dob,
    address,
    COUNT(*) AS duplicate_count
FROM patients
GROUP BY patient_name, dob, address
HAVING COUNT(*) > 1;

--Miratech
---If you want every team to play against every other team (like a round-robin), you can use a self join

create or replace table cricket_name 
(team_name varchar);

insert into cricket_name values('IND'),('PAK'),('AUS');

SELECT  a.team_name AS team_a,
        b.team_name AS team_b
FROM cricket_name a
JOIN cricket_name b
    ON a.team_name > b.team_name;

--Number of Shipments Per Months
CREATE TABLE shipments (
    shipment_id INT,
    sub_id INT,
    weight INT,
    shipment_date DATE
);

INSERT INTO shipments VALUES
(101, 1, 10, '2021-08-30'),
(101, 2, 20, '2021-09-01'),
(101, 3, 10, '2021-09-05'),
(102, 1, 50, '2021-09-02'),
(103, 1, 25, '2021-09-01'),
(103, 2, 30, '2021-09-02'),
(104, 1, 30, '2021-08-25'),
(104, 2, 10, '2021-08-26'),
(105, 1, 20, '2021-09-02');

select * from shipments;

SELECT 
    TO_CHAR(shipment_date, 'YYYY-MM') AS month,
    COUNT(DISTINCT shipment_id) AS total_shipments
FROM shipments
GROUP BY month
ORDER BY month;


select month,count(unk_id) from (
SELECT 
TO_CHAR(shipment_date, 'YYYY-MM') AS month,
concat(shipment_id || sub_id) as unk_id
FROM shipments)
group by 1;



--- First American India
--- Find who participated in 3 consecutive years.
Year	PID
-----------
2003	1
2004	1
2005	1
2008	2
2009	2;

create table year_pid_1
(year number,pid number);

insert into year_pid_1(year,pid) values
(2003,1),(2008,1),(2005,1),(2008,2),(2009,2);

select PID,count(*)
from 
(SELECT 
PID,
YEAR,
ROW_NUMBER() OVER(PARTITION BY PID ORDER BY YEAR) AS GP
from year_pid )
GROUP BY PID
HAVING COUNT(*)>=3;


select PID,count(*)
from 
(SELECT 
PID,
YEAR,
YEAR-ROW_NUMBER() OVER(PARTITION BY PID ORDER BY YEAR) AS GP
from year_pid_1 )
GROUP BY PID
HAVING COUNT(*)>=3;


---------With out using windowa 2nd highest sal
SELECT EMP_ID,EMP_NAME,SALARY FROM EMPLOYEE
WHERE SALARY =
(SELECT MAX(SALARY) FROM EMPLOYEE
WHERE SALARY < (SELECT MAX(SALARY) FROM EMPLOYEE));

id Name
------ 
1  Anand
1  Anand
1  Anand
2  Bill
2  Bill
2  Bill
2  Bill
3  Chris
3  Chris;

 CREATE TABLE employees (
    id INT,
    name VARCHAR(50)
);

INSERT INTO employees (id, name) VALUES
(1, 'Anand'),
(1, 'Anand'),
(1, 'Anand'),
(2, 'Bill'),
(2, 'Bill'),
(2, 'Bill'),
(2, 'Bill'),
(3, 'Chris'),
(3, 'Chris');

 select * from (
select id,name,
ROW_NUMBER() over(PARTITION by id,name order by id) rnk
 from employees )
 where rnk<=2;

 --Without subquery
 select id,name
 from employees
 qualify ROW_NUMBER() over(PARTITION by id,name order by id)<=2;

 ---
 DELETE FROM employees
WHERE (id, name) IN (
    SELECT id, name
    FROM (
        SELECT id,
               name,
               ROW_NUMBER() OVER (PARTITION BY id, name ORDER BY id) AS rn
        FROM employees
    ) t
    WHERE rn > 1
);
 

  ------EMPLOYEE TABLE------------(PAIRS)
emp_id	emp_name	dept
----------------------------
1 	Alice		IT
2 	Bob 		IT
3 	Charlie 	IT
4 	David 		HR
5 	Eve 		HR

;
CREATE TABLE emp (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept VARCHAR(20)
);

INSERT INTO emp (emp_id, emp_name, dept) VALUES
(1, 'Alice', 'IT'),
(2, 'Bob', 'IT'),
(3, 'Charlie', 'IT'),
(4, 'David', 'HR'),
(5, 'Eve', 'HR');

select * from emp;

select e1.emp_name as emp1,e2.emp_name as emp2,e1.dept from emp e1 
 join emp e2 on e1.dept=e2.dept
where e1.emp_name < e2.emp_name
 ;