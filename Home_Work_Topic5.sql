use shop;

/*
1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*/

update users set
  created_at = now(),
  updated_at = now()
;

/*
2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, 
сохранив введённые ранее значения.
*/

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at varchar(30),
  updated_at varchar(30)
);

INSERT INTO users_old (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '20.10.2020 8:10', '03.10.2020 7:20'),
  ('Наталья', '1984-11-12', '06.11.2020 5:10', '13.11.2020 1:20'),
  ('Александр', '1985-05-20', '03.09.2020 9:17', '24.09.2020 7:20');
 
alter table users_old add column created_at_new datetime;
alter table users_old add column updated_at_new datetime;
 
update users_old set
  created_at_new = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'),
  updated_at_new = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i')
;

alter table users_old drop column created_at;
alter table users_old drop column updated_at;

alter table users_old change column created_at_new created_at datetime;
alter table users_old change column updated_at_new updated_at datetime;

select * from users_old;

/*
 * 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, 
 * если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 * Однако нулевые запасы должны выводиться в конце, после всех 
 */
select 
  *   
from storehouses_products
order by if (value = 0, 1, 0), value; 

/*4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)*/

select 
* 
from users
where monthname(birthday_at) in ('May', 'August');

/*
5. Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
Отсортируйте записи в порядке, заданном в списке IN.
*/
SELECT 
  * 
FROM 
catalogs 
WHERE id IN (5, 1, 2)
order by case id 
           when 5 then 0
           when 1 then 1
           when 2 then 2
          end 
;

/*6. Подсчитайте средний возраст пользователей в таблице users*/

select 
  AVG(timestampdiff(year, birthday_at, now())) as age_avg
from users;

/*
7. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 */
DROP TABLE IF EXISTS day_week_names;
CREATE TABLE day_week_names (
  day_week_Id tinyint unsigned  PRIMARY KEY,
  day_week_Name varchar(20)
) COMMENT = 'Дни недели';

insert into day_week_names values 
(1, 'Понедельник'), (2, 'Вторник'), (3, 'Среда'), (4, 'Четверг'), (5, 'Пятница'), (6, 'Суббота'), (7, 'Воскресенье');

select
  dw.day_week_Name,
  R.count_bd
from 
(
	select
	  count(*) as count_bd, 
	  IF(DAYOFWEEK(bd_n.bd_now) - 1 = 0, 7, DAYOFWEEK(bd_n.bd_now) - 1) as day_of_week
	from 
	(
		select 
		  STR_TO_DATE(concat(year(now()), '-', month(birthday_at), '-', DAYOFMONTH(birthday_at)), '%Y-%m-%d') as bd_now
		from users
	) as bd_n
	group by day_of_week
) R
inner join day_week_names dw on dw.day_week_Id = R.day_of_week
order by dw.day_week_Id;

/*8.Подсчитайте произведение чисел в столбце таблицы.*/
drop table if exists tbl;
CREATE TABLE tbl (
  value INT
);
INSERT INTO tbl VALUES (1), (2), (3), (4), (5);

select 
  MIN(ABS(SIGN(value)))*POWER(-1, SUM(SIGN(1-SIGN(1+2*SIGN(value)))))*EXP(SUM(LOG(ABS(IFNULL(NULLIF(value,0),1))))) as mult
from tbl;


