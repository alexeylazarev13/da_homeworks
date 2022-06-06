--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

with tab as 
( 
  select model, price from pc union all   
  select model, price from laptop  union all 
  select model, price from printer 
) 
select distinct tab.model, maker, type from tab
join product on tab.model=product.model  
order by model, type desc  

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select code, model, color, type, price, 
case when pr.price > (select avg(price) from pc) then 1
else 0
end moreavgthenpc 
from printer pr

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
with tab as 
(
select class, name from ships union all 
select ships.class, ship from outcomes 
left join ships 
on ships.name = outcomes.ship  
)
select distinct name, class from tab 
order by class, name desc 

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

select name from battles
where to_char(date, 'yyyy') not in
(select to_char(launched, 'yyyy') from ships )

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select name, class, outcomes.battle from ships 
left join outcomes on outcomes.ship = ships.name 
where class = 'Kongo'

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create or replace view all_products_flag_300 as 
with tab as(
  select model, price from pc union all   
  select model, price from laptop  union all 
  select model, price from printer 
  )
  select model, price, 
  case when price > 300 then 1 
  else 0
  end flag 
  from tab
  
--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

 create or replace view all_products_flag_avg_price as 
  with tab as(
  select model, price from pc union all   
  select model, price from laptop  union all 
  select model, price from printer 
  )
  select model, price, 
  case when price > (select avg(price) from tab) then 1 
  else 0
  end flag 
  from tab
  
select * from all_products_flag_avg_price 
  
--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

--select product.maker, product.model, product.type, printer.price from product 
select product.model from product 
left join printer on product.model = printer.model
where product.type = 'Printer' 
and product.maker = 'A'
and printer.price > 
(select avg(price) from product 
left join printer on product.model = printer.model
where product.type = 'Printer' 
and product.maker = 'D' or product.maker = 'C')

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select product.model from product 
left join printer on product.model = printer.model
where product.type = 'Printer' 
and product.maker = 'A'
and printer.price > 
(select avg(price) from product 
left join printer on product.model = printer.model
where product.type = 'Printer' 
and product.maker = 'D' or product.maker = 'C')

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

with tab as 
(select product.maker, product.model, product.type, printer.price from product left join printer on product.model = printer.model
where product.maker = 'A' and product.type = 'Printer' union all
select product.maker, product.model, product.type, pc.price from product left join pc on product.model = pc.model
where product.maker = 'A' and product.type = 'PC' union all
select product.maker, product.model, product.type, laptop.price from product left join laptop on product.model = laptop.model
where product.maker = 'A' and product.type = 'Laptop' 
) 
select avg(price) from tab 

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create or replace view count_products_by_makers as 
select maker, count(*) from product 
group by maker 
order by maker asc 

select * from count_products_by_makers 

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = "select * from count_products_by_makers"
f = pd.read_sql_query(request, conn)
fig = px.bar(f, x='maker', y='count')
fig.show()

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as 
select pr.code, pr.model, pr.color, pr.type, pr.price from printer pr
left join product on product.model = pr.model where product.maker <> 'D'

select * from printer_updated 

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create or replace view printer_updated_with_makers as 
select pr.code, pr.model, pr.color, pr.type, pr.price, product.maker from printer_updated pr
left join product on product.model = pr.model 

select * from printer_updated_with_makers 

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create or replace view sunk_ships_by_classes as 
with tab as (
select count(result), ships.class from outcomes
full join ships
on ships.name = outcomes.ship where outcomes.result = 'sunk'
group by ships.class
)
select count, class
from tab 

--task11 (lesson4)
-- Корабли: По п редыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

select * from sunk_ships_by_classes

request = "select * from sunk_ships_by_classes"
f = pd.read_sql_query(request, conn)
fig = px.bar(f, x='class', y='count')
fig.show()

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as 
select class, type, country, numguns, bore, displacement,
case when numguns > 9 then 1 else 0 end flag
from classes 

select * from classes_with_flag 

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

select country, count(*) from classes group by country 

request = "select country, count(*) from classes group by country"
f = pd.read_sql_query(request, conn)
fig = px.bar(f, x='country', y='count')
fig.show()

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
with tab as (
select name from ships union all  
select ship from outcomes 
)
select count(*) from tab 
where name like ('O%') or name like ('M') 

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
with tab as (
select name from ships union all  
select ship from outcomes 
)
select * from tab 
where name like ('% %') 

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

 select launched , count(*) from ships
 group by launched 
 order by launched asc 
 
 
request = """
 select launched , count(*) from ships
 group by launched 
 order by launched asc 
"""
f = pd.read_sql_query(request, conn)
fig = px.bar(f, x='launched', y='count')
fig.show()
 

