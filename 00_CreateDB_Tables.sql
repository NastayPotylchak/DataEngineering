DROP DATABASE IF EXISTS MedicalCenter;
CREATE DATABASE MedicalCenter;

USE MedicalCenter;

DROP TABLE IF EXISTS Clinics;
CREATE TABLE Clinics (
  ClinicId SERIAL PRIMARY KEY,
  Title  varchar(255) COMMENT '��������',
  Adress varchar(500) unique COMMENT '�����',
  Phone  varchar(20),
  TimeWork  text COMMENT '����� ������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '���������� "�������"';

DROP TABLE IF EXISTS �ategorys;
CREATE TABLE �ategorys (
  CategoryId    int unsigned not null auto_increment unique PRIMARY KEY,
  �ategoryName  varchar(500) COMMENT '��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '���������� "��������� ������"';

DROP TABLE IF EXISTS Specializations;
CREATE TABLE Specializations (
  SpecializationId int unsigned not null auto_increment unique PRIMARY KEY,
  SpecializationName  varchar(500) COMMENT '��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '���������� "�������������"';

DROP TABLE IF EXISTS DaysWeek;
CREATE TABLE DaysWeek (
  DayId  tinyint unsigned not null unique PRIMARY KEY,
  ShortDayName char(2) COMMENT '������� ��������',
  Description varchar(100)
) COMMENT = '��� ������';

DROP TABLE IF EXISTS Genders;
CREATE TABLE Genders (
  GenderId     tinyint not null unique PRIMARY KEY,
  ShortGender  char(1) COMMENT '������� ��������',
  Description varchar(100)
) COMMENT = '���������� "���"';

DROP TABLE IF EXISTS Diagnosis;
CREATE TABLE Diagnosis (
  DiagnosId SERIAL PRIMARY KEY,
  DiagnosName  varchar(500) COMMENT '�������� ��������',
  DiagnosCode  varchar(50) COMMENT '��� ��������'
) COMMENT = '���������� "��������"';

DROP TABLE IF EXISTS Doctors;
CREATE TABLE Doctors(
  DoctorId    serial primary key,
  FirstName   varchar(50) not null comment '��� �����',
  LastName    varchar(50) not null comment '������� �����',
  MiddleName  varchar(50) not null comment '�������� �����',
  CategoryId  int unsigned not null comment '���������',
  Education   varchar(255) not null comment '�����������',
  LengthWork  tinyint unsigned not null comment '���� ������',
  SpecializationId int unsigned not null comment '�������������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  foreign key (CategoryId) references �ategorys(CategoryId),
  foreign key (SpecializationId) references Specializations(SpecializationId)
) COMMENT = '�����';

DROP TABLE IF EXISTS LinksDoctorsClinics;
CREATE TABLE LinksDoctorsClinics(
  LinkId   serial primary key,
  DoctorId bigint unsigned not null,
  ClinicId bigint unsigned not null,
  foreign key (DoctorId) references Doctors(DoctorId),
  foreign key (ClinicId) references Clinics(ClinicId)
) COMMENT = '� ����� �������� ��������� ����';

alter table LinksDoctorsClinics add index Links_Doctors_idx (DoctorId);
alter table LinksDoctorsClinics add index Links_Clinics_idx (ClinicId);

DROP TABLE IF EXISTS Users;
CREATE TABLE  Users(
  UserId serial primary key,
  FirstName   varchar(50)  not null comment '��� ��������',
  LastName    varchar(50)  not null comment '������� ��������',
  MiddleName  varchar(50)  not null comment '�������� ��������',
  Email       varchar(120) unique,
  Phone       varchar(20)  unique,
  Birthday    date         not null,
  Hometown    varchar(100),
  GenderId    tinyint not null,
  create_at   datetime default now(),
  Pass        char(40),
  foreign key (GenderId) references Genders(GenderId)
) COMMENT = '������������-��������';

DROP TABLE IF EXISTS ReviewsDoctors;
CREATE TABLE ReviewsDoctors(
	Id          serial primary key,
	ReviewsText Text comment '����� ������',
	DoctorId    bigint unsigned not null,
	UserId      bigint unsigned not null,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	foreign key (DoctorId) references Doctors(DoctorId),
	foreign key (UserId)   references Users(UserId)
) COMMENT = '������ � �����';

alter table ReviewsDoctors add index Reviews_Doctors_idx (DoctorId);

DROP TABLE IF EXISTS Schedule;
CREATE TABLE Schedule(
  ScheduleId  serial primary key,
  DateSch     date not null comment '���� ������',
  DoctorId    bigint unsigned not null,
  TimeSch     time not null comment '����� ������',
  ClinicId    bigint unsigned not null,
  Room        tinyint not null comment '�������',
  isFree      bit default 0 comment '��������(1)/������(0)',
  foreign key (DoctorId) references Doctors(DoctorId),
  foreign key (ClinicId) references Clinics(ClinicId)
) COMMENT = '���������� ������';

alter table Schedule add index Schedule_Doctors_idx (DoctorId);
alter table Schedule add index Schedule_DateSch_idx (DateSch);

DROP TABLE IF EXISTS RecordsVisit;
CREATE TABLE RecordsVisit(
  RecordVisitId serial primary key,
  ScheduleId    bigint unsigned not null,
  UserId        bigint unsigned not null,
  foreign key (ScheduleId) references Schedule(ScheduleId),
  foreign key (UserId)   references Users(UserId)
) COMMENT = '������ �� �����';

alter table RecordsVisit add index RecordsVisite_UserId_idx (UserId);

DROP TABLE IF EXISTS UsersVisits;
CREATE TABLE UsersVisits(
  VisitId      serial primary key,
  UserId       bigint unsigned not null,
  DateVisit    date not null comment '���� ������',
  DoctorId     bigint unsigned not null,
  Complaints   Text comment '������',
  DiagnosId    bigint unsigned not null comment '�������',
  Appointment  Text comment '����������',
  ClinicId     bigint unsigned not null,
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  foreign key (UserId)   references Users(UserId),
  foreign key (DoctorId) references Doctors(DoctorId),
  foreign key (ClinicId) references Clinics(ClinicId)
) COMMENT = '����� ��������';

alter table UsersVisits add index UsersVisits_DateVisit_idx (DateVisit);
alter table UsersVisits add index UsersVisits_Doctors_idx (DoctorId);


