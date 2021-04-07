--문제 1.
---EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 데이터를 출력 하세요 ( AVG(컬럼) 사용)

select *
from employees
where salary > (select avg(salary) from employees);

---EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 수를 출력하세요

select count(salary)
from employees
where salary > (select avg(salary) from employees);

---EMPLOYEES 테이블에서 job_id가 IT_PFOG인 사원들의 평균급여보다 높은 사원들을 데이터를 출력하세요.

select *
from employees
where salary > (select avg(salary) from employees where job_id = 'IT_PROG');

--문제 2.
---DEPARTMENTS테이블에서 manager_id가 100인 사람의 department_id와
--EMPLOYEES테이블에서 department_id가 일치하는 모든 사원의 정보를 검색하세요.

select *
from departments
where manager_id = 100;

select *
from employees
where department_id = (select department_id from departments where manager_id = 100);

--문제 3.
---EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 출력하세요

select *
from employees
where manager_id > (select manager_id from employees where first_name = 'Pat');

---EMPLOYEES테이블에서 “James”(2명)들의 manager_id와 같은 모든 사원의 데이터를 출력하세요.

select *
from employees
where manager_id in (select manager_id from employees where first_name = 'James');

--문제 4.
---EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 행 번호, 이름을 출력하세요

select rn, first_name
from (select rownum as rn, first_name
      from (select first_name
            from employees
            order by first_name desc))
where rn between 41 and 50;

--문제 5.
---EMPLOYEES테이블에서 hire_date기준으로 오름차순 정렬하고, 31~40번째 데이터의 행 번호, 사원id, 이름, 번호, 
--입사일을 출력하세요.

select rn,
       employee_id,
       first_name,
       phone_number,
       hire_date
from(select rownum as rn, 
            employee_id,
            first_name,
            phone_number,
            hire_date
     from (select employee_id,
                  first_name,
                  phone_number,
                  hire_date
           from employees
           order by hire_date asc))
where rn between 31 and 40;

--문제 6.
--employees테이블 departments테이블을 left 조인하세요
--조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
--조건) 직원아이디 기준 오름차순 정렬

select e.employee_id as 직원아이디, 
       concat(e.first_name || ' ' , e.last_name) as 이름,
       d.department_id as 부서아이디,
       d.department_name as 부서명
from employees e
left outer join departments d on e.department_id = d.department_id
order by employee_id asc;

--문제 7.
--문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요

select e.employee_id as 직원아이디,
       concat(e.first_name || ' ' , e.last_name) as 이름,
       e.department_id as 부서아이디,
       (select department_name from departments d where d.department_id = e.department_id) as 부서명
from employees e
order by employee_id asc;

--문제 8.
--departments테이블 locations테이블을 left 조인하세요
--조건) 부서아이디, 부서이름, 매니저아이디, 로케이션아이디, 스트릿_어드레스, 포스트 코드, 시티 만 출력합니다
--조건) 부서아이디 기준 오름차순 정렬
select *
from locations;

select d.department_id as 부서아이디,
       d.department_name as 부서이름,
       d.manager_id as 매니저아이디,
       d.location_id as 로케이션아이디,
       l.street_address as st,
       l.postal_code as pc,
       l.city as 시티
from departments d
left outer join locations l on d.location_id = l.location_id
order by department_id asc;


--문제 9.
--문제 8의 결과를 (스칼라 쿼리)로 동일하게 조회하세요

select d.department_Id as 부서아이디, 
       d.department_name as 부서이름,
       d.manager_id as 매니저아이디,
       d.location_id as 로케이션아이디,
       (select street_address from locations l where l.location_id = d.location_id) as st,
       (select postal_code from locations l where l.location_id = d.location_id) as pc,
       (select city from locations l where l.location_id = d.location_id) as 시티
from departments d
order by department_id asc;

--문제 10.
--locations테이블 countries 테이블을 left 조인하세요
--조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다
--조건) country_name기준 오름차순 정렬

select l.location_id as location_id,
       l.street_address as st,
       l.city as city,
       l.country_id as country_id,
       c.country_name as country_name
from locations l
left outer join countries c on c.country_id = l.country_id
order by country_name asc;
       
--문제 11.
--문제 10의 결과를 (스칼라 쿼리)로 동일하게 조회하세요

select l.location_id as location_id,
       l.street_address as st,
       l.city as city,
       l.country_id as country_id,
       (select country_name from countries c where c.country_id = l.country_id) as country_name
from locations l
order by country_name asc;

--문제 12.
--employees테이블, departments테이블을 left조인 hire_date를 오름차순 기준으로 1-10번째 데이터만 출력합니다
--조건) rownum을 적용하여 번호, 직원아이디, 이름, 전화번호, 입사일, 부서아이디, 부서이름 을 출력합니다.
--조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 틀어지면 안됩니다.

select *
from (select rownum as rn, a.*
      from (select e.employee_id as 직원아이디,
                   concat(first_name || ' ', last_name) as 이름,
                   e.phone_number as 전화번호,
                   e.hire_date as 입사일자,
                   e.department_id as 부서아이디,
                   d.department_name as 부서이름
            from employees e
            left outer join departments d on e.department_id = d.department_id
            order by hire_date) a)
where rn between 1 and 10;


--문제 13.
--EMPLOYEES 과 DEPARTMENTS 테이블에서 JOB_ID가 SA_MAN 사원의 정보의 LAST_NAME, JOB_ID,
--DEPARTMENT_ID,DEPARTMENT_NAME을 출력하세요

select e.last_name,
       e.job_id,
       e.department_id,
       d.department_name
from employees e
left outer join departments d on e.department_id = d.department_id
where job_id = 'SA_MAN';

--테이블 위치에 인라인 뷰
select e.last_name,
       e.job_id,
       e.department_id,
       d.department_name
from (select *
      from employees
      where job_id = 'SA_MAN') e
left outer join departments d on e.department_id = d.department_id;


--문제 14
--DEPARTMENT테이블에서 각 부서의 ID, NAME, MANAGER_ID와 부서에 속한 인원수를 출력하세요.
--인원수 기준 내림차순 정렬하세요.
--사람이 없는 부서는 출력하지 않습니다

select d.department_id,
       department_name,
       d.manager_id,
       count(e.employee_id) as count
from (select *
      from departments
      where manager_id is not null) d
left outer join employees e on e.department_id = d.department_id
group by d.department_id,
         department_name,
         d.manager_id
order by count desc;


select department_id,
       department_name,
       manager_id,
       count
from(select department_id,
            department_name,
            manager_id,
            (select count(*) from employees e where e.department_id = d.department_id group by department_id) as count
     from departments d)
where count is not null
order by count desc;


--직원 테이블의 group by절 department_id와 사원수만 추출
select d.department_id,
       department_name,
       d.manager_id,
       total
from departments d
left outer join (select department_id,
                        count(*) as total
                 from employees
                 group by department_id) e
on d.department_id = e.department_id
where total is not null
order by total desc;


--문제 15
--부서에 대한 정보 전부와, 주소, 우편번호, 부서별 평균 연봉을 구해서 출력하세요
--부서별 평균이 없으면 0으로 출력하세요

-- department, location, employees;

select d.*,
       l.street_address,
       l.postal_code,
       nvl(salary,0) salary
from departments d
left outer join (select department_id, avg(salary) as salary
                 from employees
                 group by department_id) e
on d.department_id = e.department_id
left outer join locations l on l.location_id = d.location_id;



--문제 16
--문제 15결과에 대해 DEPARTMENT_ID기준으로 내림차순 정렬해서 ROWNUM을 붙여 1-10데이터 까지만
--출력하세요


select *
from (select rownum rn , a.*
      from (select d.*,
                   l.street_address,
                   l.postal_code,
                   nvl(trunc(salary),0)
            from departments d
            left outer join (select department_id, avg(salary) as salary
                             from employees
                             group by department_id) e
            on d.department_id = e.department_id
            left outer join locations l on l.location_id = d.location_id
            order by d.department_id ) a)
where rn <= 10;