Create database [TOE_DB]
go
SET DATEFORMAT dmy;  
GO 
PRINT N'Создаем календарь, за 2020 год, исключая праздничные и выходные дни'
PRINT N'Подсчитываю количество рабочих дней'
-- total 246 of working days
If exists (select * from sysobjects where name = 'calendarOf2020') drop table calendarOf2020;
go
USE [TOE_DB];  
Create table [TOE_DB].[dbo].calendarOf2020
(
ID_DAY int PRIMARY KEY ,
daysofyear date,
workday int
)
go
USE [TOE_DB];  
DECLARE @MyVar int;
SET @MyVar = 2020
insert into [TOE_DB].[dbo].calendarOf2020
(ID_DAY,daysofyear,workday)
select 
	ID_DAY
	,dateofyear daysofyear
	,count(ID_DAY) over (Partition by MONTH(dateofyear)) workday
from  
	(
	select 
		(a.ID-1)*49+(c.ID-1)*7+b.ID ID_DAY
		,dateadd(DAY,(a.ID-1)*49+(c.ID-1)*7+b.ID,CONCAT('01.01.', CAST(@MyVar as nchar))) [dateofyear]
		from 
			(select 1 ID
			union all
			select 2 ID
			union all
			select 3 ID
			union all
			select 4 ID
			union all
			select 5 ID
			union all
			select 6 ID
			union all
			select 7 ID
			) a, 
			(select 1 ID
			union all
			select 2 ID
			union all
			select 3 ID
			union all
			select 4 ID
			union all
			select 5 ID
			union all
			select 6 ID
			union all
			select 7 ID
			) b, 
			(select 1 ID
			union all
			select 2 ID
			union all
			select 3 ID
			union all
			select 4 ID
			union all
			select 5 ID
			union all
			select 6 ID
			union all
			select 7 ID
			) c 
		where 
			datepart(dw, dateadd(DAY,(a.ID-1)*49+(c.ID-1)*7+b.ID,CONCAT('01.01.', CAST(@MyVar as nchar)))) < 6
union all
	select 
			343+(c.ID-1)*7+b.ID
			,dateadd(DAY,343+(c.ID-1)*7+b.ID,CONCAT('01.01.', CAST(@MyVar as nchar))) [dateofyear]
		from 
			(select 1 ID
			union all
			select 2 ID
			union all
			select 3 ID
			union all
			select 4 ID
			union all
			select 5 ID
			union all
			select 6 ID
			union all
			select 7 ID
			) b, 
			(select 1 ID
			union all
			select 2 ID
			union all
			select 3 ID
			union all
			select 4 ID
			union all
			select 5 ID
			union all
			select 6 ID
			union all
			select 7 ID
			) c 
		
	where 
		(datepart(dw, dateadd(DAY,343+(c.ID-1)*7+b.ID,CONCAT('01.01.', CAST(@MyVar as nchar)))) < 6) 
	and
		(dateadd(DAY,343+(c.ID-1)*7+b.ID,CONCAT('01.01.', CAST(@MyVar as nchar))) < dateadd(year,1,CONCAT('01.01.', CAST(@MyVar as nchar))))
	) TableDaysYear
where TableDaysYear.dateofyear not in (select '01.01.2020'
									   union all
									   select '02.01.2020'
									   union all
									   select '03.01.2020'
									   union all
									   select '06.01.2020'
									   union all
									   select '07.01.2020'
									   union all
									   select '08.01.2020'
									   union all
									   select '24.02.2020'
									   union all
									   select '09.03.2020'
									   union all
									   select '01.05.2020'
									   union all
									   select '04.05.2020'
									   union all
									   select '05.05.2020'
									   union all
									   select '11.05.2020'
									   union all
									   select '12.06.2020'
									   union all
									   select '24.06.2020'
									   union all
									   select '01.06.2020'
									   union all
									   select '04.11.2020'
									   )

GO
USE [TOE_DB];  
If exists (select * from sysobjects where name = 'Employes') drop table Employes;
USE [TOE_DB];  
CREATE TABLE [dbo].[Employes](
	[ID_TAB] [int] PRIMARY KEY,
	[FIO] [nchar](20) NULL,
	[BIRTHDAY] [Date]
) ON [PRIMARY]
GO
USE [TOE_DB];  
INSERT INTO Employes VALUES(1,'Иванов И.И.','12.01.1985')
INSERT INTO Employes VALUES(2,'Петров П.П.','12.01.1985')
INSERT INTO Employes VALUES(3,'Сидоров К.Н.','12.01.1985')
INSERT INTO Employes VALUES(4,'Крутов В.Е.','12.01.1985')
INSERT INTO Employes VALUES(5,'Пирогов А.Е.','12.01.1985')

Print N'Таблица сотрудников [Employes] создана и заполнена 5 записей'

If exists (select * from sysobjects where name = 'Departments') drop table Departments;
CREATE TABLE [dbo].[Departments](
	[ID_DEPT] [int] PRIMARY KEY,
	[NAME_OF_DEPT] [nchar](20) NULL
) ON [PRIMARY]
GO
USE [TOE_DB];  
INSERT INTO Departments VALUES(1,'Подразделение 1')
INSERT INTO Departments VALUES(2,'Подразделение 2')
INSERT INTO Departments  VALUES(3,'Подразделение 3')

Print N'Таблица отделов [Departments] создана и заполнена 3 записями'

GO
USE [TOE_DB];  
If exists (select * from sysobjects where name = 'Positions') drop table Positions;

CREATE TABLE [dbo].[Positions](
	[ID_TAB] [int] NULL,
	[Position] [nchar](20) NULL
) ON [PRIMARY]
GO
USE [TOE_DB];  

insert into positions values(	1	,'Слесарь')
insert into positions values(	2	,'Программист')
insert into positions values(	3	,'Дворник')
insert into positions values(	4	,'Бухгалтер')
insert into positions values(	5	,'Секретарь')
Print N'Таблица должностей [Positions] создана и заполнена 5 записями'

GO
USE [TOE_DB];  

If exists (select * from sysobjects where name = 'Jobs') drop table Jobs;

Create table [dbo].Jobs
(
ID_DAY int
,ID_TAB int
,ID_DEPT int,
)
go
USE [TOE_DB];  
insert into [dbo].jobs
select * 
from 
	(select 
		ID_DAY,ID_TAB
		,(2*(ABS(CHECKSUM(NewId())) % 2) +  ABS(CHECKSUM(NewId())) % 2) ID_DEPT
	from calendarOf2020, employes
	) tmp
where ID_DEPT <> 0
GO
USE [TOE_DB];  
Print N'Сгенерировали таблицу [Jobs] где указано в каком оделе работал сотрудник '
GO
USE [TOE_DB];  
If exists (select * from sysobjects where name = 'ReportDates') drop table ReportDates;
GO
USE [TOE_DB];  
CREATE TABLE [dbo].[ReportDates](
	[Startdate] [date] NULL,
	[Enddate] [date] NULL
) ON [PRIMARY]
GO
USE [TOE_DB];  

insert into reportdates Values('01.10.2020','30.10.2020')
GO
USE [TOE_DB];  
Print N'Таблица [ReportDates] для указания начальной и конечной дат для отчета'
GO
USE [TOE_DB];  
If exists (select * from sysobjects where name = 'salarys') drop table [salarys];
GO  
USE [TOE_DB];  
Create table salarys
(
  ID_TAB int
  ,ID_Dept int 
  ,salary int
)
GO
USE [TOE_DB];  
insert into salarys values(	1	,	1	,	28622	)
insert into salarys values(	2	,	1	,	42614	)
insert into salarys values(	3	,	1	,	27940	)
insert into salarys values(	4	,	1	,	24970	)
insert into salarys values(	5	,	1	,	43758	)
insert into salarys values(	1	,	2	,	35464	)
insert into salarys values(	2	,	2	,	34386	)
insert into salarys values(	3	,	2	,	42306	)
insert into salarys values(	4	,	2	,	37334	)
insert into salarys values(	5	,	2	,	26400	)
insert into salarys values(	1	,	3	,	31262	)
insert into salarys values(	2	,	3	,	13310	)
insert into salarys values(	3	,	3	,	26334	)
insert into salarys values(	4	,	3	,	16742	)
insert into salarys values(	5	,	3	,	15444	)

Print N'Таблица [Salarys] заполняем оклады по разным отделам'
GO

