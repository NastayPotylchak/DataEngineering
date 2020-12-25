use medicalcenter;


/*
Представление, которое выводит информацию о врачах
*/
create or replace VIEW DoctorsInfo 
AS 
  select 
    DoctorFIO(D.DoctorID) as FIO_Doctor,
    C.СategoryName,
    Education,
    LengthWork,
    S.SpecializationName
  from Doctors D
  inner join Сategorys C on C.CategoryId = D.CategoryId 
  inner join Specializations S on S.SpecializationId = D.SpecializationId
  order by FIO_Doctor;
 
/*
Представление, которое выводит отзывы о врачах
*/
create or replace VIEW ReviewsList
AS 
  select 
    RD.created_at as ReviewData,
    DoctorFIO(D.DoctorID) as FIO_Doctor,
    RD.ReviewsText,
    CONCAT(U.LastName, ' ', U.FirstName, ' ', U.MiddleName) as FIO_User
  from ReviewsDoctors RD
  inner join Doctors D on D.DoctorId = RD.DoctorId 
  inner join Users U on U.UserId = RD.UserId
  order by FIO_Doctor;
 
 /*
 Информация о визитах
*/
create or replace VIEW VisitsInfo
AS 
  select 
    UV.DateVisit,
    DoctorFIO(D.DoctorID) as FIO_Doctor,
    UV.DoctorId ,
    CONCAT(U.LastName, ' ', U.FirstName, ' ', U.MiddleName) as FIO_User,
    UV.UserId,
    C.Title,
    Complaints,
    DG.DiagnosName,
    DG.DiagnosCode,
    UV.Appointment
  from UsersVisits UV
  inner join Doctors D on D.DoctorId = UV.DoctorId 
  inner join Users U on U.UserId = UV.UserId
  inner join Clinics C on C.ClinicId = UV.ClinicId
  left join Diagnosis DG on DG.DiagnosId = UV.DiagnosId
  order by UV.DateVisit, C.Title, FIO_Doctor;