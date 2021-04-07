--���� 1.
---EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� �����͸� ��� �ϼ��� ( AVG(�÷�) ���)

select *
from employees
where salary > (select avg(salary) from employees);

---EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� ���� ����ϼ���

select count(salary)
from employees
where salary > (select avg(salary) from employees);

---EMPLOYEES ���̺��� job_id�� IT_PFOG�� ������� ��ձ޿����� ���� ������� �����͸� ����ϼ���.

select *
from employees
where salary > (select avg(salary) from employees where job_id = 'IT_PROG');

--���� 2.
---DEPARTMENTS���̺��� manager_id�� 100�� ����� department_id��
--EMPLOYEES���̺��� department_id�� ��ġ�ϴ� ��� ����� ������ �˻��ϼ���.

select *
from departments
where manager_id = 100;

select *
from employees
where department_id = (select department_id from departments where manager_id = 100);

--���� 3.
---EMPLOYEES���̺��� ��Pat���� manager_id���� ���� manager_id�� ���� ��� ����� �����͸� ����ϼ���

select *
from employees
where manager_id > (select manager_id from employees where first_name = 'Pat');

---EMPLOYEES���̺��� ��James��(2��)���� manager_id�� ���� ��� ����� �����͸� ����ϼ���.

select *
from employees
where manager_id in (select manager_id from employees where first_name = 'James');

--���� 4.
---EMPLOYEES���̺� ���� first_name�������� �������� �����ϰ�, 41~50��° �������� �� ��ȣ, �̸��� ����ϼ���

select rn, first_name
from (select rownum as rn, first_name
      from (select first_name
            from employees
            order by first_name desc))
where rn between 41 and 50;

--���� 5.
---EMPLOYEES���̺��� hire_date�������� �������� �����ϰ�, 31~40��° �������� �� ��ȣ, ���id, �̸�, ��ȣ, 
--�Ի����� ����ϼ���.

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

--���� 6.
--employees���̺� departments���̺��� left �����ϼ���
--����) �������̵�, �̸�(��, �̸�), �μ����̵�, �μ��� �� ����մϴ�.
--����) �������̵� ���� �������� ����

select e.employee_id as �������̵�, 
       concat(e.first_name || ' ' , e.last_name) as �̸�,
       d.department_id as �μ����̵�,
       d.department_name as �μ���
from employees e
left outer join departments d on e.department_id = d.department_id
order by employee_id asc;

--���� 7.
--���� 6�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���

select e.employee_id as �������̵�,
       concat(e.first_name || ' ' , e.last_name) as �̸�,
       e.department_id as �μ����̵�,
       (select department_name from departments d where d.department_id = e.department_id) as �μ���
from employees e
order by employee_id asc;

--���� 8.
--departments���̺� locations���̺��� left �����ϼ���
--����) �μ����̵�, �μ��̸�, �Ŵ������̵�, �����̼Ǿ��̵�, ��Ʈ��_��巹��, ����Ʈ �ڵ�, ��Ƽ �� ����մϴ�
--����) �μ����̵� ���� �������� ����
select *
from locations;

select d.department_id as �μ����̵�,
       d.department_name as �μ��̸�,
       d.manager_id as �Ŵ������̵�,
       d.location_id as �����̼Ǿ��̵�,
       l.street_address as st,
       l.postal_code as pc,
       l.city as ��Ƽ
from departments d
left outer join locations l on d.location_id = l.location_id
order by department_id asc;


--���� 9.
--���� 8�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���

select d.department_Id as �μ����̵�, 
       d.department_name as �μ��̸�,
       d.manager_id as �Ŵ������̵�,
       d.location_id as �����̼Ǿ��̵�,
       (select street_address from locations l where l.location_id = d.location_id) as st,
       (select postal_code from locations l where l.location_id = d.location_id) as pc,
       (select city from locations l where l.location_id = d.location_id) as ��Ƽ
from departments d
order by department_id asc;

--���� 10.
--locations���̺� countries ���̺��� left �����ϼ���
--����) �����̼Ǿ��̵�, �ּ�, ��Ƽ, country_id, country_name �� ����մϴ�
--����) country_name���� �������� ����

select l.location_id as location_id,
       l.street_address as st,
       l.city as city,
       l.country_id as country_id,
       c.country_name as country_name
from locations l
left outer join countries c on c.country_id = l.country_id
order by country_name asc;
       
--���� 11.
--���� 10�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���

select l.location_id as location_id,
       l.street_address as st,
       l.city as city,
       l.country_id as country_id,
       (select country_name from countries c where c.country_id = l.country_id) as country_name
from locations l
order by country_name asc;

--���� 12.
--employees���̺�, departments���̺��� left���� hire_date�� �������� �������� 1-10��° �����͸� ����մϴ�
--����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, ��ȭ��ȣ, �Ի���, �μ����̵�, �μ��̸� �� ����մϴ�.
--����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� Ʋ������ �ȵ˴ϴ�.

select *
from (select rownum as rn, a.*
      from (select e.employee_id as �������̵�,
                   concat(first_name || ' ', last_name) as �̸�,
                   e.phone_number as ��ȭ��ȣ,
                   e.hire_date as �Ի�����,
                   e.department_id as �μ����̵�,
                   d.department_name as �μ��̸�
            from employees e
            left outer join departments d on e.department_id = d.department_id
            order by hire_date) a)
where rn between 1 and 10;


--���� 13.
--EMPLOYEES �� DEPARTMENTS ���̺��� JOB_ID�� SA_MAN ����� ������ LAST_NAME, JOB_ID,
--DEPARTMENT_ID,DEPARTMENT_NAME�� ����ϼ���

select e.last_name,
       e.job_id,
       e.department_id,
       d.department_name
from employees e
left outer join departments d on e.department_id = d.department_id
where job_id = 'SA_MAN';

--���̺� ��ġ�� �ζ��� ��
select e.last_name,
       e.job_id,
       e.department_id,
       d.department_name
from (select *
      from employees
      where job_id = 'SA_MAN') e
left outer join departments d on e.department_id = d.department_id;


--���� 14
--DEPARTMENT���̺��� �� �μ��� ID, NAME, MANAGER_ID�� �μ��� ���� �ο����� ����ϼ���.
--�ο��� ���� �������� �����ϼ���.
--����� ���� �μ��� ������� �ʽ��ϴ�

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


--���� ���̺��� group by�� department_id�� ������� ����
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


--���� 15
--�μ��� ���� ���� ���ο�, �ּ�, �����ȣ, �μ��� ��� ������ ���ؼ� ����ϼ���
--�μ��� ����� ������ 0���� ����ϼ���

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



--���� 16
--���� 15����� ���� DEPARTMENT_ID�������� �������� �����ؼ� ROWNUM�� �ٿ� 1-10������ ������
--����ϼ���


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