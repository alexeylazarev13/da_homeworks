--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1 (+)
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

select ships.class, count(*) from ships
join outcomes on ships.name = outcomes.ship
where outcomes.result = 'sunk'
group by ships.class


--------------------------------------------

--task2 (+)
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select cl.class, subpr.date from classes cl
left join (select class, min(launched) as date from ships group by class) as subpr on cl.class = subpr.class
order by subpr.date 

--------------------------------------------


--task3 (+)
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

select class, count(result) as s
from 
(
select class, result, name 
from ships 
left join outcomes on ship=name 
and class is not null 
and result = 'sunk'
 ) t
group by class 
having count(class) > 2 
and count(result) > 0
--------------------------------------------
через with до конца не додумал:

with tab as 
(
select classes.class from classes 
left join ships on classes.class = ships.class
left join outcomes o on o.ship=ships.name 
and ships.class is not null 
and o.result = 'sunk'
)
select class from tab 
group by class 
having count(class) > 2

--------------------------------------------

--task4 (пока не решил (-))
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with tab as 
(
select ships.name from ships union all
select outcomes.ship from outcomes
)
select distinct name from tab 

------------------------------------------

--task5 (+)
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

with tab as 
(select maker, ram, speed from product
join pc on pc.model=product.model
where type='PC' 
and maker in (select maker from product where type = 'Printer')
and ram = (select min(ram) from pc))
select distinct maker from tab
where speed = (select max(speed) from tab)

--------------------------------------------