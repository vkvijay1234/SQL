1) what are constraints ?

2) name Different types of constraints ?

3) difference with between primary key and unique ?

4) what are the different SQL commands we have ?

5) Difference between delete and truncate and drop ?

6) what is NULL ?

7) difference between nvl, nlv2 and collease ?

collease(col1, col2, col3, col4, col5)
col1  col2 		clo3	 	clo4 	col5
null   1    	null		
null   null     null		2
null   null     null		null  null
6	   null     null		null  null

8) difference char and varchar2 ?

9) what is FK and posible values ?

10) what is dual ?

11) which is faster delete or truncate?

12) diff b/w in and Between AND  

13) what column alias , can we use alias in where and group ?
    order by clause

14) diff b/w where and having cluase
     can use having clause without using group by
	 
	 select count(empno) from empno
	 having count(empno) > 5;

15) what are aggreagate functions  ? diff aggreagate functions ?

16) how do we get unqiue records from table  ?

  select distinct deptno from emp;
  select distinct deptno,job from emp;

17) why do we use having ?

18) what is the order of sql exection

	select count(1) deptcount , deptno
	from empno
	where deptno=30
	group by deptno
	having count(1) > 4
	order by deptcount;
	
19) what is unqiue and distinct 

20) difference case and decode 
	decode(gender , 'M', 'male', 'F', 'Female', 'un-known')
case
	deptno = 10 and sal > 2000 then  ?
	select 
	case 
	when  gender ='m' then 'MALE'
	when  gender ='f' then 'FEMALE'
	else 'un-known'
    end EMPGENDER
	from emp;		 
		
21) how string columns will be sorted
    what about date
	
	sysdate -1
	sysdate
	sysdate +1
	
22) single row and multiple row functions

23) what is limition of group by 
    select avg(sal) ,deptno  
	from emp
	group by deptno

24) name few string fucntions

25) diff b/w replace and translate
	A  1
	B  2

26) what is the default date format

27) how to get time part of date
	to_Char(sysdate, 'hh:mi:ss')

28) can you name few number funcntions

29) Psuedo columns

30) what is the output of 
     select * from emp where rownum=10;
	 
	 select * from emp where rownum<=10;
	
31) what is the output of 
     select * from emp where null=null;
 
32) what is the output of 
     select * from emp where null is null;

33) what is rowid

34) name few date functions  months_between , add_months , next_day , last_day

35) what is like operator  _

36) find name start with A in either case
	select * from emp where UPPER(ename) like 'R%'

37) what is the substr and instr
     SUBSTR(STRING / COLUMN ,START INDEX, NUMBER OF CHAR)
	 INSTR(STRING/COLUMN, '*', START ,OCCURANCE)
	 	 
38) what are joins

39) explain diff types joins

40) what are sub-quries

    emp   dept
	10      5

-----------*********************

41) diff types of sub-quries ( nested and co-related ) 

composite primary key
TCL and DCL 
what are the posible option in Foreign key
*Normalization
*What are ACID rules
*what are attributes
*what is candidate key ?



AB24EF56  
-----------
ABEF   2456

select translate( 'AB24EF56', '1234567890',' '),
translate( 'AB24EF56', 'ABCDEFGHIJKLMNOPQU',' ')from dual;

*find last day of next month
select  last_day( add_months ( sysdate ,1) )from dual

* how to delete duplicate data