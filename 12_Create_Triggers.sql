USE MedicalCenter;

/* ������� ��� �������� ����������� ����� ����� ����� � �������. 
� ���� ���� ���� ����� ��������� ����� ������ � ����� �� ������ ������.
*/
drop trigger if exists check_Schedule_before_insert;

delimiter //
	
create trigger check_Schedule_before_insert before insert on Schedule
for each row
begin 
	if exists (select * from Schedule Sc where Sc.DoctorId = new.DoctorId and Sc.ClinicId != new.ClinicId and Sc.DateSch = new.DateSch) then
		signal sqlstate '45000' set message_text = '���� ����� ����� ������ �������.';
	end if;
end//

delimiter ;

/* ������� ��� �������� ����������� �������� ����� 
����� ����� �������� ������ �������, ������� ���� �� ���� ��� ��� �� ������ � �����
*/
drop trigger if exists check_ReviewsDoctors_before_insert;

delimiter //
	
create trigger check_ReviewsDoctors_before_insert before insert on ReviewsDoctors
for each row
begin 
	if not exists (select * from UsersVisits UV where UV.DoctorId = new.DoctorId and UV.UserId = new.UserId) then
		signal sqlstate '45000' set message_text = '��� ��������� ���������� �������� �����.';
	end if;
end//

delimiter ;

-- ������� ��� �������� ������������ ���� �������� ��� �������
drop trigger if exists check_user_Birthday_before_insert;

delimiter //
	
create trigger check_user_Birthday_before_insert before insert on Users
for each row
begin 
	if new.Birthday >= current_date() then
		signal sqlstate '45000' set message_text = 'Insert Canceled. Birthday must be in the past!';
	end if;
end//

delimiter ;

-- ������� ��� �������� ������������ ���� �������� ��� ����������
drop trigger if exists check_user_Birthday_before_update;

delimiter //
	
create trigger check_user_Birthday_before_update before update on Users
for each row
begin 
	if new.Birthday >= current_date() then
		signal sqlstate '45000' set message_text = 'Update Canceled. Birthday must be in the past!';
	end if;
end//

delimiter ;