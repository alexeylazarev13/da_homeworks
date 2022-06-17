--task1  (lesson8) +
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

with tab as (
select e.salary as Salary, d.name as Department, e.name as Employee, DENSE_RANK() OVER ( PARTITION BY d.name ORDER BY e.salary DESC) as rn  
    from employee e
    left join department d on e.departmentId = d.id
    )
    select tab.Department, tab.Employee, tab.Salary from tab
    where tab.rn < 4 ;

--task2  (lesson8) +
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, 
status, 
SUM(amount*unit_price) as costs 
from Payments 
join FamilyMembers
on Familymembers.member_id = payments.family_member
where Year (date)='2005'
GROUP BY member_name, status

--task3  (lesson8) +
-- https://sql-academy.org/ru/trainer/tasks/13
select name from Passenger
group by name 
having count(name) > 1

--task4  (lesson8) +
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count 
from Student
where first_name = 'Anna'

--task5  (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(classroom) as count 
from Schedule
where date like '2019-09-02%'

--task6  (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count 
from Student
where first_name = 'Anna'

--task7  (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/32

select floor(avg(floor(datediff(now(), birthday)/365))) as age 
from familymembers

--task8  (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, sum(amount*unit_price) as costs
from goodtypes
join goods on good_type_id=type
join payments on good_id=good
where year(date)=2005
group by good_type_name

--task9  (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/37

select floor(min(floor(datediff(now(), 
birthday)/365))) as year
from Student

--task10  (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/44

select floor(max(floor(datediff(now(), 
birthday)/365))) as max_year
from Student
join Student_in_class st on Student.id = st.student
JOIN Class ON st.class=Class.id
WHERE Class.name like '10%'

--task11 (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/20
select status , member_name from FamilyMembers

select status, member_name 
#,good_type_name
, sum(amount*unit_price) as costs
from goodtypes
join goods on good_type_id=type
join payments on good_id=good
join FamilyMembers on member_id = family_member 
where good_type_name= 'entertainment'
group by good_type_name, status, member_name 

--task12  (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/55

delete from company
where company.id in (
    select company from trip
    group by company
    having count(id) = (select min(count) from (select count(id) as count from trip group by company) as min_count))

--task13  (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/45

with tab as (
select classroom
#, count(classroom) 
from Schedule
group by classroom 
order by count(classroom) desc 
)
select * from tab 
limit 2

--task14  (lesson8) (+)
-- https://sql-academy.org/ru/trainer/tasks/43

select last_name 
#, schedule.subject
from teacher 
join schedule on teacher.id = schedule.teacher
join Subject on Schedule.subject = subject.id
where subject.name = 'Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select concat(last_name, '.', left(first_name, 1), '.', left(middle_name, 1), '.') as name
from student
order by last_name, first_name;

