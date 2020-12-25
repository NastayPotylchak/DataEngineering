USE MedicalCenter;

/*
Функция выводит ФИО врача
*/
DROP FUNCTION IF EXISTS DoctorFIO;

DELIMITER //

CREATE FUNCTION DoctorFIO(DoctorID bigint)
RETURNS varchar(255) reads sql data
begin
	
	declare FIO varchar(255);

	select 
	  CONCAT(D.LastName, ' ', D.FirstName, ' ', D.MiddleName) into FIO
	from Doctors D
	where D.DoctorID = DoctorID;

   return (FIO);
end //

DELIMITER ;

/*
Функция проверяет: есть ли свободное время у Врача на дату
*/
DROP FUNCTION IF EXISTS ExistsTimeFreeDoctor;

DELIMITER //

CREATE FUNCTION ExistsTimeFreeDoctor(DoctorId bigint, DateVisit date)
RETURNS bit reads sql data
begin
	

	if exists (select * from Schedule Sch where Sch.DoctorId = DoctorId and Sch.DateSch = DateVisit and isFree = True) then
     return true;
    else return false;
    end if;
end //

DELIMITER ;


 





