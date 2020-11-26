use shop;

/*
1. ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.
*/

update users set
  created_at = now(),
  updated_at = now()
;

/*
2. ������� users ���� �������� ��������������. ������ created_at � updated_at ���� ������ ����� VARCHAR 
� � ��� ������ ����� ���������� �������� � ������� 20.10.2017 8:10. ���������� ������������� ���� � ���� DATETIME, 
�������� �������� ����� ��������.
*/

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at varchar(30),
  updated_at varchar(30)
);

INSERT INTO users_old (name, birthday_at, created_at, updated_at) VALUES
  ('��������', '1990-10-05', '20.10.2020 8:10', '03.10.2020 7:20'),
  ('�������', '1984-11-12', '06.11.2020 5:10', '13.11.2020 1:20'),
  ('���������', '1985-05-20', '03.09.2020 9:17', '24.09.2020 7:20');
 
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
 * 3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 0, ���� ����� ���������� � ���� ����, 
 * ���� �� ������ ������� ������. ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. 
 * ������ ������� ������ ������ ���������� � �����, ����� ���� 
 */
select 
  *   
from storehouses_products
order by if (value = 0, 1, 0), value; 

/*4. �� ������� users ���������� ������� �������������, ���������� � ������� � ���. ������ ������ � ���� ������ ���������� �������� (may, august)*/

select 
* 
from users
where monthname(birthday_at) in ('May', 'August');

/*
5. �� ������� catalogs ����������� ������ ��� ������ �������. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
������������ ������ � �������, �������� � ������ IN.
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

/*6. ����������� ������� ������� ������������� � ������� users*/

select 
  AVG(timestampdiff(year, birthday_at, now())) as age_avg
from users;

/*
7. ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������. ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������.
 */
DROP TABLE IF EXISTS day_week_names;
CREATE TABLE day_week_names (
  day_week_Id tinyint unsigned  PRIMARY KEY,
  day_week_Name varchar(20)
) COMMENT = '��� ������';

insert into day_week_names values 
(1, '�����������'), (2, '�������'), (3, '�����'), (4, '�������'), (5, '�������'), (6, '�������'), (7, '�����������');

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

/*8.����������� ������������ ����� � ������� �������.*/
drop table if exists tbl;
CREATE TABLE tbl (
  value INT
);
INSERT INTO tbl VALUES (1), (2), (3), (4), (5);

select 
  MIN(ABS(SIGN(value)))*POWER(-1, SUM(SIGN(1-SIGN(1+2*SIGN(value)))))*EXP(SUM(LOG(ABS(IFNULL(NULLIF(value,0),1))))) as mult
from tbl;


