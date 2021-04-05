--��������(WHERE��)
--�������� ����
--1. ()�� �ۼ��Ѵ�.
--2. ������ �������� ���ǰ���� �ݵ�� 1���̾�� �Ѵ�.
--3. ���������� �����ʿ� ��ġ�Ѵ�.
--4. (������������ ���� �ؼ��Ѵ�.)

--������ �޿����� ������ ���� �޴� ���

select salary from employees where first_name = 'Nancy';

select *
from employees
where salary > (select salary from employees where first_name = 'Nancy');

--�������̵� 103�� ������ ���� job�� ���� ���
select job_id from employees where employee_id = 103;

select *
from employees
where job_id = (select job_id from employees where employee_id = 103);

--�Ʒ� ������������ ���� �������� ����� �� ����.
--job_id�� it_prog�� ����
select * from employees where job_id = 'IT_PROG';

select *
from employees
where job_id = (select job_id from employees where job_id = 'IT_PROG');

--������ ��������(in, any, all)
--in - ������ ������������ �������߿� �ϳ��� ��ġ�ϸ� ��ȯ
select salary from employees where first_name = 'David';

select *
from employees
where salary in (select salary from employees where first_name = 'David');

select *
from employees
where job_id in (select job_id from employees where job_id = 'IT_PROG');

--any - �ּҰ����� ũ�ų� �ִ밪���� �۴�.
select salary from employees where first_name = 'David';

select *
from employees
where salary > any (select salary from employees where first_name = 'David');

select *
from employees
where salary < any (select salary from employees where first_name = 'David');

--all - �ִ밪���� ũ�ų� �ּҰ����� �۴�.
select salary from employees where first_name = 'David';

select *
from employees
where salary > all (select salary from employees where first_name = 'David'); --9500���� ū

select *
from employees
where salary < all (select salary from employees where first_name = 'David'); -- 4800���� ����


----��Į�� ����(select ����Ʈ�� select���� ���� ����, LEFT OUTER JOIN�� ������ ���-----

--��Į�� ���� ��� where���� ������ ������ ����Ѵ�.
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


--left join (�μ����� �̸�)
select * from employees;

select d.*,
       e.first_name
from departments d
left outer join employees e on d.manager_id = e.employee_id
order by d.department_id;

--��Į�� ���� (�μ����� �̸�)
select d.*,
       (select first_name
       from employees e where d.manager_id = e.employee_id) as first_name
from departments d
order by d.department_id;

--��Į�� ����(departments ���̺�, locations ���̺��� city, address ����)

select d.*,
       (select city
       from locations l where d.location_id = l.location_id) as city,
       (select street_address
       from locations l where d.location_id = l.location_id) as address
from departments d;

--��Į�� ���� (�� �μ��� �����)

select department_id, count(employee_id) from employees group by department_id;

select d.*,
       nvl((select count(*) 
       from employees e where d.department_id = e.department_id group by department_id),0) as �����
from departments d;


--------�ζ��� �� (FROM���� select���� ���� ����, FROM�� ���� ���� ������ ���̺�� ����)--------

select *
from employees;

select *
from (select * from employees);

--rownum�� ���̴� ����
select rownum, first_name, job_id, salary
from employees
order by salary;

--�ζ��� ��� �ذ�
select rownum, 
       first_name, 
       job_id, 
       salary
from( select first_name, job_id, salary
      from employees
      order by salary desc);

--�ζ��� ��� ���� ����� ���ؼ� 10�� ������ ���
select rownum,
       a.*
from (select first_name, job_id, salary
      from employees
      order by salary desc) a
where rownum <= 10;

--�ζ��� ��� ���� ����� ���ؼ� 11~20����� (rownum�� ù ��° ��(1)���� ��ȸ�� �� �ִ�)

select first_name, job_id, salary
from employees
order by salary desc;

select rownum,
       a.*
from(select first_name, job_id, salary
     from employees
     order by salary desc) a
where rownum between 11 and 20;

--���� �ζ��� ��

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

--�̰� �ȵȴ�. (rownum�� ���ڰ� ���׹���)
select *
from(select rownum as rn,
            first_name,
            salary
     from employees
     order by salary desc);
     

--�ζ��� �� (���� ���̺� ���� 3�� 1�� �����͸� ����)
select 'ȫ�浿' as name, '20200211' as test from dual union all
select '�̼���', '20200301' from dual union all
select '������', '20200314' from dual union all
select '������', '20200403' from dual union all
select 'ȫ����', '20200301' from dual;

select *
from (select name,
       to_char(to_date(test, 'YYYYMMDD'), 'MM-DD') as mm
      from (select 'ȫ�浿' as name, '20200211' as test from dual union all
            select '�̼���', '20200301' from dual union all
            select '������', '20200314' from dual union all
            select '������', '20200403' from dual union all
            select 'ȫ����', '20200301' from dual))
where mm = '03-01';
            
select name,
       to_char(to_date(test, 'YYYYMMDD'), 'MM-DD') as mm
from (select 'ȫ�浿' as name, '20200211' as test from dual union all
select '�̼���', '20200301' from dual union all
select '������', '20200314' from dual union all
select '������', '20200403' from dual union all
select 'ȫ����', '20200301' from dual);

--���� (JOIN���̺��� ��ġ�� �ζ��� �� ���� ���� or ��Į�� ������ ȥ���ؼ� ��� ����)
--salary�� 10000�̻��� ������ �̸�, �μ���, �μ��� �ּ�, job_title�� ��� salary �������� ��������

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
--from ���� ���� ���̺�
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
      
--����.
--where���� ���� ���������� ������ vs ������ (in, any, all)
--��Į�� ���� - select����Ʈ�� ���� ��������(�������� ����� ��������, left outer join�� ���� ����)
--�ζ��� �� - from���� ���� ��������(���ʿ��� �ʿ��� �������� �ۼ�, ���� ���̺��� ����)