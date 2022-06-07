--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

select ff.code, ff.model, speed, ff.ram, ff.hd, ff.price, ff.screen, 
case when ff.num%2 = 0 then ff.num/2 else ff.num/2 + 1 
end as page, 
case when total % 2 = 0 
then total/2 
else total/2 + 1 
end as sum_page
from (select *, row_number(*) over(order by model desc) as num, count(*) over() as total 
from Laptop
) ff

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

create view distribution_by_type as
with tt as (
	select maker, type, count(*) * 100.0 / (select count(*) from product) as proc
	from product 
	group by maker, type 
	order by maker )
	select * from tt 

	select * from distribution_by_type 
	
--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/
	
request = "select * from distribution_by_type "
df = pd.read_sql_query(request, conn)
fig = px.pie(df, values='proc', names='maker', color_discrete_sequence=px.colors.sequential.RdBu)
fig.show()
	
--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words as 
select * from ships 
where ships.name like ('% %')

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

with tab as 
	(
	select class, name from ships union all 
	select ships.class, ship from outcomes 
	left join ships 
	on ships.name = outcomes.ship  
	)
		select name from tab 
		where tab.class is null 
		and tab.name like ('S%') 
		order by name desc 

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

with tab as 
	(
	select p.code, p.model, p.color, p.type, p.price, product.maker, rank() over (order by price) as rnk from printer p 
	left join product on p.model = product.model 
	where product.maker = 'A'
	and p.price > (select avg(price) 
	from printer left join product on printer.model = product.model where product.maker = 'C')
	)
		select code, model, color, type, price, maker, rnk from tab 
		order by rnk limit 3