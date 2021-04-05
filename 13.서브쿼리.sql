--서브쿼리(WHERE절)
--서브쿼리 사용법
--1. ()에 작성한다.
--2. 단일행 서브쿼리 절의결과는 반드시 1행이어야 한다.
--3. 조건절보다 오른쪽에 위치한다.
--4. (서브쿼리절을 먼저 해석한다.)

--낸시의 급여보다 월급을 많이 받는 사람

select salary from employees where first_name = 'Nancy';

select *
from employees
where salary > (select salary from employees where first_name = 'Nancy');

--직원아이디가 103번 직원과 같은 job을 가진 사람
select job_id from employees where employee_id = 103;

select *
from employees
where job_id = (select job_id from employees where employee_id = 103);

--아래 서브쿼리절은 행이 여러개라서 사용할 수 없다.
--job_id가 it_prog인 직원
select * from employees where job_id = 'IT_PROG';

select *
from employees
where job_id = (select job_id from employees where job_id = 'IT_PROG');

--다중행 서브쿼리(in, any, all)
--in - 다중행 서브쿼리에서 여러값중에 하나라도 일치하면 반환
select salary from employees where first_name = 'David';

select *
from employees
where salary in (select salary from employees where first_name = 'David');

select *
from employees
where job_id in (select job_id from employees where job_id = 'IT_PROG');

--any - 최소값보다 크거나 최대값보다 작다.
select salary from employees where first_name = 'David';

select *
from employees
where salary > any (select salary from employees where first_name = 'David');

select *
from employees
where salary < any (select salary from employees where first_name = 'David');

--all - 최대값보다 크거나 최소값보다 작다.
select salary from employees where first_name = 'David';

select *
from employees
where salary > all (select salary from employees where first_name = 'David'); --9500보다 큰

select *
from employees
where salary < all (select salary from employees where first_name = 'David'); -- 4800보다 작은


----스칼라 쿼리(select 리스트에 select절이 들어가는 구문, LEFT OUTER JOIN과 동일한 결과-----

--스칼라 쿼리 사용 where절에 조인의 조건을 기술한다.
select e.* ,
       (select department_name 
        from departments d 
        where d.department_id = e.department_id) as department_name
from employees e
order by first_name desc;

select e.*,
       d.department_name
from employees e
left outer join departments d on e.department_id = d.department_id
order by first_name desc;


--left join (부서장의 이름)
select * from employees;

select d.*,
       e.first_name
from departments d
left outer join employees e on d.manager_id = e.employee_id
order by d.department_id;

--스칼라 쿼리 (부서장의 이름)
select d.*,
       (select first_name
       from employees e where d.manager_id = e.employee_id) as first_name
from departments d
order by d.department_id;

--스칼라 쿼리(departments 테이블, locations 테이블의 city, address 정보)

select d.*,
       (select city
       from locations l where d.location_id = l.location_id) as city,
       (select street_address
       from locations l where d.location_id = l.location_id) as address
from departments d;

--스칼라 쿼리 (각 부서별 사원수)

select department_id, count(employee_id) from employees group by department_id;

select d.*,
       nvl((select count(*) 
       from employees e where d.department_id = e.department_id group by department_id),0) as 사원수
from departments d;


--------인라인 뷰 (FROM절에 select문이 들어가는 형태, FROM절 이하 문을 가상의 테이블로 생각)--------

select *
from employees;

select *
from (select * from employees);

--rownum이 섞이는 문제
select rownum, first_name, job_id, salary
from employees
order by salary;

--인라인 뷰로 해결
select rownum, 
       first_name, 
       job_id, 
       salary
from( select first_name, job_id, salary
      from employees
      order by salary desc);

--인라인 뷰로 나온 결과에 대해서 10행 까지만 출력
select rownum,
       a.*
from (select first_name, job_id, salary
      from employees
      order by salary desc) a
where rownum <= 10;

--인라인 뷰로 나온 결과에 대해서 11~20행까지 (rownum은 첫 번째 행(1)부터 조회할 수 있다)

select first_name, job_id, salary
from employees
order by salary desc;

select rownum,
       a.*
from(select first_name, job_id, salary
     from employees
     order by salary desc) a
where rownum between 11 and 20;

--다중 인라인 뷰

select rownum as rn,
       first_name,
       job_id,
       salary
from (select *
      from employees
      order by salary desc);

select *
from(select rownum as rn,
       first_name,
       job_id,
       salary
     from (select *
           from employees
           order by salary desc))
where rn between 11 and 20;

select *
from(select rownum as rn,
            a.*
     from (select first_name, job_id, salary
           from employees
           order by salary desc) a)
where rn between 11 and 20;

--이건 안된다. (rownum의 숫자가 뒤죽박죽)
select *
from(select rownum as rn,
            first_name,
            salary
     from employees
     order by salary desc);
     

--인라인 뷰 (가상 테이블 기준 3월 1일 데이터만 추출)
select '홍길동' as name, '20200211' as test from dual union all
select '이순신', '20200301' from dual union all
select '강감찬', '20200314' from dual union all
select '김유신', '20200403' from dual union all
select '홍길자', '20200301' from dual;

select *
from (select name,
       to_char(to_date(test, 'YYYYMMDD'), 'MM-DD') as mm
      from (select '홍길동' as name, '20200211' as test from dual union all
            select '이순신', '20200301' from dual union all
            select '강감찬', '20200314' from dual union all
            select '김유신', '20200403' from dual union all
            select '홍길자', '20200301' from dual))
where mm = '03-01';
            
select name,
       to_char(to_date(test, 'YYYYMMDD'), 'MM-DD') as mm
from (select '홍길동' as name, '20200211' as test from dual union all
select '이순신', '20200301' from dual union all
select '강감찬', '20200314' from dual union all
select '김유신', '20200403' from dual union all
select '홍길자', '20200301' from dual);

--응용 (JOIN테이블의 위치로 인라인 뷰 삽입 가능 or 스칼라 쿼리와 혼합해서 사용 가능)
--salary가 10000이상인 직원의 이름, 부서명, 부서의 주소, job_title을 출력 salary 기준으로 내림차순

select *
from employees;

select *
from departments;

select *
from locations;

select *
from jobs;

--1st
select e.first_name,
       d.department_name,
       l.street_address,
       j.job_id,
       salary
from employees e
left outer join departments d on e.department_id = d.department_id
left outer join locations l on d.location_id = l.location_id
left outer join jobs j on e.job_id = j.job_id
where salary >= 10000
order by salary desc;

--2nd
--from 절에 넣을 테이블
select *
from employees e
left outer join departments d on e.department_id = d.department_id
where salary >= 10000;

select a.first_name,
       a.department_name,
       (select street_address from locations l where l.location_id = a.location_id) as street_address,
       (select job_title from jobs j where j.job_id = a.job_id) as job_title,
       a.salary
from (select *
      from employees e
      left outer join departments d on e.department_id = d.department_id
      where salary >= 10000
      ) a;
      
--정리.
--where절에 들어가는 서브쿼리문 단일행 vs 다중행 (in, any, all)
--스칼라 쿼리 - select리스트에 들어가는 서브쿼리(단일행의 결과로 쓰여야함, left outer join과 같은 역할)
--인라인 뷰 - from절에 들어가는 서브쿼리(안쪽에서 필요한 쿼리문을 작성, 가상 테이블의 형태)