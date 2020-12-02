use shop;

/* 1.��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.*/
select 
  U.id,  
  U.name 
from users U
where exists (select * from orders O where O.user_id = U.id);

/* 2.�������� ������ ������� products � �������� catalogs, ������� ������������� ������.*/
select 
  p.name,
  p.description,
  p.price,
  c.name as catalog_name
from products p 
inner join catalogs c on c.id = p.catalog_id ; 

/* 3.����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label, name). 
 * ���� from, to � label �������� ���������� �������� �������, ���� name � �������. �������� ������ ������ flights � �������� ���������� �������.
 */
select 
  c_from.name,
  c_to.name
from flights f
left join cities c_from on c_from.label= f.`from`
left join cities c_to on c_to.label= f.`to`;