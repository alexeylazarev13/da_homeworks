--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

request= """
create table task1_7 as 
SELECT cast(random() * 1000 as int) as a, cast(random() * 1000 as int) as b, cast(random() * 1000 as int) as c
FROM generate_series(1,1000);
"""

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email
from (select email, count(*) as c from Person group by email)
where c >= 2

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select emp1.name as Employee from employee emp1
left join employee emp2
on emp1.managerid = emp2.id
where emp1.salary > emp2.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select score, 
dense_rank() over(order by score desc) as rank
from Scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select person.firstname, person.lastname, address.city, address.state from Person
left join address on person.personId = address.personId
