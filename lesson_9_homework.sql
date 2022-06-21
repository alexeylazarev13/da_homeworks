--task1  (lesson9) (+)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

with xtab as (
    select st.id, st.name, st.marks, gr.grade
    from Students st 
    inner join grades gr on st.marks between gr.min_mark and gr.max_mark
            )
select 
     case when t.Grade >= 8 then t.Name 
      else 'NULL' end as Name  
     , t.grade
     , t.marks
    from xtab t
        order by t.grade desc, t.name asc;

--task2  (lesson9) (?)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

SELECT LISTAGG(name, ', ') WITHIN GROUP (ORDER BY x_rank /*occupation*/) "List"
  FROM (
        select case when name is null then 'NULL' else name end as name
      , occupation
      , decode(occupation, 'Doctor', 1,'Professor', 2, 'Singer', 3, 'Actor', 4, 99 ) x_rank
   from occupations)
group by x_rank -- occupation 
ORDER BY --occupation 
x_rank;

--task3  (lesson9) (+)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city
from station
where not 
(city like 'a%' 
or  city  like 'e%' 
or city  like 'i%' 
or city  like 'o%' 
or city  like 'u%');

--task4  (lesson9) (+)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city from station 
where city not like '%a' 
and city not like '%e' 
and city not like '%i' and city not like '%o' and city not like '%u';

--task5  (lesson9) (+)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city from station where city not in 
(select city from station where 
(city like 'a%' 
or city like 'e%' 
or city like 'i%' 
or city like 'o%' 
or city like 'u%') 
and 
(city like '%a' 
or city like '%e' 
or city like '%i' 
or city like '%o' 
or city like '%u'));


--task6  (lesson9) (+)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city from station where city not in 
(select city from station where (city like 'a%' or city like 'e%' or city like 'i%' or city like 'o%' or city like 'u%') 
and (city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u'));

--task7  (lesson9) (+)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name from employee
where salary > 2000 and months < 10
order by employee_id;

--task8  (lesson9) (+)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

with xtab as (
    select st.id, st.name, st.marks, gr.grade
    from Students st 
    inner join grades gr on st.marks between gr.min_mark and gr.max_mark
            )
select 
     case when t.Grade >= 8 then t.Name 
      else 'NULL' end as Name  
     , t.grade
     , t.marks
    from xtab t
        order by t.grade desc, t.name asc;
