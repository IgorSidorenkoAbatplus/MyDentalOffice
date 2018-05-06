--База данных "Система учета клиентов в стоматологическом кабинете"

CREATE DATABASE MyDentalOffice_3
ON PRIMARY 
(NAME = MyDentalOffice_3,
FILENAME = 'C:\DB_SQL\MyDentalOffice_3\MyDentalOffice_3.mdf',
SIZE = 5120KB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1024)
LOG ON 
(NAME = MyDentalOffice_3_log,
FILENAME = 'C:\DB_SQL\MyDentalOffice_3\MyDentalOffice_3.ldf',
SIZE = 2048KB,
MAXSIZE = 128GB,
FILEGROWTH = 10%)
GO
--------------------------------------------------------------------------------------------
USE MyDentalOffice_3
GO
--------------------------------------------------------------------------------------------
CREATE TABLE PRTime --Таблица времени назначения приема пациентов
(ReceiptTime time(0) NOT NULL PRIMARY KEY, -- временя назначенного приема
TimeNumber varchar(2)  NULL, --порядковый номер времени
)
GO

--CREATE TABLE Organizations
--(OrganizationName varchar(64) NOT NULL PRIMARY KEY, --Наименование организации
--OrganizationAddress varchar(128)  NULL , --Адрес организации
--LegalAddress varchar(128) NULL, --Юридический адрес регистрации организации
--OrganizationsPhone numeric (16, 0)  NULL 
--)
--GO
CREATE TABLE Employees  --Таблица Сотрудники
(OrganizationName varchar(64)  NULL,  --Наименование организации
--MainAducation varchar (64) NULL, -- Основное образование сотрудника
--AdditionalAducation varchar (64) NULL, -- Дополнительное образование сотрудника
--TrainingCourses varchar (64) NULL, -- Курсы повышения квалификации сотрудника
Position varchar (64) NULL, -- Должность сотрудника
QualificationCategory varchar (16) NULL, -- Квалификационная категория сотрудника
WorkExpirience date NULL DEFAULT GETDATE(), --Стаж работы(с какого года)
EmployeeName varchar(32) NULL, --Имя сотрудника
EmployeePatronymic varchar(32) NULL, -- Отчество сотрудника
FullEmployeeName varchar(32) NULL, --Фамилия сотрудника
EmployeePhone numeric(16, 0)  NULL,   --Телефон сотрудника
EmployeeCode varchar(32) NOT NULL PRIMARY KEY, --Код сотрудника в формате: ТелефонФамилия - как логин для  авторизации
EmployeePassCode varchar(16) NOT NULL, --пароль для авторизации
PassportDate varchar(512) NULL, --паспортные данные
--CONSTRAINT FK_Employees_Organizations FOREIGN KEY (OrganizationName)
--REFERENCES  Organizations(OrganizationName)
--ON UPDATE CASCADE
) 
GO
CREATE TABLE HealingProcedures --Таблица Процедуры
(
ProcedureName varchar(64) NOT NULL PRIMARY KEY,  --Наименование процедуры
ProcedureDescription varchar(512) NULL -- Описание процедуры
)
GO
--CREATE TABLE Diseases  --Таблица Заболевания
--(DiseaseCode varchar(32) NOT NULL PRIMARY KEY, --Код заболевания
--DiseaseName varchar(32) NOT NULL, --Наименование заболевания
--DiseaseDescription varchar(1024) NULL --Описание заболевания
--)
--GO
CREATE TABLE Patients --Таблица Пациенты
(PatientName varchar(32) NULL, --Имя пациента
PatientPatronymic varchar(32) NULL, -- Отчество пациента
FullPatientName varchar(32)  NULL, --Фамилия пациента
PatientPhone numeric(16, 0)  NULL, --Телефон пациента
PatientCode varchar(32) NOT NULL PRIMARY KEY, --Код пациента в формате: ТелефонФамилия без пробелов и спецсимволов
PatientAddress varchar(128) NULL, --Адрес пациента
PatientAge date NULL DEFAULT GETDATE()  --Возраст пациента(с какого года)
)
GO
CREATE TABLE PatientReceipts   --таблица Расписание приема пациентов
(
EmployeeCode varchar(32) NOT NULL,  --Код сотрудника
ReceiptDate date NOT NULL DEFAULT GETDATE(), --Дата приема
ReceiptTime time(0) NOT NULL, --Время приема
PatientCode varchar(32)  NULL, --код пациента
DiseaseCode varchar(64) NULL, --Заболевание
ProcedureName varchar(64) NULL, --Наименование процедуры
Note varchar(512) NULL, --Примечание
PRIMARY KEY ( --составной первичный ключ
EmployeeCode ASC, --по коду сотрудника
ReceiptDate ASC,  --по дате приема
ReceiptTime ASC), --по времени приема
CONSTRAINT FK_PatientReceipts_PRTime FOREIGN KEY (ReceiptTime)
REFERENCES PRTime(ReceiptTime)
ON UPDATE CASCADE,
CONSTRAINT FK_PatientReceipts_Patients FOREIGN KEY (PatientCode)
REFERENCES Patients(PatientCode)
ON UPDATE CASCADE,
CONSTRAINT FK_PatientReceipts_Employees FOREIGN KEY (EmployeeCode)
REFERENCES Employees(EmployeeCode)
ON UPDATE CASCADE,
--CONSTRAINT FK_PatientReceipts_Diseases FOREIGN KEY (DiseaseCode)
--REFERENCES Diseases(DiseaseCode)
--ON UPDATE CASCADE,
CONSTRAINT FK_PatientReceipts_HealingProcedures FOREIGN KEY (ProcedureName)
REFERENCES HealingProcedures(ProcedureName)
ON UPDATE CASCADE
)
SET DATEFORMAT dmy
GO
--------------------------------------------------------------------------------------------
CREATE INDEX IX_FullEmployeeName_Employees ON Employees(FullEmployeeName)
CREATE INDEX IX_FullPatientName_Patients ON Patients(FullPatientName)
--CREATE INDEX IX_PatientCode_Patients ON Patients(PatientCode)
--CREATE INDEX IX_ProcedureName_HealingProcedures ON HealingProcedures(ProcedureName)
--CREATE UNIQUE INDEX UIX_DiseaseName_Diseases ON Diseases(DiseaseName)
CREATE INDEX IX_ReceiptDate_PatientReceipts ON PatientReceipts(ReceiptDate)
CREATE INDEX IX_EmployeeCode_PatientReceipts ON PatientReceipts(EmployeeCode)
CREATE INDEX IX_PatientCode_PatientReceipts ON PatientReceipts(PatientCode)
GO
--------------------------------------------------------------------------------------------
INSERT INTO PRTime VALUES
(N'08:00', 1),(N'08:30', 2),(N'09:00', 3), (N'09:30', 4),
(N'10:00', 5),(N'10:30', 6),(N'11:00', 7), (N'11:30', 8),
(N'12:00', 9),(N'12:30', 10),(N'13:00',11), (N'13:30', 12),
(N'14:00', 13),(N'14:30', 14),(N'15:00', 15), (N'15:30', 16),
(N'16:00', 17),(N'16:30', 18),(N'17:00', 19), (N'17:30', 20),
(N'18:00', 21),(N'18:30', 22),(N'19:00', 23), (N'19:30', 24),
(N'20:00', 25),(N'20:30', 26),(N'21:00', 27), (N'21:30', 28)
GO
SELECT * FROM PRTime
GO

--------------------------------------------------------------------------------------------
/*INSERT INTO Organizations
VALUES
(N'ВиталиМед', '220093, Республика Беларусь, г.Минск, ул.Ольшевского, .57 ', N'', 80296964706), 
(N'Дента смайл', N'РБ, г.Минск, ул.Первомайская, 17', N'', 375172943543)
GO
SELECT * FROM Organizations
GO*/
--------------------------------------------------------------------------------------------
 INSERT INTO Employees VALUES 
 
(N'ВиталиМед',  N'Стоматолог-ортопед', N'1',NULL ,N'Виталий',N'Иванович', N'Кракасевич',375296222222, N'375296222222Кракасевич',  N'222222',  N''),
(N'ВиталиМед', N'Врач-стоматолог', N'1',NULL,N'Дмитрий',N'Брониславович', N'Сушкевич',375296333333, N'375296333333Сушкевич',  N'333333',  N''),		
(N'ВиталиМед', N'Стоматолог-терапевт', N'1',NULL,N'Ирина',N'Викторовна', N'Задора',375296444444, N'375296444444Задора',  N'444444',  N''),		
(N'ВиталиМед', N'Стоматолог-терапевт', N'1',NULL,N'Надежда',N'Степановна', N'Банделикова',375296555555, N'375296555555Банделикова',  N'555555',  N'')		
GO
SELECT * FROM Employees
WHERE OrganizationName = 'ВиталиМед'
GO
--------------------------------------------------------------------------------------------
 INSERT INTO HealingProcedures
VALUES (N' ', N' '),
(N'Запись на прием', N'Запись на прием'),
(N'Профилактический осмотр', N'Профилактический осмотр'),(N'Отбеливание', N'Отбеливание'),
(N'Процедура air flow', N'Процедура air flow'),( N'Фотополимерная пломба', N'Фотополимерная пломба'),
(N'Лечение кариеса', N'Лечение кариеса'),(N'Лечение пульпита', N'Лечение пульпита'),
(N'Лечение абсцесса', N'Лечение абсцесса'),(N'Лечение периодонтита', N'Лечение периодонтита'),

(N'Винир', N'Винир'),( N'Профессиональная гигиена полости рта', N'Профессиональная гигиена полости рта'),
(N'Пломбирование канала зуба', N'Пломбирование канала зуба'),( N'Адгезивный мостовидный протез', N'Адгезивный мостовидный протез'),
(N'Литая коронка', N'Литая коронка'),( N'Металлокерамическая коронка', N'Металлокерамическая коронка'),
(N'Съемный протез', N'Съемный протез'),( N'Частично-съемный пластинчатый протез', N'Частично-съемный пластинчатый протез'),
(N'Пластиковая коронка', N'Пластиковая коронка'),( N'Культевая вкладка', N'Культевая вкладка'),
(N'Швенкригель', N'Швенкригель'),( N'Нейлоновый съемный протез', N'Нейлоновый съемный протез'),
(N'Ацеталовый съемный протез', N'Ацеталовый съемный протез'),( N'Бюгельный протез на аттачментах', N'Бюгельный протез на аттачментах'),
(N'Безметалловая керамическая коронка', N'Безметалловая керамическая коронка')
	   GO
SELECT * FROM HealingProcedures
GO
--------------------------------------------------------------------------------------------
 --INSERT INTO Diseases
--VALUES (N'123', N'Жалобы общего характера', N'Жалобы пациента на неприятные ощущения во рту при приеме пищи'),
--       (N'124', N'Потемнение зубов', N'Непрозрачная зубная эмаль'),
 --      (N'125', N'Кариес', N'Заражение кариесом зуба'),(N'126', N'Пульпит', N'Поражение зубной ткани с воспалением нерва')
--	   GO
--SELECT * FROM Diseases
--GO
--------------------------------------------------------------------------------------------
 INSERT INTO Patients
VALUES 
(N'Петр',N'Тимофеевич',N'Семенов', N'375293423035', N'375293423035Семенов',  N'Курск','01.01.1977'),
(N'Сергей',N'Михайлович', N'Жилинговский', N'375293123032', N'375293123032Жилинговский', N'Минск','02.02.1983'),
(N'Марат',N'Витальевич',N'Карский',N'375293123031', N'375293123031Карский', N'Держинск','11.11.1965'),
( N'Илья',N'Федорович',N'Корсаков', N'375296123030', N'375296123030Корсаков', N'Могилев','03.05.1990'),
(N'Станислав',N'Вацлавович',N'Бжегож', N'375296123035',  N'375296123035Бжегож', N'Белосток','07.10.1960')
GO
SELECT * FROM Patients
GO
--------------------------------------------------------------------------------------------
SET DATEFORMAT dmy
GO
/* INSERT INTO PatientReceipts
VALUES 
	   ( N'375296222222Кракасевич', '16.11.2015', '08:30', N'375293123032Жилинговский', N'Слом зуба', N'Безметалловая керамическая коронка',N'31 абсцесс'),
	   (  N'375296222222Кракасевич', '21.11.2017', '11:30',N'375293123032Жилинговский',  N'Кариес', N'Лечение кариеса',N'31 кариес, 33 потемнение'),
	   (  N'375296222222Кракасевич', '20.11.2017', '19:30',N'375293123032Жилинговский',  N'Кариес', N'Лечение кариеса',N'21 кариес'),
	   (  N'375296333333Сушкевич', '29.11.2017', '20:00',N'375293123032Жилинговский',  N'Кариес', N'Лечение кариеса',N'11 кариес'),
	   ( N'375296333333Сушкевич', '24.12.2017', '12:30', N'375293123031Карский', N'Воспаление десны', N'Профессиональная гигиена полости рта', N'профилактика и гигиена ротовой полости'),
	   (  N'375296333333Сушкевич', '25.12.2017', '16:30', N'375293123031Карский', N'Воспаление десны', N'Профессиональная гигиена полости рта', N'чистка ротовой полости'),
	   ( N'375296444444Задора', '15.09.2017', '17:30',N'375296123030Корсаков',  N'Кариес', N'Пломбирование канала зуба', N'11, 21 потемнение эмали и кариес'),
	   ( N'375296444444Задора', '16.09.2017', '09:30',N'375296123030Корсаков',  N'Кариес', N'Пломбирование канала зуба', N'31, 41 кариес'),
	   ( N'375296444444Задора', '16.11.2015', '16:00', N'375296123035Бжегож', N'Абсцесс', N'Лечение абсцесса', N'27 кариес, 37 пульпит'),
	   ( N'375296555555Банделикова', '16.11.2015', '15:30',N'375296123035Бжегож',  N'Разрушение зуба', N'Литая коронка', N'38 пульпит'),
	   ( N'375296555555Банделикова', '17.11.2015', '14:00',N'375296123035Бжегож',  N'Разрушение зуба', N'Литая коронка', N'38 пульпит'),
	   ( N'375296555555Банделикова', '18.11.2015', '11:00', N'375296123035Бжегож', N'Потемнение эмали', N'Процедура air flow', N'чистка и отбеливание air flow')
GO
SELECT * FROM PatientReceipts
ORDER BY ReceiptDate
GO*/
------------------------------------------------------------------------------------------
---------------------------------5. Создание представления (по аналогии с пп.4.6-4.8)
	--SELECT * FROM PatientReceipts
	--SELECT * FROM Employees
	--SELECT * FROM Diseases
	--SELECT * FROM HealingProcedures
	--SELECT * FROM Patients
 
CREATE VIEW PatientReceipts_VIEW1 WITH SCHEMABINDING AS 
SELECT Pat.PatientPhone, E.EmployeeCode,E.FullEmployeeName, P.ReceiptDate, P.ReceiptTime, P.DiseaseCode, H.ProcedureName
FROM dbo.PatientReceipts AS P INNER JOIN dbo.Employees AS E ON P.EmployeeCode = E.EmployeeCode
					-- INNER JOIN dbo.Diseases AS D ON  P.DiseaseCode = D.DiseaseCode
					 INNER JOIN dbo.HealingProcedures AS H ON P.ProcedureName = H.ProcedureName
					 INNER JOIN dbo.Patients AS Pat ON P.PatientCode = Pat.PatientCode
GO
CREATE UNIQUE CLUSTERED INDEX IDX_V1   
    ON PatientReceipts_VIEW1 (EmployeeCode,ReceiptDate, ReceiptTime)
	GO
/*SELECT * FROM PatientReceipts_VIEW1       --проверка полученного результата
ORDER BY PatientReceipts_VIEW1.ProcedureName  --,PatientReceipts_VIEW1.EmployeeCode  --с сортировкой(если нужно)
GO*/
--------------                         --изменение представления для подсчета того, сколько и каких процедур
ALTER VIEW PatientReceipts_VIEW1 AS    -- провел каждый из сотрудников   
SELECT E.FullEmployeeName, H.ProcedureName,COUNT(H.ProcedureName) AS ProceduresQuantity  
FROM dbo.PatientReceipts AS P INNER JOIN dbo.Employees AS E ON P.EmployeeCode = E.EmployeeCode
					 --INNER JOIN dbo.Diseases AS D ON  P.DiseaseCode = D.DiseaseCode
					 INNER JOIN dbo.HealingProcedures AS H ON P.ProcedureName = H.ProcedureName
					 INNER JOIN dbo.Patients AS Pat ON P.PatientCode = Pat.PatientCode
GROUP BY E.FullEmployeeName, H.ProcedureName
GO
SELECT * FROM PatientReceipts_VIEW1         --проверка полученного результата
ORDER BY PatientReceipts_VIEW1.FullEmployeeName, PatientReceipts_VIEW1.ProcedureName  --с сортировкой
GO

/*DROP VIEW PatientReceipts_VIEW1           --удаление уже ненужного представления из бд
GO */

---------------------------------7.Хранимые процедуры, функции------------------------------------------------------

 --------------------------------Основные хранимые процедуры----------------------------------------------------------
  ------------Выборка расписания по FullEmployeeName врача и/или дате приема
  ------------Хран. процедура - применение: посмотреть расписание врача/всех врачей вообще либо на конкретную дату
 /*CREATE PROC pr_Schedule_@FEName_@RDate_first
 @FEName varchar (64),
 @RDate date
 AS IF @FEName IS NOT NULL 
    BEGIN
	IF @RDate IS NOT NULL
    SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
    PR.ReceiptTime, PR.DiseaseCode, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
    WHERE E.FullEmployeeName = @FEName AND PR.ReceiptDate = @RDate
	ELSE 
	SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
    PR.ReceiptTime, PR.DiseaseCode, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
    WHERE E.FullEmployeeName = @FEName
	END
      ELSE IF  @FEName IS NULL 
	  BEGIN
	  IF @RDate IS NOT NULL 
	  SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
      PR.ReceiptTime, PR.DiseaseCode, PR.Note  
      FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
      WHERE PR.ReceiptDate = @RDate
	  ELSE 
	  SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
      PR.ReceiptTime,PR.DiseaseCode, PR.Note  
      FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode 
	  END						    
 GO

EXEC pr_Schedule_@FEName_@RDate_first @FEName ='Сушкевич Д.Б.', @RDate = N'24.12.2017'
GO  --Проверка: вызвать все приемы врача Стратулат Трофим Иосифович по дате 16.11.2015

   EXEC pr_Schedule_@FEName_@RDate_first @FEName ='Сушкевич Д.Б.', @RDate = NULL
   GO  --Проверка: вызвать все приемы врача Стратулат Трофим Иосифович (на все даты)

    EXEC pr_Schedule_@FEName_@RDate_first @FEName =NULL, @RDate =N'24.12.2017'
    GO  --Проверка: вызвать все приемы всех врачей по дате 16.11.2015

	EXEC pr_Schedule_@FEName_@RDate_first @FEName =NULL, @RDate =NULL
    GO  --Проверка: вызвать все приемы всех врачей (на все даты)
*/
 /*DROP PROCEDURE pr_Schedule_@FEName_@RDate_first */

 
  
  ------------------------------CODE------------------------------------------------
  ------------Хран. процедура - применение: посмотреть расписание врача/всех врачей вообще либо на конкретную дату
/* CREATE PROC pr_Schedule_@FECode_@RDate_first_CODE
 @FECode varchar (32),
 @RDate date
 AS IF @FECode IS NOT NULL 
    BEGIN
	IF @RDate IS NOT NULL
    SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
    PR.ReceiptTime, PR.DiseaseCode, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
    WHERE E.EmployeeCode = @FECode AND PR.ReceiptDate = @RDate
	ELSE 
	SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
    PR.ReceiptTime, PR.DiseaseCode, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
    WHERE E.EmployeeCode = @FECode
	END
      ELSE IF  @FECode IS NULL 
	  BEGIN
	  IF @RDate IS NOT NULL 
	  SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
      PR.ReceiptTime, PR.DiseaseCode, PR.Note  
      FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
      WHERE PR.ReceiptDate = @RDate
	  ELSE 
	  SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
      PR.ReceiptTime,PR.DiseaseCode, PR.Note  
      FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode 
	  END						    
 GO

EXEC pr_Schedule_@FECode_@RDate_first_CODE @FECode ='375296333333Сушкевич', @RDate = N'24.12.2017'
GO  --Проверка: вызвать все приемы врача Стратулат Трофим Иосифович по дате 16.11.2015

   EXEC pr_Schedule_@FECode_@RDate_first_CODE @FECode ='375296333333Сушкевич', @RDate = NULL
   GO  --Проверка: вызвать все приемы врача Стратулат Трофим Иосифович (на все даты)

    EXEC pr_Schedule_@FECode_@RDate_first_CODE @FECode =NULL, @RDate =N'24.12.2017'
    GO  --Проверка: вызвать все приемы всех врачей по дате 16.11.2015

	EXEC pr_Schedule_@FECode_@RDate_first_CODE @FECode =NULL, @RDate =NULL
    GO  --Проверка: вызвать все приемы всех врачей (на все даты)
    */
 /*DROP PROCEDURE pr_Schedule_@FEName_@RDate_first */


  ------------Выборка расписания по телефону PatientPhone пациента и/или дате приема
  ------------Хран. процедура - применение: посмотреть расписание посещений пациента/всех пациентов вообще либо на конкретную дату
/* CREATE PROC pr_Schedule_@PPhone_@RDate_first
@PPhone numeric (16, 0),
 @RDate date
 AS IF @PPhone IS NOT NULL 
    BEGIN
	IF @RDate IS NOT NULL
    SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
    PR.ReceiptTime,PR.DiseaseCode, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
    WHERE P.PatientPhone = @PPhone AND PR.ReceiptDate = @RDate
	ELSE 
	SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
    PR.ReceiptTime, PR.DiseaseCode, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
    WHERE P.PatientPhone = @PPhone
	END	
    ELSE  IF  @PPhone IS NULL
	  BEGIN
	  IF @RDate IS NOT NULL
	  SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
      PR.ReceiptTime,PR.DiseaseCode,PR.Note  
      FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
      WHERE PR.ReceiptDate = @RDate

	  ELSE 
	  SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
      PR.ReceiptTime, PR.DiseaseCode, PR.Note  
      FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							--INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode  
	  END 
 GO

EXEC pr_Schedule_@PPhone_@RDate_first @PPhone = '375293123031', @RDate = '24.12.2017'
GO  --Проверка: вызвать все посещения пациента тел.375296123035 по дате 16.11.2015

   EXEC pr_Schedule_@PPhone_@RDate_first @PPhone ='375293123031', @RDate = NULL
   GO  --Проверка: посещения пациента тел.375296123035 (на все даты)

    EXEC pr_Schedule_@PPhone_@RDate_first @PPhone =NULL, @RDate ='24.12.2017'
    GO  --Проверка: вызвать расписание посещений вссех пациентов по дате 16.11.2015

	EXEC pr_Schedule_@PPhone_@RDate_first @PPhone =NULL, @RDate =NULL
    GO  --Проверка: вызвать все посещения всех пациентов (на все даты)*/
	/*DROP PROCEDURE pr_Schedule_@PPhone_@RDate_first*/

------------Должны быть: ФИО сотрудника по коду, телефон пациента, дата и время приема. 
 ------------Выборка по ReceiptDate пациента
 ------------Хран. процедура - применение: вызов приемов на определенную дату
 /*CREATE PROC pr_Schedule_@RDate_first
@RDate date
 AS 
SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
    PR.ReceiptTime, PR.DiseaseCode, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
 WHERE PR.ReceiptDate = @RDate 
 GO
 /*Проверка: вызвать историю (всех приемов) пациента с номером телефона 375293123032*/
 EXEC pr_Schedule_@RDate_first @RDate = '24.12.2017'
 GO*/
 /*DROP PROCEDURE  pr_Schedule_@RDate_first*/
----------------------------------------
----------------------------------------------------------------------------------------------------------------------
 ------------Хран. процедура - применение: посмотреть расписание врача/всех врачей вообще либо на конкретную дату
/* CREATE PROC pr_Schedule_@FECode_@RDate_second
 @FECode varchar (64),
 @RDate date
 AS IF @FECode IS NOT NULL 
    BEGIN
	IF @RDate IS NOT NULL
    SELECT E.EmployeeCode, PR.ReceiptDate, PR.ReceiptTime, P.PatientCode,
     PR.DiseaseCode, HP.ProcedureName, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
    WHERE E.EmployeeCode = @FECode AND PR.ReceiptDate = @RDate
	ELSE 
	SELECT E.EmployeeCode, PR.ReceiptDate, PR.ReceiptTime, P.PatientCode,
     PR.DiseaseCode, HP.ProcedureName, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
    WHERE E.EmployeeCode = @FECode
	END
      ELSE IF  @FECode IS NULL 
	  BEGIN
	  IF @RDate IS NOT NULL 
	  SELECT E.EmployeeCode, PR.ReceiptDate, PR.ReceiptTime, P.PatientCode,
     PR.DiseaseCode, HP.ProcedureName, PR.Note   
      FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode
      WHERE PR.ReceiptDate = @RDate
	  ELSE 
	  SELECT E.EmployeeCode, PR.ReceiptDate, PR.ReceiptTime, P.PatientCode,
     PR.DiseaseCode, HP.ProcedureName, PR.Note 
      FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
							INNER JOIN HealingProcedures HP ON PR.ProcedureName=HP.ProcedureName
							--INNER JOIN Diseases D ON PR.DiseaseCode=D.DiseaseCode 
	  END						    
 GO

EXEC pr_Schedule_@FECode_@RDate_second @FECode ='375296333333Сушкевич', @RDate = N'09.04.2018'
GO  --Проверка: вызвать все приемы врача Стратулат Трофим Иосифович по дате 16.11.2015

   EXEC pr_Schedule_@FECode_@RDate_second @FECode ='375296333333Сушкевич', @RDate = NULL
   GO  --Проверка: вызвать все приемы врача Стратулат Трофим Иосифович (на все даты)

    EXEC pr_Schedule_@FECode_@RDate_second @FECode =NULL, @RDate =N'09.04.2018'
    GO  --Проверка: вызвать все приемы всех врачей по дате 16.11.2015

	EXEC pr_Schedule_@FECode_@RDate_second @FECode =NULL, @RDate =NULL
    GO  --Проверка: вызвать все приемы всех врачей (на все даты)
	*/
 /*DROP pr_Schedule_@FECode_@RDate_second */
---------------------------------------------------------------------------------------------------------------------
-----------Хранимая процедура: удалить из расписания на день пустые записи старше текущей даты для конкретного специалиста------------------------------
 /*CREATE PROC pr_@FECode_DELETE_FROM_Schedule_EMPTYSTRINGS
@FECode varchar (32),
@RDate date,
@PCode varchar(32)
 AS 
  DELETE FROM PatientReceipts
   WHERE  EmployeeCode=@FECode AND ReceiptDate=@RDate AND PatientCode=@PCode
 GO*/
/*EXEC pr_@FECode_DELETE_FROM_Schedule_EMPTYSTRINGS @FECode ='375296333333Сушкевич', @RDate ='16.04.2018', @PCode=NULL
  GO  */
 /*DROP PROCEDURE  pr_@FECode_DELETE_FROM_Schedule_EMPTYSTRINGS */
----------------------------------------------------------------------------------------------------------------------
 ---------------------------------------Действительные для проекта процедуры-----------------------------------------
------------Должны быть: ФИО сотрудника по коду, телефон пациента, дата и время приема. 
 ------------Выборка по PatientPhone пациента
 ------------Хран. процедура - применение: вызов полной истории посещений пациента по его телефону
 CREATE PROC pr_Schedule_@PPhone_first
 @PPhone numeric (16, 0)
 AS 
SELECT P.FullPatientName,P.PatientPhone,E.FullEmployeeName, PR.ReceiptDate, PR.ReceiptTime,PR.DiseaseCode, PR.Note 
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
 WHERE P.PatientPhone = @PPhone
 GO
 /*Проверка: вызвать историю (всех приемов) пациента с номером телефона 375296123035*/
 EXEC pr_Schedule_@PPhone_first @PPhone ='375296123035'
 GO
  /*DROP PROCEDURE  pr_Schedule_@PPhone_first */

 -----------------------------------------------------------------------------------------------------------------
 ------------Выборка по FullPatientName пациента
 ------------Хран. процедура - применение: вызов полной истории посещений пациента по его фамилии
 CREATE PROC pr_Schedule_@FPatientName_first
 @FPatientName varchar (32)
 AS 
SELECT P.FullPatientName,P.PatientPhone,E.FullEmployeeName, PR.ReceiptDate, PR.ReceiptTime,PR.DiseaseCode, PR.Note 
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
 WHERE P.FullPatientName = @FPatientName
 GO
 /*Проверка: вызвать историю (всех приемов) пациента с номером телефона 375296123035*/
 EXEC pr_Schedule_@FPatientName_first @FPatientName ='Бжегож'
 GO
  /*DROP PROCEDURE  pr_Schedule_@FPatientName_first */

------------------------------------------------------------------------------------------------------------------------------

 ---------------Хранимая процедура: вставить расписание на день по коду сотрудника и дате приема------------------------------
 /*-----------------------------------------------------------------------------------------------------------------*/
 CREATE PROC pr_INSERT_Schedule_@FECode_@RDate_first
@FECode varchar (32),
 @RDate date
 AS 
  INSERT INTO PatientReceipts (PatientReceipts.EmployeeCode, PatientReceipts.ReceiptDate, PatientReceipts.ReceiptTime) 
   VALUES 
   (@FECode, @RDate,'08:00'),( @FECode, @RDate,'08:30'),
 ( @FECode, @RDate,'09:00'),(@FECode, @RDate,'09:30'),
 ( @FECode, @RDate,'10:00'),( @FECode, @RDate,'10:30'),
 (@FECode, @RDate,'11:00'),( @FECode, @RDate,'11:30'),
 ( @FECode, @RDate,'12:00'),(@FECode, @RDate,'12:30'),
 ( @FECode, @RDate,'13:00'),( @FECode, @RDate,'13:30'),
 ( @FECode, @RDate,'14:00'),( @FECode, @RDate,'14:30'),
 ( @FECode, @RDate,'15:00'),( @FECode, @RDate,'15:30'),
 (@FECode, @RDate,'16:00'),( @FECode, @RDate,'16:30'),
 ( @FECode, @RDate,'17:00'),( @FECode, @RDate,'17:30'),
 (@FECode, @RDate,'18:00'),( @FECode, @RDate,'18:30'),
 ( @FECode, @RDate,'19:00'),( @FECode, @RDate,'19:30'),
 ( @FECode, @RDate,'20:00'),( @FECode, @RDate,'20:30'),
 ( @FECode, @RDate,'21:00'),( @FECode, @RDate,'21:30')
 GO
 /*
EXEC pr_INSERT_Schedule_@FECode_@RDate_first @FECode ='375296333333Сушкевич', @RDate = '17.04.2018' --@FECode ='375296555555Банделикова', @RDate = '09.04.2018'
    GO */
/*SELECT * FROM PatientReceipts WHERE PatientReceipts.ReceiptDate = '09.04.2018';
DELETE FROM PatientReceipts; where PatientReceipts.PatientCode = NULL; OR ProcedureName = NULL;*/
/*DROP PROCEDURE  pr_INSERT_Schedule_@FECode_@RDate_first 
DELETE FROM Patients;*/

----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
        