/*
В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
Используйте транзакции.
*/

use shop;

START TRANSACTION;

insert into sample.users (Id, User_Name)
select
  U.Id,
  U.name 
 from users U
 where U.id = 1
  and not exists (select * from sample.users where Id = 1);
 
 select * from sample.users

COMMIT;

/*
Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
 * */
create or replace VIEW products_info 
AS 
  select 
    c.name as catalog_name,
    p.name
  from products p 
  inner join catalogs c on c.id = p.catalog_id 
  order by catalog_name, p.name;

select * from products_info;

/* Пусть имеется любая таблица с календарным полем created_at. 
 * Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей. 
 * */
start transaction; 

delete o
from orders o
left join (select id from orders order by created_at desc limit 5) o_n on o.id = o_n.id
where o_n.id is null;

commit; 

/*
Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello()
RETURNS varchar(100) reads sql data
begin
	
	SET @time_now = DATE_FORMAT(NOW(), "%H:%i");
    
	  case
		when (@time_now >= '06:00' and  @time_now < '12:00')  then return 'Доброе утро';
	    when (@time_now >= '12:00' and  @time_now < '18:00')  then return 'Добрый день';
	    when (@time_now >= '18:00' and  @time_now < '10:00')  then return 'Добрый вечер';
	    when (@time_now >= '00:00' and  @time_now < '06:00')  then return 'Доброй ночи';
	  else return  'Промежуток не определен';
	  end case;
end //

DELIMITER ;

select hello() as str_Hello;

/*
В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. 
Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/

drop trigger if exists products_validation_fields_insert;
drop trigger if exists products_validation_fields_update;

delimiter //

create trigger products_validation_fields_insert before insert on products
for each row
begin 
	if (new.name is null and new.description is null) then
		signal sqlstate '45000'
		set message_text = "Error insert row. Field [Name] and [Description] is NULL";
	end if;
end//

create trigger products_validation_fields_update before update on products
for each row
begin 
	if (new.name is null and new.description is null) then
		signal sqlstate '45000'
		set message_text = "Error update row. Field [Name] and [Description] is NULL";
	end if;
end//

delimiter ;

/*
Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
Вызов функции FIBONACCI(10) должен возвращать число 55.
 */
DROP FUNCTION IF EXISTS FIBONACCI;

DELIMITER //

CREATE FUNCTION FIBONACCI (Digit INT)
	RETURNS float(38) reads sql data 
BEGIN
	declare Counter INT; 
    declare One float(38); 
    declare Two float(38);
	
	SET Two = 1;
	
	IF Digit > 2 then

			SET Counter = 3;
			SET One = 1;
			
			WHILE Digit >= Counter do

					SET Two = One + Two;
					SET One = Two - One;
					SET Counter = Counter + 1;
				end while;
		end if;	
 
	RETURN Two;
end //

DELIMITER ;

select FIBONACCI (10);

