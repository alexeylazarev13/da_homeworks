
--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

with tt as ( 
select code, model, price from pc union all  
select code, model, price from printer  union all  
select code, model, price from laptop ) 
    select tt.model from tt
    where tt.price = (select min(price) from tt )
    
--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) и сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

    create table all_products_with_index_task5 as 
with tt as ( 
select code, model, price 
   from pc 
   union all  
    select code, model, price 
    from printer  
   union all  
    select code, model, price 
    from laptop   
    ) 
    select tt.code, tt.model, tt.price , row_number() over (partition by maker order by price DESC) as price_index  , 
      case when price > (select max(price) from printer) then 1 
  else 0
  end flag 
  from tt
   left join product   
    on product.model = tt.model 
  
 create index price_idx1 on all_products_with_index_task5 (price_index);