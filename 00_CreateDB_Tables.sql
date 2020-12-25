DROP DATABASE IF EXISTS MedicalCenter;
CREATE DATABASE MedicalCenter;

USE MedicalCenter;

DROP TABLE IF EXISTS Clinics;
CREATE TABLE Clinics (
  ClinicId SERIAL PRIMARY KEY,
  Title  varchar(255) COMMENT 'Название',
  Adress varchar(500) unique COMMENT 'Адрес',
  Phone  varchar(20),
  TimeWork  text COMMENT 'Режим работы',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Справочник "Клиники"';

DROP TABLE IF EXISTS Сategorys;
CREATE TABLE Сategorys (
  CategoryId    int unsigned not null auto_increment unique PRIMARY KEY,
  СategoryName  varchar(500) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Справочник "Категории врачей"';

DROP TABLE IF EXISTS Specializations;
CREATE TABLE Specializations (
  SpecializationId int unsigned not null auto_increment unique PRIMARY KEY,
  SpecializationName  varchar(500) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Справочник "Специализация"';

DROP TABLE IF EXISTS DaysWeek;
CREATE TABLE DaysWeek (
  DayId  tinyint unsigned not null unique PRIMARY KEY,
  ShortDayName char(2) COMMENT 'Краткое название',
  Description varchar(100)
) COMMENT = 'Дни недели';

DROP TABLE IF EXISTS Genders;
CREATE TABLE Genders (
  GenderId     tinyint not null unique PRIMARY KEY,
  ShortGender  char(1) COMMENT 'Краткое название',
  Description varchar(100)
) COMMENT = 'Справочник "Пол"';

DROP TABLE IF EXISTS Diagnosis;
CREATE TABLE Diagnosis (
  DiagnosId SERIAL PRIMARY KEY,
  DiagnosName  varchar(500) COMMENT 'Название диагноза',
  DiagnosCode  varchar(50) COMMENT 'Код диагноза'
) COMMENT = 'Справочник "Диагнозы"';

DROP TABLE IF EXISTS Doctors;
CREATE TABLE Doctors(
  DoctorId    serial primary key,
  FirstName   varchar(50) not null comment 'Имя врача',
  LastName    varchar(50) not null comment 'Фамилия врача',
  MiddleName  varchar(50) not null comment 'Отчество врача',
  CategoryId  int unsigned not null comment 'Категория',
  Education   varchar(255) not null comment 'Образование',
  LengthWork  tinyint unsigned not null comment 'Стаж работы',
  SpecializationId int unsigned not null comment 'Специализация',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  foreign key (CategoryId) references Сategorys(CategoryId),
  foreign key (SpecializationId) references Specializations(SpecializationId)
) COMMENT = 'Врачи';

DROP TABLE IF EXISTS LinksDoctorsClinics;
CREATE TABLE LinksDoctorsClinics(
  LinkId   serial primary key,
  DoctorId bigint unsigned not null,
  ClinicId bigint unsigned not null,
  foreign key (DoctorId) references Doctors(DoctorId),
  foreign key (ClinicId) references Clinics(ClinicId)
) COMMENT = 'В каких клиниках принимает врач';

alter table LinksDoctorsClinics add index Links_Doctors_idx (DoctorId);
alter table LinksDoctorsClinics add index Links_Clinics_idx (ClinicId);

DROP TABLE IF EXISTS Users;
CREATE TABLE  Users(
  UserId serial primary key,
  FirstName   varchar(50)  not null comment 'Имя пациента',
  LastName    varchar(50)  not null comment 'Фамилия пациента',
  MiddleName  varchar(50)  not null comment 'Отчество пациента',
  Email       varchar(120) unique,
  Phone       varchar(20)  unique,
  Birthday    date         not null,
  Hometown    varchar(100),
  GenderId    tinyint not null,
  create_at   datetime default now(),
  Pass        char(40),
  foreign key (GenderId) references Genders(GenderId)
) COMMENT = 'Пользователи-пациенты';

DROP TABLE IF EXISTS ReviewsDoctors;
CREATE TABLE ReviewsDoctors(
	Id          serial primary key,
	ReviewsText Text comment 'Текст отзыва',
	DoctorId    bigint unsigned not null,
	UserId      bigint unsigned not null,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	foreign key (DoctorId) references Doctors(DoctorId),
	foreign key (UserId)   references Users(UserId)
) COMMENT = 'Отзывы о врчах';

alter table ReviewsDoctors add index Reviews_Doctors_idx (DoctorId);

DROP TABLE IF EXISTS Schedule;
CREATE TABLE Schedule(
  ScheduleId  serial primary key,
  DateSch     date not null comment 'Дата приема',
  DoctorId    bigint unsigned not null,
  TimeSch     time not null comment 'Время приема',
  ClinicId    bigint unsigned not null,
  Room        tinyint not null comment 'Кабинет',
  isFree      bit default 0 comment 'Свободно(1)/Занято(0)',
  foreign key (DoctorId) references Doctors(DoctorId),
  foreign key (ClinicId) references Clinics(ClinicId)
) COMMENT = 'Расписание врачей';

alter table Schedule add index Schedule_Doctors_idx (DoctorId);
alter table Schedule add index Schedule_DateSch_idx (DateSch);

DROP TABLE IF EXISTS RecordsVisit;
CREATE TABLE RecordsVisit(
  RecordVisitId serial primary key,
  ScheduleId    bigint unsigned not null,
  UserId        bigint unsigned not null,
  foreign key (ScheduleId) references Schedule(ScheduleId),
  foreign key (UserId)   references Users(UserId)
) COMMENT = 'Записи на прием';

alter table RecordsVisit add index RecordsVisite_UserId_idx (UserId);

DROP TABLE IF EXISTS UsersVisits;
CREATE TABLE UsersVisits(
  VisitId      serial primary key,
  UserId       bigint unsigned not null,
  DateVisit    date not null comment 'Дата приема',
  DoctorId     bigint unsigned not null,
  Complaints   Text comment 'Жалобы',
  DiagnosId    bigint unsigned not null comment 'Диагноз',
  Appointment  Text comment 'Назначение',
  ClinicId     bigint unsigned not null,
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  foreign key (UserId)   references Users(UserId),
  foreign key (DoctorId) references Doctors(DoctorId),
  foreign key (ClinicId) references Clinics(ClinicId)
) COMMENT = 'Прием пациента';

alter table UsersVisits add index UsersVisits_DateVisit_idx (DateVisit);
alter table UsersVisits add index UsersVisits_Doctors_idx (DoctorId);


