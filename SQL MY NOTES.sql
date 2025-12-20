 
 SELECT * FROM EMP WHERE /*SAL=3000 AND*/ DEPTNO=20
 
 --In v/s Any
select * from emp where deptno in (10,20)

select * from emp where deptno=10 or deptno=20

select * from emp where deptno=10
union all
select * from emp where deptno=20
---
select * from emp where deptno =any  (10,20)
--greater than smallest number
select * from emp where deptno >any  (10,20)
--greater than or equal to smallest number
select * from emp where deptno >=any  (10,20)
--lesser than greatest number
select * from emp where sal <any (1000,2000)
select * from emp where sal<1000 or sal<2000
--lesser than or equal to greatest number
select * from emp where sal <=any (1000,2000)
--not equal to any all recoreds
select * from emp where deptno <>any  (10,20)
 
 create table emp as select * from scott.emp
----CONCATINATION
---|| CONCATINATION INTO STRING TO STRING OR STRING TO CHAR

select ename || ' is working ' || job || ' having sal ' || sal || ' in deptno '|| deptno emp_info from emp 
where deptno in (10,20) 
order by deptno desc

select ename,sal,deptno,job,sal+nvl(comm,0) monthlysal,(sal+nvl(comm,0))*12 annul_sal,(sal+nvl(comm,0))*12*5 five_years_sal from emp
where deptno in (10,20) 
order by  3 asc, 7 desc

select * from emp order by comm desc

select emp.*, sal+nvl(comm,0) monthly_sal,(sal+nvl(comm,0))*12 annual_sal from emp 
order by deptno asc, 10 desc

select emp.*,sal+nvl(comm,0) monthly_sal,(sal+nvl(comm,0))*12 annual_sal from emp 
where (sal+nvl(comm,0))*12 < 25000 
order by deptno,comm desc

select ename || ' is working as ' || job || ' having sal ' || sal || ' in deptno ' || deptno emp_info,
SAL+NVL(COMM,0) MONTHLY_SAL,(SAL+NVL(COMM,0))*12 ANUAL_SAL from emp 
where job ='MANAGER' ORDER BY 3
---------------
SET OPERATORS
-----------
SAME COLUMN,SAME DATA TYPE
**UNION--WITHOUT DUPLICATE
**UNION ALL--WITH DUPLICATE
**INTERSECT--COMMON RECORDS
**MINUS --OUT OF COMMON RECORDS

SELECT DEPTNO FROM EMP
UNION
SELECT DEPTNO FROM SCOTT.DEPT
/
SELECT DEPTNO FROM EMP
UNION ALL
SELECT DEPTNO FROM SCOTT.DEPT
/
SELECT DEPTNO FROM EMP
INTERSECT
SELECT DEPTNO FROM SCOTT.DEPT
/
SELECT DEPTNO FROM EMP
MINUS
SELECT DEPTNO FROM SCOTT.DEPT
================================
-----GROUP BY

create table emp as select * from scott.emp
 
 select * from emp
 
 select avg(comm),avg(sal) from emp where deptno=30
 
 ---aggregative records
 
 avg
 min 
 max
 sum
 
 
 
 select sum(comm) from emp
 
 select count (deptno) from emp

SELECT COUNT(DISTINCT JOB) FROM EMP
SELECT COUNT(DISTINCT DEPTNO) FROM EMP
 
 
 select count(empno) from emp
 
select count(comm) from emp

select count(empno),avg(sal),min(sal),max(sal),avg(comm) from emp

select max(sal),avg(comm) avg,count(empno),deptno from emp group by deptno order by deptno

select max(sal),deptno from emp where deptno<>30 group by deptno order by deptno 

-- count aggregated functions always retruns values if no data found it returns zero
-- other aggregated fUnction returns null for no data 

select nvl(max(sal),0) , nvl(min(sal),0), count(empno), round( avg(sal)), sum(sal)
from emp where deptno=100;

select max(sal) , min(sal), count(empno), round( avg(sal)), sum(sal)
from emp where deptno=100;

select to_char(hiredate,'yyyy'),count(empno) from emp group by to_char(hiredate,'yyyy')

----MULTI COLUMN GROUP BY

select count(job),job from emp group by job

SELECT COUNT(EMPNO),DEPTNO,JOB FROM EMP GROUP BY DEPTNO,JOB ORDER BY DEPTNO ASC,JOB ASC

SELECT COUNT(EMPNO),DEPTNO,JOB FROM EMP GROUP BY DEPTNO,JOB ORDER BY DEPTNO ASC ,JOB ASC

SELECT COUNT(EMPNO),MAX(SAL),MIN(SAL),AVG(COMM),SUM(SAL),DEPTNO,JOB 
FROM EMP GROUP BY DEPTNO,JOB 
ORDER BY DEPTNO ASC,JOB ASC

---HAVING CLUASE

SELECT MAX(SAL) ,MIN(SAL),JOB,DEPTNO----5
FROM EMP -----1
WHERE JOB = 'MANAGER'---2
GROUP BY JOB,DEPTNO---3
HAVING MAX(SAL)  < 3000---4 
ORDER BY DEPTNO----6

select count(empno),max(sal),deptno,job from emp where job = 'SALESMAN' 
group by deptno,job 
having max(sal)<2000 order by deptno 

--ROLLUP

select deptno,sum(sal), (select sum(sal) from emp) from emp group by deptno

select deptno ,sum(sal) from emp
group by deptno
union
select null,sum(sal) from emp

select round(avg(sal)), deptno from emp group by rollup(deptno)

select round(avg(sal)) avg_sal,nvl(to_char(deptno),'avg_sal_table') deptno from emp group by rollup(deptno)

select sum(sal),job from emp group by rollup(job)

select max(sal),nvl(job,'max_sal_table') from emp group by rollup(job)

SELECT SUM(SAL),TO_CHAR(HIREDATE,'YYYY') FROM EMP GROUP BY TO_CHAR(HIREDATE,'YYYY')

SELECT SUM(SAL),NVL(TO_CHAR(HIREDATE,'YYYY'),'TOT_SAL') FROM EMP GROUP BY ROLLUP(TO_CHAR(HIREDATE,'YYYY'))
HAVING SUM(SAL)<5000 ORDER BY 2

---MULTI COLUMN ROLLUP

SELECT MAX(SAL), NVL(JOB,'MAX_TABLE'),NVL(TO_CHAR(DEPTNO),'MAX_SAL_IN_JOB') FROM EMP 
GROUP BY ROLLUP(JOB,DEPTNO) ORDER BY DEPTNO

SELECT MAX(SAL), NVL(JOB,'MAX_TABLE'),NVL(TO_CHAR(DEPTNO),'MAX_SAL_IN_DEPT') FROM EMP 
GROUP BY CUBE(JOB,DEPTNO) ORDER BY DEPTNO

SELECT SUM(SAL), NVL(JOB,'SUM_TABLE'),DEPTNO FROM EMP 
GROUP BY ROLLUP(DEPTNO,JOB) ORDER BY DEPTNO

SELECT SUM(SAL), NVL(JOB,'SUM_TABLE'),NVL(TO_CHAR(DEPTNO),'SUM_SAL_IN_JOB') FROM EMP 
GROUP BY CUBE(DEPTNO,JOB) ORDER BY DEPTNO


SELECT DEPTNO,
TO_CHAR(SUM(SAL),'99G999D99') DEPT_TOT,
TO_CHAR(AVG(SAL),'99G999D99') DEPT_AVG
FROM EMP
GROUP BY ROLLUP(DEPTNO)


----DATE

SYSDATE :DATE DATA TYPE CONVERTNIG INTO STRING TYPE
TO_CHAR: DATE INTO DIFFERENT FORMAT OR DATE INTO STRING FORMAT

ALTER SESSION SET NLS_DATE_FORMAT='DD-MONTH-YY'
ALTER SESSION SET NLS_DATE_FORMAT='DAY-MON-YYYY'

SELECT to_char(SYSDATE,'d') FROM DUAL---day of week (1..7) 1=sun,2=mon


select to_char(sysdate,'dd/MON/yyyy') from dual
select to_char(sysdate,'day/mm') from dual
----DAY
select sysdate,
to_char(SYSDATE,'d'), ---day of week (1..7) 1=sun,2=mon
to_char(SYSDATE,'ddd'),---day of year (
to_char(sysdate,'DAY'),
to_char(sysdate,'dd'),
to_char(sysdate,'day'),
to_char(sysdate,'Day'),
to_char(sysdate,'dy')
from dual

---MONTH
SELECT SYSDATE,
to_char(sydate,'rm'),--roman number of mounth
TO_CHAR(SYSDATE,'MM'),
TO_CHAR(SYSDATE,'MONTH'),
TO_CHAR(SYSDATE,'Month'),
to_char(sysdate,'month')
from dual
/
----YEAR
select sysdate,
to_char(SYSDATE,'q'), ---quater in year
to_char(SYSDATE,'cc') ---centure
to_char(sysdate,'yy') numericyear,
to_char(sysdate,'yyyy') numericyear4,
to_char(sysdate,'year'),
to_char(sysdate,'YEAR')
FROM DUAL
/
----WEEK
SELECT SYSDATE,TO_CHAR(SYSDATE,'W'),---WEEK OF MONTH ,WEEK STRAT WITH FIRST OF MONTH
TO_CHAR(SYSDATE,'WW'),--WEEK OF YEAR ,WEEK STRAT WITH FIRST OF YEAR
TO_CHAR(SYSDATE,'IW')--WEEK OF YAER,WEEK STRAT WITH FIRST DAY OF YEAR FROM MON
FROM DUAL

SELECT SYSDATE,TO_CHAR(SYSDATE,'DD-MON-YY') CURRENTDATE,
TO_CHAR(SYSDATE,'dd/mm-year'),to_char(sysdate,'mon/dy/yy') FROM DUAL

select  * from emp where to_char(hiredate,'mon') ='feb'
select * from emp where to_char(hiredate,'yyyy') = 1987
select * from emp where to_char(hiredate,'yyyy') between 1981 and 1987
select count(empno),hiredate from emp group by hiredate

select count(empno),to_char(hiredate,'yy') joined_year from emp
group by to_char(hiredate,'yy')
HAVING count(empno)>5

select count(empno),to_char(hiredate,'Mon') joined_month from emp
group by to_char(hiredate,'Mon') 
ORDER BY 2

SELECT COUNT(EMPNO),TO_CHAR(HIREDATE,'MON-YYYY') FROM EMP GROUP BY TO_CHAR(HIREDATE,'MON-YYYY') ORDER BY 2
SELECT E.*, 
TO_CHAR(HIREDATE,'DAY') JOININGDAY,
TO_CHAR(HIREDATE,'MON') JOININGMONTH,
TO_CHAR(HIREDATE,'YY') JOININGYEAR 
FROM EMP E

----DATE+TIME 

SELECT SYSDATE,
TO_CHAR(SYSDATE,'HH') HOUR_OF_DAY,
TO_CHAR(SYSDATE,'HH12')HOUR_OF_DAY,
TO_CHAR(SYSDATE,'HH24') HOUR_OF_DAY,
TO_CHAR(SYSDATE,'MI') MINUTS,
TO_CHAR(SYSDATE,'SS') SECONDS,
TO_CHAR(SYSDATE,'SSSSS') SECOND_PAST_MIDNIGHT,
TO_CHAR(SYSDATE,'TS') TIME_SHORT,
TO_CHAR(SYSDATE,'DL') DATE_LONG,
TO_CHAR(SYSDATE,'AM') AM_PM,
TO_CHAR(SYSDATE,'DS') DATE_SHORT,
TO_CHAR(SYSDATE,'HH-MI-SS') TODAY_TIME ,
TO_CHAR(SYSDATE+ 1/24,'HH-MI-SS') NEXT_24
FROM DUAL
/
---find FIRST and last day of month
select to_char(last_day(sysdate),'day'),to_char(trunc(sysdate,'mm'),'day'),
trunc(to_date('20-08-2020','dd-mm-yyyy'),'mm') from dual
/
SELECT TO_CHAR(SYSDATE,'HH-MI-SS'),
TO_CHAR(SYSDATE+ 1/24,'HH-MI-SS')
FROM DUAL
-- arrenage people in the order of join month
select emp.*, to_char(hiredate, 'mm') joiningmonth
from emp
order by  joiningmonth
/
HH  = HOUR OF DAY (1-12)
HH12 = HOUR OF DAY (1-12)
HH24 = HOUR OF DAY (1-24)
MI   = MINUTES (0-59)
SS  =  SECONDS (0-59)
SSSSS = SECONDS PAST MIDNIGHT
TS     = TIME IN LONG FORMATE
AM    = AM/PM
DL    =   DATE IN LONG FORMAT
DS    =  DATE IN SHORT FORMAT

/
----DATE FUNCTIONS
1.TO_DATE:CONVARTING STRING INTO DATE OR REVERS OF TO_CHAR
2.ADD_MONTHS:ADD MONTS
3.MONTHS_BETWEEN: NO OF MONTHS BETWEEN TO DATES
4.LAST_DAY : LAST DAY OF GIVEN MONTH
5.NEXT_DAY: AFTER NEXT FIVE DAYS DATE 

TO_DATE : CONVARTING STRING INTO DATE OR REVERS OF TO_CHAR
TRUNC: REMOVES TIME PART

---TRUNC IT WILL CUT AFTER DECIMAL POINT 
SELECT TRUNC(12.5) FROM DUAL --O/P 12

--ROUND WILL ROUND NEXT VALUE
SELECT ROUND(12.5) FROM DUAL--O/P 13

select trunc(to_date(sysdate,'dd/mon/yyyy'),'day') dt,
        trunc(to_date(sysdate,'dd/mon/yyyy'),'month') mn,
        trunc(to_date(sysdate,'dd/mon/yyyy'),'yyyy') yy
from dual 
/
select round(to_date(sysdate,'dd/mon/yyyy'),'day') dt,
       round(to_date(sysdate,'dd/mon/yyyy'),'month') mn,
       round(to_date(sysdate,'dd/mon/yyyy'),'yyyy') yy
from dual
/
select trunc(987654321.155456,1),trunc(987654321.155456,2),trunc(987654321.155456,3) from  dual
/
select round(987654321.155456,1),round(987654321.155456,2),round(987654321.155556,3) from  dual
/
---th=1st,2nd
select to_char(sysdate,'ddth mm yyyy'),
       to_char(sysdate,'ddth mmth yyyy'),
       to_char(sysdate,'ddth mm yyyyth')
from dual
/
select to_char(sysdate,'ddspth mm yyyy'),
       to_char(sysdate,'ddth mmspth yyyy'),
       to_char(sysdate,'ddth mmth yyyyspth')
from dual
/
SELECT TO_CHAR(SYSDATE+1/24,'DD/MM/YY HH24:MI:SS AM/PM') FROM DUAL
select * from emp
select sysdate from dual
select to_char(sysdate ,'day') from dual
select to_char(sysdate,'mon/dy/year') from dual

select emp.*,to_char(hiredate,'dd/mon/yy') from emp

select ename,job,to_char(hiredate,'yy') from emp
where to_char(hiredate,'yy') 
between 81 and 87 
order by 3

select ename,deptno,to_char(hiredate,'mon'),job from emp 
where to_char(hiredate,'mon') = 'dec' 
order by 1

select emp.*,to_char(hiredate,'dd/mm/yy') from emp where job='MANAGER' 

SELECT COUNT(EMPNO),HIREDATE FROM EMP GROUP BY HIREDATE HAVING COUNT(EMPNO)>1

SELECT TO_CHAR(SYSDATE+1/24,'DD/MM/YY HH24:MI:SS AM/PM') FROM DUAL

SELECT TO_DATE('03/09/21 12:12:12','DD/MM/YY HH:MI:SS'),TO_DATE('03/09/21','MM/DD/YY') FROM DUAL

SELECT SYSDATE,ADD_MONTHS (SYSDATE ,3),ADD_MONTHS (SYSDATE,-3) FROM DUAL

SELECT SYSDATE,ADD_MONTHS (SYSDATE,5),ADD_MONTHS(SYSDATE,-3),
MONTHS_BETWEEN (TO_DATE('03-JAN-22','DD-MON-YY'), SYSDATE ) FROM DUAL

SELECT ENAME,HIREDATE,TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)) MONTHS_OF_JOINING FROM EMP

SELECT ENAME,HIREDATE,TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)) MONTHS_OF_JOINING,
TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)/12) YEARS FROM EMP

SELECT SYSDATE,NEXT_DAY(SYSDATE,5),LAST_DAY(SYSDATE) FROM DUAL

SELECT SYSDATE,NEXT_DAY(SYSDATE,5),LAST_DAY(SYSDATE) FROM DUAL

SELECT LAST_dAY(ADD_MONTHS(SYSDATE,1)),LAST_DAY(SYSDATE) FROM DUAL

SELECT LAST_DAY(ADD_MONTHS(SYSDATE,3)) FROM DUAL
SELECT * FROM EMP WHERE TRUNC(HIREDATE)='17-NOV-81' 

select
trunc(sysdate),
trunc(sysdate , 'mm'),
trunc(sysdate , 'q'),
trunc(sysdate , 'y')
from dual;

SELECT * FROM EMP WEHRE 


SELECT ENAME,HIREDATE,TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)),TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)/12)
FROM EMP WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)/12)<35

SELECT ENAME,HIREDATE,TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)) FROM EMP 
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)) BETWEEN 400 AND 500

---last_day

SELECT LAST_DAY(ADD_MONTHS( TRUNC(SYSDATE,'Y'),11)) LAST_DAY_OF_YEAR FROM DUAL

select last_day(trunc(add_months(hiredate,abs((to_char(hiredate,'mm')-(12)))))) as last_day from emp

----LIKE

 SELECT * FROM EMP WHERE ENAME LIKE 'A%'
 SELECT * FROM EMP WHERE ENAME LIKE '%A%'
 SELECT * FROM EMP WHERE ENAME LIKE '_A%'
 SELECT * FROM EMP WHERE ENAME LIKE '%LL_%'
 SELECT * FROM EMP WHERE ENAME LIKE '__R%R'
 
 
----NVL: IT REPLALCE ONLY NULL VALUES WITH DATA TYPE
----NVL2: IT REPLALCE NULL VALUES AS WELL AS NON NULL VALUES
SELECT * FROM  EMP

 SELECT ENAME,SAL,DEPTNO,COMM,NVL2(ENAME,SAL,COMM) FROM EMP
  SELECT ENAME,SAL,DEPTNO,COMM,NVL2(COMM,ENAME,SAL) FROM EMP
  
  create table test
(
c1  int,
c2	int,
c3 int
);

insert all
 into test  values(0,0, 1000)
  into test  values(null,null, 2000)
  into test  values(null,0, null)
  into test  values(0,0, null)
  into test  values(0,null, 0)
  into test  values(null,null, null)
select * from dual;

SELECT C1,C2,C3,NVL2(C1,C2,C3) FROM TEST
SELECT C2,C3,C1,NVL2(C2,C3,C1) FROM TEST
SELECT C3,C1,C2,NVL2(C3,C1,C2) FROM TEST

----decode:

create table emp as select * from scott.emp
select ename,deptno,decode(deptno,10, 'Ten',20,'TWENTY',30,'THIRTY') DEPTNO_IN_WORDS from emp

SELECT ENAME,DEPTNO,SAL,COMM,
DECODE(DEPTNO,10,(SAL+NVL(COMM,0))*.10,
       20,(SAL+NVL(COMM,0))*.20,
       30,(SAL+NVL(COMM,0))*.30,1000) 
	   EMP_BONUS FROM EMP ORDER BY DEPTNO
									
SELECT ENAME,SAL,DEPTNO,
	DECODE(DEPTNO,10,SAL*1.1,20,SAL*1.2,30,SAL*1.3) RIV_BONUS, 
	DECODE(DEPTNO,40,'NO_BONUS','BONUS_ADDED') STATUS,
	DECODE(DEPTNO,10,SAL*1.1,20,SAL*1.2,SAL*1.3)-SAL BONUS_AMMOUNT
FROM EMP ORDER BY DEPTNO 
									
                                    
                                    
SELECT ENAME,DEPTNO,SAL,COMM,DECODE(COMM,NULL,'COMM IS NULL',SAL+NVL(COMM,0)) FROM EMP 
SELECT EMP.*,DECODE(COMM,NULL,'COMM IS NULL',SAL+NVL(COMM,0))  COMM FROM EMP 

select ename,sal,deptno,decode(deptno,10,'Ten',20,'Twenty',30,'Thirty') deptno_in_words,
decode(sal,5000,'Five thousand',3000,'Three thousand',2000,'Two thousand','other') sal_in_words
 from emp

select 
ename, comm, 
decode(comm, null , 'null','not null')
from emp

  create table t1( name varchar2(10) , gender varchar2(1)) ;
 
insert all
	into t1 values('vinay','M')
    into t1 values('Guru','m')
    into t1 values('Manoj','m')
    into t1 values('Disk','m')
    into t1 values('diya','F')
	into t1 values('Amarjit', NULL)
	into t1 values('manoj','z')
select * from dual;

  
  
  SELECT * FROM T1
  SELECT NAME,GENDER,DECODE(UPPER(GENDER),'M','MALE','F','FEMALE','UNKNOWN') EMP_GENDER FROM T1
  
  SELECT NAME,GENDER,DECODE(LOWER(GENDER),'m','FEMALE','f','MALE','UNKNOWN') EMP_GENDER_CONVERT FROM T1
  
  CREAE fruitcode
-- assignment
create table fruits
( furitcode char(1));

insert all 
 into fruits values('A')
 into fruits values('B')
 into fruits values('C')
 into fruits values('D')
 into fruits values('E')
 into fruits values(null)
select * from dual;

SELECT * FROM FRUITS

SELECT FRUITS.*,DECODE(UPPER(FURITCODE),'A','APPLE','B','BANNAN','C','CHERRY','D','DRAGAN','UNKNOWN') FRUITS_NAME 
FROM FRUITS

---no of emp join in each year 

select to_char(hiredate,'yyyy'),count(empno) from emp group by to_char(hiredate,'yyyy')

---o/p like 1980  1982   ...
             2     3     ...
select sum(decode(TO_CHAR(HIREDATE,'YYYY'),1980,1,0)) "1980",  
       sum(decode(TO_CHAR(HIREDATE,'YYYY'),1981,1,0)) "1981",
       sum(decode(TO_CHAR(HIREDATE,'YYYY'),1982,1,0)) "1982",
       sum(decode(TO_CHAR(HIREDATE,'YYYY'),1987,1,0)) "1987"
from emp 

----------LISTTAGG:listing data in one row from one column

select listagg(ename,',') from emp 

select listagg(job,'/') from emp 


select listagg(ename,',') within group ( order by ename) ename_list from emp 

select deptno,listagg(ename,'/') within group ( order by ename) ename_list from emp group by deptno

select deptno, listagg(job,' !! ') within group(order by sal desc) job_list from emp group by deptno

select job,listagg(ename,'/') within group ( order by ename) ename_list from emp group by job

select max(sal),job,listagg(job,',')  within group (order by job ) list_job from emp group by job

--------RANKING FUNCTION:

--aggregated functions as rank and dense_.

select rank(1500) within group (order by sal desc),
       dense_rank(1500) within group (order by sal desc)
from emp
/
select deptno, rank(1250) within group (order by sal desc),
       dense_rank(1250) within group (order by sal desc)
from emp group by deptno

--analytical functions as rank and dense_rank

SELECT ENAME,DEPTNO,SAL,RANK() OVER (ORDER BY SAL desc ) EMPRANK, 
						dense_rank() OVER (ORDER BY SAL desc ) d_EMPRANK 
						FROM EMP
						ORDER BY EMPRANK asc;

select comm,job ,rank() over (order by comm) emprank from emp

select comm,job ,rank() over (order by comm desc) emprank from emp

select emp.*,rank() over (partition by deptno order by sal desc) ranking,
            dense_rank() over (partition by deptno order by sal desc) d_ranking 
from emp


----COALESCE:IT GIVES THE 1ST NON NULL VALUES

SELECT COMM,SAL,COALESCE(COMM,SAL,100) FROM EMP
SELECT SAL,COMM,COALESCE(SAL,COMM) FROM EMP
SELECT COALESCE(NULL,NULL,NULL,100) FROM DUAL
  
SELECT GREATEST(6,5,20) FROM DUAL
SELECT LEAST(100,250,550) FROM DUAL

----case:The CASE statement goes through conditions and returns a value

---create table emp as select * from scott.emp

select ename,sal,
   case
   when sal<=2000 then 'low sal'
   when sal>=2000 and sal<=4000 then 'mid sal'
   when sal>=4000 and sal<10000 then 'high sal'
 else 'too high sal'
 end sal_range
 from emp order by sal
 
 select emp.*,
 case
    when sal<2500 then 'low sal'
    when sal>2500 then 'mid sal'
    when sal>4000 then 'high sal'
    end sal_range  from emp
    
select emp.*,
case 
when deptno=10 then (sal+nvl(comm,0))*.10
when deptno=20 then (sal+nvl(comm,0))*0.20
when deptno=30 then (sal+nvl(comm,0))*0.30
end bonus
from emp

select ename,sal,
case
    when deptno =10 and sal <2500 then (sal+nvl(comm,0))*.10
    when deptno =20 and sal >2500 then (sal+nvl(comm,0))*.20
    when deptno =30 and sal <2500 then (sal+nvl(comm,0))*.30
    else 0
    end bonus
    from emp;
    
    select ename, sal,deptno,
case
	when deptno =10 and sal < 2500 then (sal + nvl(comm,0))*.20
	when deptno =10 and sal < 2500 then (sal + nvl(comm,0))*.25
	when deptno =20 and sal < 2500 then (sal + nvl(comm,0))*.30
	when deptno =20 and sal > 2500 then (sal + nvl(comm,0))*.27
	when deptno =40 and sal < 2500 then (sal + nvl(comm,0))*.24
	when deptno =30 and sal < 2500 then (sal + nvl(comm,0))*.50
	when deptno =40 and sal > 2500 then (sal + nvl(comm,0))*.10
else 0
end Bonus
from emp;	
    from emp
    
select emp.*,
case 
when deptno = 10 then sal*.1
when deptno =20 then sal*.20
else 0 
end bonus
from emp where deptno  in (10,20)

select emp.*,
case 
when deptno = 10 and sal<3000 then sal*.1
when deptno =20 and sal<3000 then sal*.20
else 0 
end bonus
from emp where deptno  in (10,20) and sal < 3000

---no emp join in each year
select count(empno),to_char(hiredate,'yyyy') from emp group by to_char(hiredate,'yyyy')
/
---o/p like 1980  1982   ...
             2     3     ...
select sum(case 
        when  to_char(hiredate,'yyyy')=1980 then 1
       end) "1980",
       sum(case 
        when  to_char(hiredate,'yyyy')=1981 then 1
       end) "1981",
       sum(case 
        when  to_char(hiredate,'yyyy')=1982 then 1
       end) "1982",
       sum(case 
        when  to_char(hiredate,'yyyy')=1987 then 1
       end) "1987"
from emp;
/
update emp set sal= case sal
when 3000 then 5000
when 5000 then 8000
end 
/
update emp set sal= case sal
when 3000 then 5000
when 5000 then 8000
end where sal in (3000,5000);
-----------------------------

---JOB AS CHANGE MANAGER TO CAHIRMAN
---JOB AS CHANGE SALESMAN TO MANAGER
---JOB AS CHANGE CLERK TO PIVON
---JOB AS CHANGE ANALYST TO CLERK

select emp.*,
case 
    when job='MANAGER' then 'CHAIRAMAN'
    WHEN JOB='CLERK' THEN 'PIVON'
    WHEN JOB='SALESMAN' THEN 'MANAGER'
    WHEN JOB='ANALYST' THEN 'CLERK'
    else 'unknown'
    end job_change from emp WHERE JOB IN ('MANAGER', 'SALESMAN') ORDER BY DEPTNO
    
---GENDER TABLE

create table t1( name varchar2(10) , gender varchar2(1)) ;
 
insert all
	into t1 values('vinay','M')
    into t1 values('Guru','m')
    into t1 values('Manoj','m')
    into t1 values('Disk','m')
    into t1 values('diya','F')
	into t1 values('Amarjit', NULL)
	into t1 values('manoj','z')
select * from dual;

SELECT * FROM T1

--GENDER_FULL
SELECT T1.*,
CASE WHEN UPPER (GENDER)='M' THEN 'MALE' 
     WHEN UPPER (GENDER)='F' THEN 'FEMALE'
     ELSE 'GODS KNOW'
     END GENDER_FULL
     FROM T1
	 
--GENDER_CHANGE
select name,gender,
case when lower(gender)='f' then 'MALE'
     when lower(gender)='m' then 'FEMALE'
     else 'gods know'
     end gender_change from t1
	 
select ename,sal,comm,
case
   when comm is null then sal
   when comm is not null then comm+sal
   else sal 
   end sal_get
   from emp where sal<3000
      order by sal

SELECT empno, sal,
CASE WHEN sal > 3000 THEN 'The sal is greater than 3000'
WHEN sal = 3000 THEN 'The sal is 3000'
ELSE 'The sal is under 3000'
END AS salText
FROM emp order by sal
	 
---string

-- select length('we are working in *infosys*') from dual;

-- select upper('sql') , lower('SQL') , initcap('sql plsql') from dual;
-- select upper(ename) , lower(ename) , initcap(ename) from emp;
--select upper(job),lower(job),initcap(job) from emp


-- 12345678910
-- ORACLE SQL

-- substr : part of the string
-- instr  : position of specified char in string

-- select substr( 'oracle sql java' , 1,6) , substr( 'oracle sql java' , 8,3) from dual;
--select substr('bellery vijaynagar',1,7) dist_1 ,substr('bellery vijaynagar',8,17) dist_2 from dual

-- default starts from 1 and looks for 1st occrance
-- select instr( 'oracle-sql-java', '-'),
-- instr( 'oracle-sql-java', '-' ,1,1) , instr( 'oracle-sql-java', '-' ,1,2) from dual;
--select instr('bellery-vijay-nagar','-') dist_1 ,instr('bellery-vijay-nagar','-',1,1) dist_2,
   instr('bellery-vijay-nagar','-',1,2) dist_3 from dual
 

-- select instr('we are working in *infosys*','infosys',1,2) from dual;

select substr('we are working in *infosys*',instr('we are working in *infosys*','*',1)+1,
instr('we are working in *infosys*','*',19,2)-instr('we are working in *infosys*','*',1)-1) from dual


assignment-2
create table order ( desc varchar2(1000));
insert into order values('01-100-bangalore');
insert into order values('02-20-Mysore')

order 01 haivng 100 qty shipped into bangalroe
order 02 haivng 20 qty shipped into Mysore

--select * from orders
select orderdesc,' order ' || substr(orderdesc,1,2)  || ' having ' ||
substr(orderdesc,instr(orderdesc,'-',1,1)+1,instr(orderdesc,'-',1,2)-instr(orderdesc,'-',1,1)-1)  || ' qty shipped into ' ||
substr(orderdesc,instr(orderdesc,'-',1,2)+1,10) orderinfo
from orders

create table info ( empinfo varchar2(1000));
insert into info values('i wanted to join *Infosys* , working in *infosys* makes me proud');

--select * from info

select empinfo,substr(empinfo,instr(empinfo,'*',1,1)+1,instr(empinfo,'*',1,2)-instr(empinfo,'*',1,1)-1) no_1, 
                substr(empinfo,instr(empinfo,'*',1,3)+1,instr(empinfo,'*',1,4)-instr(empinfo,'*',1,3)-1) no_2

from info

123456789 
IND-BANG-KA                                                                              14448076 b lakshmi

create table test (name varchar2(10), place varchar2(20));
insert all
into test values('jeevan' , 'IND-BANG-KA')
into test values('Manoj' , 'IND-Utt pradesh-UP')
into test values('suraj' , 'IND-DHLHI-DL')
select * from dual;

select * from test;

---to find contry code
select substr(place,1,3) from test

--to find statecode
select substr(place,instr(place,'-',1,2)+1,2) from test

--to find city
select substr( place ,  instr(place , '-' ,1,1)+1 ,    instr(place , '-' ,1,2) - instr(place , '-' ,1,1)-1) city from test

--to find contry,state,city
select 
    substr(place,1,3) countrycode,
    substr(place,  instr(place , '-' ,1,2)+1 ,2) statecode ,
    substr( place ,  instr(place , '-' ,1,1)+1 ,    instr(place , '-' ,1,2) - instr(place , '-' ,1,1)-1) city 
from test


drop table test;

create table test (name varchar2(10), place varchar2(20), email varchar2(100));
insert all
into test values('jeevan' , 'IND-BANG-KA', 'jeven@gmail.com')
into test values('Manoj' , 'IND-Utt pradesh-UP' ,'manon@gmail.com')
into test values('suraj' , 'IND-DHLHI-DL','suraj@yahoo.com')
into test values('niraj' , 'IND-DHLHI-DL','nirjaj@yahoo.com')
into test values('Miraj' , 'IND-DHLHI-DL','miraj@hotmail.com')
select * from dual;


-- total number people using diff domain

select substr(email,instr(email,'@',1,1)+1,9) diff_domin from test 

select count(1), substr(email,instr(email,'@')+1) from test group by substr(email,instr(email,'@')+1)
------
--gmail,yahoo,hotmail

select count (email),substr(email,instr(email,'@',1,1)+1,instr(email,'.',1,1)-instr(email,'@'1,1)-1) mail_name from test 
group by substr(email,instr(email,'@',1,1)+1,instr(email,'.',1,1)-instr(email,'@',1,1)-1) order by mail_name

select count (email),substr(email,instr(email,'@')+1,instr(email,'.')-instr(email,'@')-1) mail_name from test 
group by substr(email,instr(email,'@')+1,instr(email,'.')-instr(email,'@')-1) order by mail_name

---print  783KINPRE 
select substr(empno,1,3) || substr(ename,1,3) || substr(job,1,3) from emp


select count(email), substr(email,instr(email,'@')+1,5) from test 
group by substr(email,instr(email,'@')+1,5)


2 gmail.com
2 yahoo.com
1 hotmail.com

//
create table country ( code varchar2(50));
desc country;
select * from country;
-- delete from country;

insert into country values('ASIA INDIA KAR');
insert into country values('AUS AUSTRALIA SYD');
insert into country values('SOUTHAFRICA CONGO CONGO');

continet  country 		state
ASIS       INDIA  	 	KAR
AUS        AUSTRALS 	SYS

select  code,
substr( code , 1 , instr(code , ' ' ,1,1)) contient,
substr( code , instr(code , ' ' ,1,2) ) statecode,
substr( code ,  instr(code , ' ' ,1,1)+1  , instr(code , ' ' ,1,2) -instr(code , ' ' ,1,1)) countrycode 
from country;

update country set code= 'ASIA INDIA KARANATAK' WHERE CODE='ASIA INDIA KAR'
update country set code= 'AUS AUSTRALIA SYDNEY' WHERE CODE='AUS AUSTRALIA SYD'

select substr(code,1,instr(code,' ',1,1)) continents,
substr(code,instr(code,' ',1,1)+1,instr(code,' ',1,2)-instr(code,' ',1,1)) country,
substr(code,instr(code,' ',1,2)+1) state from country

---trim functions
 default trims functions removes space
-- only leading and trailing matching pattens
-- trim can remove only space 


select
 length(' sql '),
 ltrim(' sql '),
 length( ltrim(' sql ')) ,
 rtrim(' sql '),
 trim(' sql '),
 length( trim(' sql '))
from dual;


select 
ltrim(' $% SQL '),
ltrim('% SQL%','%'),
rtrim('% SQL%','%'),
rtrim(ltrim('% SQL%','%'),'%')
from dual;

-- not only chars . removes also matching leading/ trailing patten,
select 
rtrim(  ltrim('$% SQ$%L$%','$%') , '$%')
from dual;

select rtrim(ltrim('$$plsql@@','$$'),'@@') from dual

select length(rtrim(ltrim('*@sql@@plsql@@','*@'),'@@')) from dual

 replace
-- not only chars . removes also matching leading/ trailing / IN BETWEEN patten,
select 
replace('% SQ%L%','%' , ''),
replace('$% SQ$%L$%','$%' , ''),
replace('$% SQ$%L%','$%' , '')
from dual;

select trim(replace (' oracle-sql-plsql ' ,  '-' ,' '))
from dual;

-- translate

1234 - ABCD
1  A
2  B
3  C
4  D

select translate('Python 4321', '1234', 'ABCD'),
translate('Python 4321', '1234', ' ')
from dual;

select 
replace (replace ( replace ('a$p^pl%e' ,'$' , '') , '^',''), '%' ,''),
translate ('a$p^pl%e' ,'~!@#$%^&*()_+' , ' ')
from dual;


select translate ( 'orange1235apple' ,'1234567890' ,' '),
 translate ( 'orange1235apple' ,'abcdefghijklmnopr' ,' ')
from dual;

-- find name starts with vowel
create table t( name  varchar2(100));
insert all 
 into t values ( 'Orange')
 into t values ( 'apple')
 into t values ( 'Bannnaa')
 into t values ( '123Milk')
 into t values ( 'cake456')
select * from dual; 

select * from  t where name like 'a%' or lower(name) like 'o%' ;

select * from t 
where substr(lower(name),1,1)  in ('a','e', 'i', 'o','u');

-----pesudu column
==column values never saved in db.
----rownum
	==labeling the records or stamping numbers 
			always starts with 1.
----rowid
	==adderess of a record in table (constant)
	
 select  * from scott.emp
  select emp.*,rownum,rowid from emp where rownum=1
select emp.*,rownum,rowid from emp where rownum<=10
select emp.*,rownum,rowid from emp where rownum<5
select emp.* from emp where rownum<=5 order by sal desc

select e.*,rownum from emp e order by sal desc
fetch next 4 rows only 

select e.*,rownum from emp e  order by sal asc
fetch next 5 rows only

select e.*,rownum from emp e order by hiredate desc 
fetch next 5 row only

----print *****,****,***,**,*

select substr('*****',1,rownum),
        substr('*****',rownum)
from dual connect by level<=length('*****');

--last row of emp id
select emp.*,rowid from emp where rowid=(select max(rowid) from emp )


   --select * from t
select * from t where mod(id,2)=0 --even num
/
select * from t where mod(id,2)=1  --odd num

EVEN AND ODD NUMBER FOR EMP TABLE
select empno,ename,rownum from emp where mod(empno,2)=0--/1 even/odd with empno
select emp.*,rownum,rowid,ascii(substr(rowid,-1)) evnum from emp where mod(ascii(substr(rowid,-1)),2)=0
select emp.*,rownum,rowid,ascii(substr(rowid,-1)) oddnum from emp where mod(ascii(substr(rowid,-1)),2)=1

3RD TOP SAL
select * from emp order by sal fetch next 3 rows only

--PERCENTAGE

select * from emp order by sal fetch first 5 percent rows only

select * from t order by id desc fetch FIRST 25 percent rows only
 
--OFFSET 

SELECT * FROM EMP ORDER BY SAL OFFSET 3 ROWS FETCH NEXT 3 ROWS ONLY

SELECT * FROM EMP ORDER BY SAL DESC OFFSET 5 ROWS FETCH NEXT 3 ROWS ONLY

------VIEW
--view is nothing but its a  logical table created on top of base table.
--view is just window for table same data represent in a multiple ways. 
--Views will not hold the date of its own,it only retrives the data from the table/view
 whenever the view is called by select statement.
create or replace view emp_10  
as select * from emp where deptno=10

select * from emp01
----IT IS NO DATA PHYSICALLY STORE  DATA ,ITS ACTUAL DATA COMES FROM EMP TABLE 
create view emp_clerk
as 
select * from emp where job='CLERK'
select * from emp_clerk
/
----IT IS PHYSICALLY STORED DATA IF DELETING EMP DATA
create materialized view m_emp_clerk
as 
select * from emp where job='CLERK'
select * from m_emp_clerk


--INLINE VIEWS
SELECT ENAME,SAL,DEPTNO,ROWNUM FROM EMP ORDER BY SAL

SELECT ENAME,SAL, DEPTNO,ROWNUM FROM (SELECT ENAME,SAL,DEPTNO,ROWNUM FROM EMP ORDER BY SAL )


SELECT ENAME,SAL, DEPTNO,ROWNUM FROM (SELECT ENAME,SAL,DEPTNO,ROWNUM FROM EMP ORDER BY DEPTNO DESC )
WHERE ROWNUM<=3

SELECT * FROM (SELECT ENAME,SAL,DEPTNO,ROWNUM R FROM EMP ORDER BY SAL) WHERE MOD(R,2)=0

SELECT * FROM (SELECT ENAME,SAL,DEPTNO,ROWNUM R FROM EMP ORDER BY SAL) WHERE MOD(R,2)=1


select e.*,rownum from emp e order by sal fetch next 5 rows only

select * from emp order by sal fetch first  75 percent rows only

select ename,job,sal,rownum from emp  order by sal desc offset 5 rows fetch next 3 rows only 

select e.*,rownum from (select ename,sal,deptno,job,rownum Ri from emp  where deptno in (10,20) order by sal) e 
where mod(ri,2)=0

select e.*,rownum from (select ename,sal,job,rownum ri from emp where rownum<=5 order by sal ) e where rownum<=3

--JOINS

create table branch(
bid  number,
bname varchar2(20)
);

insert all
into branch values(1,'Yelankha')
into branch values(2,'Mysore')
into branch values(3,'Hassan')
into branch values(4,'Mandya')
select * from dual;


create table student
(
 sid  number,
 sname varchar2(100),
 subject varchar2(20),
 bid number);

insert all 
into student values(1,'Pooja','SQL',1)
into student values(2,'Neha','Java',1)
into student values(3,'Guru','Python',2)
into student values(4,'dhana','PLSQL',3)
into student values(5,'Vinay','AZURE',null)
select * from dual;

insert into student values(6,'Bhoomika','AWS',null);

select sname,bname,sid,subject from student join branch on branch.bid=student.bid

select sname,bname,subject from branch  inner join student on student.bid = branch.bid

 ---column ambiguously defined
select sid,bid,sname,bname,subject from student inner join branch on student.bid=branch.bid

select sid,student.bid,sname,bname,subject from student inner join branch on student.bid=branch.bid

--table alias
select sid,s.bid,sname,bname,subject from student s inner join branch b on s.bid=b.bid
--

--left join
select sname,bname,subject,student.bid from student left join branch on branch.bid=student.bid

--right join
select bname,sname,subject,b.bid from student s right join branch b on b.bid=s.bid

--full join =inner+left+right
select bname,sname,subject from branch full join student on branch.bid=student.bid
--
--alternatives
--select sid,bname,subject,s.bid from student s join branch b on s.bid=b.bid 
--select sid,sname,subject,bname,s.bid from branch b  right join student s  on s.bid=b.bid
--select b.bid,bname,sid,sname from student s right join branch b on b.bid=s.bid 
--select sid,b.bid,sname,subject,bname from branch b full join student s on s.bid=b.bid


complex joins  

create table fee
(
sid number,
fee number,
paid_date date 
);

insert all 
 into fee values(1,3000,'18-SEP-2021')
 into fee values(1,2000,'19-SEP-2021')
 into fee values(2,6000,'18-SEP-2021')
 into fee values(3,3000,'19-SEP-2021')
 into fee values(3,5000,'20-SEP-2021')
 into fee values(3,3000,'20-SEP-2021')
SELECT * FROM DUAL


select sid,sname,bname,fee
from student s join branch b on s.bid=b.bid
join fee f on s.sid = f.sid; 

-- using right join
-- total number of students in each branch

select count(s.sid), bname
from  student s right join branch b on s.bid=b.bid
group by bname;

select count(sid) ,bname from student s right join branch b on b.bid=s.bid group by bname

-- how many times each student made payment
select sname,count(fee)
from student s left join fee f on s.sid=f.sid
group by sname;

-- what was the higest fee payment made by each student
select sname,max(fee) from student s  join fee f on  s.sid=f.sid group by sname 


-- combination of left and right combination
select bname, sname , fee
from branch b right join student s on b.bid = s.bid  left join fee f on s.sid = f.sid;


--- all branch , studentns and fee
select bname, sname , fee
from branch b full join student s on b.bid = s.bid  full join fee f on s.sid = f.sid;

-- assignments
-- student name who made hegihest payment ?
select sname,max(fee),s.sid from student s inner join fee f
on s.sid=f.sid group by sname,s.sid;

-- each student hegiest payment ?
select sname,max(fee) from student s  join fee f on  s.sid=f.sid group by sname 

-- find studnets who not paid any fee using joins
select sname,fee 
from student s left join fee f on s.sid=f.sid
where fee is null;
--alternative way
select sname,max(fee) 
from student s left join fee f on s.sid=f.sid
group by sname
having max(fee) is null;

-- find students who made minimum 2 payments usig n joins
select sname,count(fee)
from student s join fee f on s.sid=f.sid
group by sname
having count(fee)>1;


---deleting duplicate values
delete from student where rowid not in ( select min(rowid) from student group by sid);
 /
delete from emp where rowid not in (select min(rowid) from  emp group by EMPNO)
/
alter table emp add auto_id integer generated by default as identity
delete from emp where auto_id not in (select min(auto_id) from emp group by deptno,job)
/
---deleted all records
delete from emp where rownum not in (select min(rownum) from emp group by deptno,job)

------------**************** end of Joins

-- sub quries

-- sub quries
-- find student belogns to Mysore

=   in
<>  NOT IN

-- OUTER SQL
select * from student
where bid = (
--INNER SQL
select bid from branch where UPPER(bname) ='MYSORE'
);

-- find student belogns to Mysore / Yelankha
select * from student
where bid IN (    select bid from branch where UPPER(bname) in( 'YELANKHA' , 'MYSORE' ));
 
-- students not from Hassan
select * from student
where bid <> (select bid from branch where UPPER(bname) ='HASSAN' );

-- find student not belogns to Mysore / Yelankha
select * from student
where bid NOT IN ( select bid from branch where UPPER(bname) in( 'YELANKHA' , 'MYSORE' ));

-- find brach dont have any studnet
select * from branch where bid not in (select nvl( bid,-1) from student);

-- find branch it has minimum student
select * from branch where bid  in (select nvl( bid,-1) from student);

-- find all students they have same subject as Pooja
select * from student where subject in (
select subject from student where sname ='Pooja');

-- find student who paid heighet salary
select * from student where sid in  (select sid from fee where fee =(select max(fee) from fee));


-- student wise maximum fee 
select   sname, nvl( max(fee) ,0) maxfee
from branch b right  join student s on b.bid = s.bid left join fee f on s.sid = f.sid
group by sname;


-- assignment
-- total number of students in each bracnh
select count(sid),bname from student join branch on branch.bid=student.bid group by bname

Select count(b.bid) , bname from branch b join student s on s.bid=b.bid group by b.bid, bname

-- assignment
-- total fee paid by each student
select sum(fee),sname from student join fee on student.sid=fee.sid group by sname

select fee.sid,sum(fee),sname from student join fee on student.sid=fee.sid group by sname,fee.sid

PROBLEMS ON EMP Table

find emp workiin DALLAS
--join way
select e.* from emp e join dept d  on e.deptno=d.deptno 
where d.loc='DALLAS';

-- outer executes after inner sql
select * from emp where deptno= 
(
-- inner sql , always executs first Supplies values to outer SQL
select deptno from dept where loc='DALLAS'
);

-- find emp working in 2 locs
-- pls note use of in instead of =

select * from emp where deptno in
(
select deptno from dept where loc IN ('NEW YORK' ,'AUSTIN')
);

-- find dept does not have any emp
select * from dept
where deptno not in (select distinct deptno from emp);

-- find dept has atleast one emp
select * from dept
where deptno in (select deptno from emp);

-- find emp who has same Job OF JONES
select * from emp where job in ( select job from emp where ename ='JONES');

-- find all emp having manager same as JONES manager
select * from emp where mgr in ( select mgr from emp where ename ='JONES')

-- find all emp having JONES as manager
SELECT * from emp where mgr in  (select empno from emp WHERE ename ='JONES')


-- List the emps who are working as Managers
-- assume no job column
select * from emp  where empno in ( select distinct mgr from emp)

-- find emp working as CLERK AND taking max sal
select * from emp where sal =(SELECT max(sal) from emp WHERE JOB='CLERK')
AND JOB='CLERK';

--  find emp who working in same dept of MILLER
select * from emp where deptno = (select deptno from emp where ENAME ='MILLER')

-- find dept it has emp taking max salary
select * from dept where deptno in(select deptno from emp where sal = ( select max(sal) from emp))

-- FIND 2ND MAX SAL 
select max(sal) from emp where sal <> 
(select max(sal) from emp);

-- emp with 2nd max sal
select * from emp where sal  = ( select max(sal) from emp where sal < ( select max(sal) from emp)  )

select max(sal) from emp where sal <(select max(sal) from emp);

-- find 3rd min sal
select min( sal) from scott.emp where sal > (
select min(sal) from scott.emp
where sal > ( select min(sal) from emp));

select MAX(SAL) from emp where sal  < ( 
select max(sal) from emp where sal < ( 
select max(sal) from emp)  )


-- find emp takes max salary each dept
select * from emp
where sal in ( select max(sal) from emp group by deptno);
 
select * from emp where mgr in 
(
select mgr from emp where ename IN ( 'SMITH',  'WARD')
) and ename not IN ( 'SMITH',  'WARD');

 -- find emp whos salary > that the salary of all clerks 
 SELECT * FROM EMP where sal > (
select max(sal) from emp where job ='CLERK');

 
-- find emp taking max sal of CLERK
select * from emp
where (sal,JOB) = ( select max(sal) ,JOB from emp where job='CLERK' GROUP BY JOB);

select * from emp
where SAL = ( select max(sal)  from emp where job='CLERK' )
AND JOB='CLERK';

---------------------
-----co-related sub quries

-- sub sql  
  -- nested sql : inner first and outer later
  -- co-related sql : outer first and inner later
  
 
-- i want to find avg sal 
select avg(sal) from emp;
select avg(sal) , deptno from emp group by deptno;

-- Emp whose salary is > the sal of avg(sal)
select * from emp where sal > ( select avg(sal) from emp)

-- t table whose salary is >= the sal of avg(sal) of the same deptno
-- 20 avg is 4000
1  20    5000  **
2  20    3000
3  20    4000  **
-- 10 avg is 2000 
4  10    2000  **
-- 30 avg 3000
5  30     4000  **
6  30     2000 

create table t ( id int, deptno int ,sal int);

insert all 
 into t values(1,20,5000)
 into t values(2,20,3000)
 into t values(3,20,4000)
 into t values(4,10,2000)
 into t values(5,30,4000)
 into t values(6,30,2000)
 select * from dual; 
 
select * from t t1 where sal >=(  select avg(sal) from t t2 where t2.deptno = t1.deptno group by deptno)
select * from t t1 where sal >=(  select MAX(sal) from t t2 where t2.deptno = t1.deptno group by deptno)


-- Emp whose salary is >= the sal of avg(sal) of the same deptno
select * from emp emp2 where sal>=(select avg(sal) from emp emp1 where emp1.deptno=emp2.deptno group by deptno)

-- Emp whose salary is >= the sal of MAX(sal) of the same deptno
select * from emp emp2 where sal>=(select MAX(sal) from emp emp1 where emp1.deptno=emp2.deptno group by deptno)

--emp whose sal is >= the sal AVG(sal) of the same job 
select * from emp emp2 where sal>=(select AVG(sal) from emp emp1 where emp1.job=emp2.job group by job)


--emp whose sal is >= the sal max(sal) of the same job 

select * from emp emp2 where sal>=(select max(sal) from emp emp1 where emp1.job=emp2.job group by job)

-----PARTITION


--Range Partitioning

CREATE TABLE  PARTITIONED_EMPLOYEES(  
	"EMPLOYEE_ID"     NUMBER primary key,   
	"FIRST_NAME"      VARCHAR2(20),   
	"LAST_NAME"       VARCHAR2(25),   
	"EMAIL"           VARCHAR2(25) unique,   
	"PHONE_NUMBER"    VARCHAR2(20),   
	"HIRE_DATE"       DATE ,   
	"JOB_ID"          VARCHAR2(10),   
	"SALARY"          NUMBER(8,2),   
	"COMMISSION_PCT"  NUMBER(2,2),   
	"MANAGER_ID"      NUMBER(6,0),   
	"DEPARTMENT_ID"   NUMBER(4,0)  
    )  
    partition by range("DEPARTMENT_ID")   
    (  
    partition p1 values less than (20) STORAGE  ( INITIAL 10K  NEXT  10K),  
    partition p2 values less than (60) STORAGE  ( INITIAL 10K  NEXT  10K),  
    partition p3 values less than (9999) STORAGE  ( INITIAL 10K  NEXT  10K) 
    )

---List-Partition Tables

   CREATE TABLE sales_by_region ( 
             item_id INTEGER,  
             item_quantity INTEGER,  
             store_name VARCHAR(30),  
             state_code VARCHAR(2), 
             sale_date DATE) 
     PARTITION BY LIST (state_code)  
     (PARTITION region_east 
        VALUES ('MA','NY','CT','NH','ME','MD','VA','PA','NJ'), 
     PARTITION region_west 
        VALUES ('CA','AZ','NM','OR','WA','UT','NV','CO'), 
     PARTITION region_south 
        VALUES ('TX','KY','TN','LA','MS','AR','AL','GA'), 
     PARTITION region_central  
        VALUES ('OH','ND','SD','MO','IL','MI','IA'))
   
  SELECT TABLE_NAME,PARTITION_NAME, PARTITION_POSITION, HIGH_VALUE FROM USER_TAB_PARTITIONS WHERE TABLE_NAME ='SALES_BY_REGION'

   ALTER TABLE sales_by_region  ADD PARTITION region_nonmainland VALUES ('HI', 'PR')
   INSERT INTO sales_by_region VALUES (1001,100,'My Store MA','MA','25-AUG-2014')
   INSERT INTO sales_by_region VALUES (1002,200,'My Store CO','CO','26-AUG-2014')

SELECT * FROM sales_by_region  
 /  
drop table emp 
create table emp 
( 
empno number,
ename varchar2(50),
sal number,
deptno number,
constraint emp_pk primary key (empno)
)
partition by list (deptno) automatic
(
partition d_10 values (10),
partition d_20 values (20),
partition d_30 values (30)
--partition d_other values (default)
)
/
insert into emp values (7839,'jai',5000,10)
insert into emp values (7522,'vij',5400,20)
insert into emp values (7552,'raj',3000,20)
insert into emp values (7514,'rock',2500,30)
insert into emp values (8585,'lak',6000,30)
insert into emp values (4665,'scott',3500,40)
select * from emp
/
exec dbms_stats.gather_table_stats(user,'emp',cascade => true)
select table_name,partition_name,high_value,num_rows from user_tab_partitions where table_name='emp' order by 1,2
/
/
--COMPOSITE PARTITION/SUBPARTITION (LIST :: RANGE)

CREATE TABLE ticker (SYMBOL VARCHAR2(10), tstamp DATE, price NUMBER)
PARTITION BY LIST (SYMBOL)
                        --SUBPARTITION BY RANGE(PRICE)
                        --SUBPARTITION TEMPLATE
                        --(SUBPARTITION SP1 VALUES LESS THAN(10),
                        --SUBPARTITION SP2 VALUES LESS THAN(20),
                        --SUBPARTITION SP3 VALUES LESS THAN(30))

(PARTITION P1 VALUES ('ACME'),
PARTITION P2 VALUES ('GLOBEX'),
PARTITION P3 VALUES ('OSCORP'));

DROP TABLE TICKER

BEGIN
INSERT INTO ticker VALUES('ACME', '01-Apr-11', 12);
INSERT INTO ticker VALUES('GLOBEX', '17-Apr-11', 8);
INSERT INTO ticker VALUES('GLOBEX', '01-Apr-11', 11);
INSERT INTO ticker VALUES('OSCORP', '20-Apr-11', 9);
INSERT INTO ticker VALUES('ACME', '02-Apr-11', 17);
INSERT INTO ticker VALUES('OSCORP', '19-Apr-11', 11);
INSERT INTO ticker VALUES('ACME', '03-Apr-11', 19);
INSERT INTO ticker VALUES('GLOBEX', '03-Apr-11', 13);
INSERT INTO ticker VALUES('OSCORP', '18-Apr-11', 12);
INSERT INTO ticker VALUES('GLOBEX', '02-Apr-11', 12);
INSERT INTO ticker VALUES('ACME', '04-Apr-11', 21);
INSERT INTO ticker VALUES('GLOBEX', '04-Apr-11', 12);
INSERT INTO ticker VALUES('OSCORP', '17-Apr-11', 14);
INSERT INTO ticker VALUES('OSCORP', '15-Apr-11', 12);
INSERT INTO ticker VALUES('OSCORP', '14-Apr-11', 15);
INSERT INTO ticker VALUES('OSCORP', '16-Apr-11', 16);
INSERT INTO ticker VALUES('ACME', '05-Apr-11', 25);
INSERT INTO ticker VALUES('GLOBEX', '05-Apr-11', 11);
INSERT INTO ticker VALUES('ACME', '06-Apr-11', 12);
INSERT INTO ticker VALUES('GLOBEX', '06-Apr-11', 10);
INSERT INTO ticker VALUES('ACME', '07-Apr-11', 15);
INSERT INTO ticker VALUES('GLOBEX', '07-Apr-11', 9);
INSERT INTO ticker VALUES('GLOBEX', '08-Apr-11', 8);
INSERT INTO ticker VALUES('ACME', '08-Apr-11', 20);
INSERT INTO ticker VALUES('OSCORP', '13-Apr-11', 11);
INSERT INTO ticker VALUES('ACME', '13-Apr-11', 25);
INSERT INTO ticker VALUES('ACME', '10-Apr-11', 25);
INSERT INTO ticker VALUES('ACME', '11-Apr-11', 19);
INSERT INTO ticker VALUES('ACME', '09-Apr-11', 24);
INSERT INTO ticker VALUES('GLOBEX', '09-Apr-11', 9);
INSERT INTO ticker VALUES('OSCORP', '12-Apr-11', 12);
INSERT INTO ticker VALUES('GLOBEX', '10-Apr-11', 9);
INSERT INTO ticker VALUES('OSCORP', '11-Apr-11', 15);
INSERT INTO ticker VALUES('GLOBEX', '11-Apr-11', 9);
INSERT INTO ticker VALUES('OSCORP', '10-Apr-11', 15);
INSERT INTO ticker VALUES('ACME', '12-Apr-11', 15);
INSERT INTO ticker VALUES('GLOBEX', '12-Apr-11', 9);
INSERT INTO ticker VALUES('OSCORP', '09-Apr-11', 16);
INSERT INTO ticker VALUES('GLOBEX', '13-Apr-11', 10);
INSERT INTO ticker VALUES('OSCORP', '08-Apr-11', 20);
INSERT INTO ticker VALUES('ACME', '14-Apr-11', 25);
INSERT INTO ticker VALUES('GLOBEX', '14-Apr-11', 11);
INSERT INTO ticker VALUES('OSCORP', '07-Apr-11', 17);
INSERT INTO ticker VALUES('OSCORP', '06-Apr-11', 20);
INSERT INTO ticker VALUES('ACME', '15-Apr-11', 14);
INSERT INTO ticker VALUES('GLOBEX', '15-Apr-11', 12);
INSERT INTO ticker VALUES('ACME', '17-Apr-11', 14);
INSERT INTO ticker VALUES('ACME', '16-Apr-11', 12);
INSERT INTO ticker VALUES('GLOBEX', '16-Apr-11', 11);
INSERT INTO ticker VALUES('OSCORP', '05-Apr-11', 17);
INSERT INTO ticker VALUES('ACME', '18-Apr-11', 24);
INSERT INTO ticker VALUES('GLOBEX', '18-Apr-11', 7);
INSERT INTO ticker VALUES('OSCORP', '04-Apr-11', 18);
INSERT INTO ticker VALUES('OSCORP', '03-Apr-11', 19);
INSERT INTO ticker VALUES('ACME', '19-Apr-11', 23);
INSERT INTO ticker VALUES('GLOBEX', '19-Apr-11', 5);
INSERT INTO ticker VALUES('OSCORP', '02-Apr-11', 22);
INSERT INTO ticker VALUES('ACME', '20-Apr-11', 22);
INSERT INTO ticker VALUES('GLOBEX', '20-Apr-11', 3);
INSERT INTO ticker VALUES('OSCORP', '01-Apr-11', 22);

commit;

END;
 SELECT * FROM TICKER PARTITION(P1)-- WHERE PRICE>25
select * from ticker order by symbol,tstamp

select symbol,min(tstamp),max(tstamp),count(*) from ticker group by symbol

select * from ticker where symbol='ACME' ORDER BY TSTAMP

SELECT TABLE_NAME,PARTITION_NAME,PARTITION_POSITION, HIGH_VALUE FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='TICKER'
   
 ------How to know the number of records affected by query
create table emp as  select * from emp
begin
insert into emp
select * from emp ;
dbms_output.put_line('no rows affected=' || sql%rowcount);
end;
/
begin
update emp set sal=sal*0.1 ;
dbms_output.put_line('no rows affected=' || sql%rowcount);
end;
/
begin
delete  from  emp where deptno=10  ;
dbms_output.put_line('no rows affected=' || sql%rowcount);
end;
/
create sequence emp_empno
begin
insert into emp(empno,ename)
values (emp_empno.nextval,'vijay');
dbms_output.put_line('no rows affected=' || sql%rowcount);
end;
/

------------------
create table student (sid number,sname varchar2(50));
/
insert all
into student values(1,'NEERAJ')
into student values(2,'SURAJ')
into student values(3,'JAIRAJ')
into student values(4,'MEERAJ')
into student values(5,'GURU')
into student values(6,'POOJA')
SELECT * FROM DUAL;
/
alter table student add place varchar2(50)
/
update student set place='bang' where sid=1
update student set place='mumbai' where sid=2
update student set place='hyd' where sid=3
update student set place='chennai' where sid=4
/
create table SUBJECT  (sBid number,SUBJECT varchar2(50));
/
insert all
into SUBJECT values(1,'MATHS')
into SUBJECT values(2,'SCIENCE')
into SUBJECT values(3,'SOCIAL')
SELECT * FROM DUAL;
/
create table MARKS  (sid number,SBID NUMBER ,SCORE varchar2(50));
/
insert all
into MARKS values(1,1,50)
into MARKS values(1,2,65)
into MARKS values(1,3,45)
into MARKS values(2,1,30)
into MARKS values(2,2,65)
into MARKS values(2,3,32)
into MARKS values(3,1,50)
into MARKS values(3,2,32)
into MARKS values(3,3,55)
into MARKS values(5,1,23)
into MARKS values(5,2,34)
into MARKS values(5,3,30)
SELECT * FROM DUAL;
/
SELECT * FROM STUDENT
/
SELECT * FROM SUBJECT 
/
SELECT * FROM MARKS
/
SELECT S.SID,SNAME,SCORE,SB.SBID,SUBJECT 
FROM STUDENT S FULL JOIN MARKS M ON S.SID=M.SID 
FULL JOIN SUBJECT SB ON SB.SBID=M.SBID
/
-- 1) total number of student
select count(sname) from student
-- 2) number of students from each place
select count(1),place  from student group by place
--3) total marks by each student with name
select s.sid,sname,sum(score) 
from marks m join student s on s.sid=m.sid 
group by s.sid,sname order by sid
--4)max score by each subject 
select max(score),subject 
from marks m join subject sb on sb.sbid=m.sbid
group by subject
--5)avg marks by each subject 
select avg(score),subject 
from marks m join subject sb on sb.sbid=m.sbid
group by subject
--6)who are students not attained exam  
select s.sid,sname,score 
from marks m right join student s on s.sid=m.sid 
where score is null
--7)count student not attained exam  
select count(1) 
from marks m right join student s on s.sid=m.sid 
where score is null
--8) score > 50 in any of the subject
select sname,score,subject 
from student s join marks m on s.sid=m.sid join subject sb on sb.sbid=m.sbid 
where score > 50
--9)count subjects 
select count(subject) from subject
--10)total no students from  bangalore
select count(sid) from student where place='bang'


--MAX MARKS BY EACH SUBJECT
SELECT MAX(SCORE),SUBJECT FROM MARKS M JOIN SUBJECT S ON S.SBID=M.SBID GROUP BY SUBJECT
/
--SUM MARKS IN EACH STUDENT 
SELECT SUM(SCORE),SNAME FROM MARKS M JOIN SUBJECT S ON S.SBID=M.SBID JOIN STUDENT ST ON ST.SID=M.SID GROUP BY SNAME 
/
--
SELECT TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE,-1)),'DAY/MON/YYYY') LAST_MONTH_DAY FROM DUAL
/
SELECT EMP.*,ASCII(SUBSTR(ROWID,-1)) FROM EMP  WHERE MOD(EMPNO,2)=1
/
DELETE FROM EMP WHERE ROWID NOT IN (SELECT MIN(ROWID) FROM EMP GROUP BY EMPNO)



--union returns distinct result set,remove duplicates and shorted by defualt
select deptno from emp
union 
select deptno from dept;

--unionall  returns all  rows from both tables and won't remove duplicate and not  shorted by defualt
select deptno from emp
union all
select deptno from dept;

--intersect returns all common rows  and removes duplicate
select deptno from emp
intersect
select deptno from dept;

--minus returns all record from one table excluding records from other table
select deptno from dept
minus
select deptno from emp;

























































