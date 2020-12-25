use medicalcenter;

/*
Процедура, которая выводит список Клиник, в которых принимает врач
*/
drop procedure if exists DoctorTakeClinic;

DELIMITER //

create procedure DoctorTakeClinic(in DoctorId bigint)
begin
	
  select
    DoctorFIO(D.DoctorID) as FIO_Doctor,
    C.Title,
    C.Adress,
    C.Phone,
    C.TimeWork
  from LinksDoctorsClinics LDC
  inner join Doctors D on D.DoctorId = LDC.DoctorId
  inner join Clinics C on C.ClinicId = LDC.ClinicId
  where LDC.DoctorId = DoctorId
  order by C.Title;
 
end //

DELIMITER ;

/*
Доступное время записи к врачу на дату
*/
drop procedure if exists ScheduleDoctorFree;

DELIMITER //

create procedure ScheduleDoctorFree(in DoctorId bigint, DateVisit date)
begin
	
  select
    DoctorFIO(D.DoctorID) as FIO_Doctor,
    DW.ShortDayName,
    S.TimeSch,
    C.Title,
    C.Adress,
    S.Room
  from Schedule S
  inner join Doctors D on D.DoctorId = S.DoctorId
  inner join Clinics C on C.ClinicId = S.ClinicId
  inner join DaysWeek DW on DW.DayId = IF(DAYOFWEEK(S.DateSch) - 1 = 0, 7, DAYOFWEEK(S.DateSch) - 1)
  where S.DoctorId = DoctorId
    and S.DateSch = DateVisit
    and S.isFree = 1
  order by S.TimeSch;
 
end //

DELIMITER ;

/*
Активные записи пользователя
*/
drop procedure if exists UserRecordsActive;

DELIMITER //

create procedure UserRecordsActive(in UserId bigint)
begin
	
  select
    DoctorFIO(D.DoctorID) as FIO_Doctor,
    SP.SpecializationName,
    DW.ShortDayName,
    S.TimeSch,
    C.Title,
    C.Adress,
    S.Room
  from RecordsVisit RV
  inner join Schedule S on S.ScheduleId = RV.ScheduleId
  inner join Doctors D on D.DoctorId = S.DoctorId
  inner join Specializations SP on SP.SpecializationId = D.SpecializationId
  inner join Clinics C on C.ClinicId = S.ClinicId
  inner join DaysWeek DW on DW.DayId = IF(DAYOFWEEK(S.DateSch) - 1 = 0, 7, DAYOFWEEK(S.DateSch) - 1)
  where RV.UserId = UserId
    and S.DateSch >= CURRENT_DATE()
  order by S.DateSch, S.TimeSch;
 
end //

DELIMITER ;

/*
Кол-во записей в разрезе врачей на дату
*/
drop procedure if exists CountRecorsToDoctor;

DELIMITER //

create procedure CountRecorsToDoctor(DateRecord date)
begin
	
  select
    Count(RecordVisitId) as count_records,
    DoctorFIO(S.DoctorID) as FIO_Doctor
  from RecordsVisit RV
  inner join Schedule S on S.ScheduleId = RV.ScheduleId
  where S.DateSch = DateRecord
  group by FIO_Doctor
  order by count_records;
 
end //

DELIMITER ;

/*
Врачи определенной специализации
*/

DROP PROCEDURE IF EXISTS GetSpecialists;

DELIMITER //

CREATE PROCEDURE GetSpecialists(SpecializationId int)
begin
	
	declare FIO_Doctor varchar(255);

	select 
	  DoctorFIO(D.DoctorID) as FIO_Doctor
	from Doctors D
	where D.SpecializationId = SpecializationId
	order by FIO_Doctor;

end //

DELIMITER ;
