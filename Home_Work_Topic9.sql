/*
� ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������. 
����������� ������ id = 1 �� ������� shop.users � ������� sample.users. 
����������� ����������.
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
�������� �������������, ������� ������� �������� name �������� ������� �� ������� products � ��������������� �������� �������� name �� ������� catalogs.
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

/* ����� ������� ����� ������� � ����������� ����� created_at. 
 * �������� ������, ������� ������� ���������� ������ �� �������, �������� ������ 5 ����� ������ �������. 
 * */
start transaction; 

delete o
from orders o
left join (select id from orders order by created_at desc limit 5) o_n on o.id = o_n.id
where o_n.id is null;

commit; 

/*
�������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� �� �������� ������� �����. 
� 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����", 
� 12:00 �� 18:00 ������� ������ ���������� ����� "������ ����", 
� 18:00 �� 00:00 � "������ �����", � 00:00 �� 6:00 � "������ ����".
*/

DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello()
RETURNS varchar(100) reads sql data
begin
	
	SET @time_now = DATE_FORMAT(NOW(), "%H:%i");
    
	  case
		when (@time_now >= '06:00' and  @time_now < '12:00')  then return '������ ����';
	    when (@time_now >= '12:00' and  @time_now < '18:00')  then return '������ ����';
	    when (@time_now >= '18:00' and  @time_now < '10:00')  then return '������ �����';
	    when (@time_now >= '00:00' and  @time_now < '06:00')  then return '������ ����';
	  else return  '���������� �� ���������';
	  end case;
end //

DELIMITER ;

select hello() as str_Hello;

/*
� ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������. ��������� ����������� ����� ����� ��� ���� �� ���. 
��������, ����� ��� ���� ��������� �������������� �������� NULL �����������. ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������. 
��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.
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
�������� �������� ������� ��� ���������� ������������� ����� ���������. ������� ��������� ���������� ������������������ � ������� ����� ����� ����� ���� ���������� �����. 
����� ������� FIBONACCI(10) ������ ���������� ����� 55.
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

