use shop;


/* —оздайте таблицу logs типа Archive. ѕусть при каждом создании записи в таблицах users, 
catalogs и products в таблицу logs помещаетс€ врем€ и дата создани€ записи, название таблицы, 
идентификатор первичного ключа и содержимое пол€ name.
*/
drop table if exists logs;

create table logs(
	id bigint auto_increment,
	key(id),
    date_create    DATETIME DEFAULT CURRENT_TIMESTAMP,
    log_table_name varchar(255),
    log_key        bigint,
    log_key_name   varchar(255)
) ENGINE=ARCHIVE;

drop trigger if exists log_users_after_insert;
drop trigger if exists log_catalogs_after_insert;
drop trigger if exists log_products_after_insert;

delimiter //
	
create trigger log_users_after_insert after insert on users
for each row
begin 
	insert into logs (date_create, log_table_name, log_key, log_key_name) 
	values (now(), 'users', new.id, new.name);
end // 

create trigger log_catalogs_after_insert after insert on catalogs
for each row
begin 
	insert into logs (date_create, log_table_name, log_key, log_key_name) 
	values (now(), 'catalogs', new.id, new.name);
end //

create trigger log_products_after_insert after insert on products
for each row
begin 
	insert into logs (date_create, log_table_name, log_key, log_key_name) 
	values (now(), 'products', new.id, new.name);
end //

delimiter ;


