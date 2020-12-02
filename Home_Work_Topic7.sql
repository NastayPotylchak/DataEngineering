use shop;

/* 1.Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.*/
select 
  U.id,  
  U.name 
from users U
where exists (select * from orders O where O.user_id = U.id);

/* 2.Выведите список товаров products и разделов catalogs, который соответствует товару.*/
select 
  p.name,
  p.description,
  p.price,
  c.name as catalog_name
from products p 
inner join catalogs c on c.id = p.catalog_id ; 

/* 3.Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
 * Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
 */
select 
  c_from.name,
  c_to.name
from flights f
left join cities c_from on c_from.label= f.`from`
left join cities c_to on c_to.label= f.`to`;