USE MedicalCenter;

/* триггер для проверки возможности врача вести прием в Клинике. 
в один день врач может проводить прием только в одной из клиник центра.
*/
drop trigger if exists check_Schedule_before_insert;

delimiter //
	
create trigger check_Schedule_before_insert before insert on Schedule
for each row
begin 
	if exists (select * from Schedule Sc where Sc.DoctorId = new.DoctorId and Sc.ClinicId != new.ClinicId and Sc.DateSch = new.DateSch) then
		signal sqlstate '45000' set message_text = 'Врач ведет прием другой клинике.';
	end if;
end//

delimiter ;

/* триггер для проверки возможности оставить отзыв 
отзыв может оставить только пациент, который хотя бы один раз был на приеме у врача
*/
drop trigger if exists check_ReviewsDoctors_before_insert;

delimiter //
	
create trigger check_ReviewsDoctors_before_insert before insert on ReviewsDoctors
for each row
begin 
	if not exists (select * from UsersVisits UV where UV.DoctorId = new.DoctorId and UV.UserId = new.UserId) then
		signal sqlstate '45000' set message_text = 'Без посещения невозможно оставить отзыв.';
	end if;
end//

delimiter ;

-- триггер для проверки корректности даты рождения при вставке
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

-- триггер для проверки корректности даты рождения при обновлении
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