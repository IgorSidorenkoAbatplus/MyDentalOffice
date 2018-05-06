--���� ������ "������� ����� �������� � ����������������� ��������"

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
CREATE TABLE PRTime --������� ������� ���������� ������ ���������
(ReceiptTime time(0) NOT NULL PRIMARY KEY, -- ������� ������������ ������
TimeNumber varchar(2)  NULL, --���������� ����� �������
)
GO

--CREATE TABLE Organizations
--(OrganizationName varchar(64) NOT NULL PRIMARY KEY, --������������ �����������
--OrganizationAddress varchar(128)  NULL , --����� �����������
--LegalAddress varchar(128) NULL, --����������� ����� ����������� �����������
--OrganizationsPhone numeric (16, 0)  NULL 
--)
--GO
CREATE TABLE Employees  --������� ����������
(OrganizationName varchar(64)  NULL,  --������������ �����������
--MainAducation varchar (64) NULL, -- �������� ����������� ����������
--AdditionalAducation varchar (64) NULL, -- �������������� ����������� ����������
--TrainingCourses varchar (64) NULL, -- ����� ��������� ������������ ����������
Position varchar (64) NULL, -- ��������� ����������
QualificationCategory varchar (16) NULL, -- ���������������� ��������� ����������
WorkExpirience date NULL DEFAULT GETDATE(), --���� ������(� ������ ����)
EmployeeName varchar(32) NULL, --��� ����������
EmployeePatronymic varchar(32) NULL, -- �������� ����������
FullEmployeeName varchar(32) NULL, --������� ����������
EmployeePhone numeric(16, 0)  NULL,   --������� ����������
EmployeeCode varchar(32) NOT NULL PRIMARY KEY, --��� ���������� � �������: �������������� - ��� ����� ���  �����������
EmployeePassCode varchar(16) NOT NULL, --������ ��� �����������
PassportDate varchar(512) NULL, --���������� ������
--CONSTRAINT FK_Employees_Organizations FOREIGN KEY (OrganizationName)
--REFERENCES  Organizations(OrganizationName)
--ON UPDATE CASCADE
) 
GO
CREATE TABLE HealingProcedures --������� ���������
(
ProcedureName varchar(64) NOT NULL PRIMARY KEY,  --������������ ���������
ProcedureDescription varchar(512) NULL -- �������� ���������
)
GO
--CREATE TABLE Diseases  --������� �����������
--(DiseaseCode varchar(32) NOT NULL PRIMARY KEY, --��� �����������
--DiseaseName varchar(32) NOT NULL, --������������ �����������
--DiseaseDescription varchar(1024) NULL --�������� �����������
--)
--GO
CREATE TABLE Patients --������� ��������
(PatientName varchar(32) NULL, --��� ��������
PatientPatronymic varchar(32) NULL, -- �������� ��������
FullPatientName varchar(32)  NULL, --������� ��������
PatientPhone numeric(16, 0)  NULL, --������� ��������
PatientCode varchar(32) NOT NULL PRIMARY KEY, --��� �������� � �������: �������������� ��� �������� � ������������
PatientAddress varchar(128) NULL, --����� ��������
PatientAge date NULL DEFAULT GETDATE()  --������� ��������(� ������ ����)
)
GO
CREATE TABLE PatientReceipts   --������� ���������� ������ ���������
(
EmployeeCode varchar(32) NOT NULL,  --��� ����������
ReceiptDate date NOT NULL DEFAULT GETDATE(), --���� ������
ReceiptTime time(0) NOT NULL, --����� ������
PatientCode varchar(32)  NULL, --��� ��������
DiseaseCode varchar(64) NULL, --�����������
ProcedureName varchar(64) NULL, --������������ ���������
Note varchar(512) NULL, --����������
PRIMARY KEY ( --��������� ��������� ����
EmployeeCode ASC, --�� ���� ����������
ReceiptDate ASC,  --�� ���� ������
ReceiptTime ASC), --�� ������� ������
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
(N'���������', '220093, ���������� ��������, �.�����, ��.�����������, .57 ', N'', 80296964706), 
(N'����� �����', N'��, �.�����, ��.������������, 17', N'', 375172943543)
GO
SELECT * FROM Organizations
GO*/
--------------------------------------------------------------------------------------------
 INSERT INTO Employees VALUES 
 
(N'���������',  N'����������-�������', N'1',NULL ,N'�������',N'��������', N'����������',375296222222, N'375296222222����������',  N'222222',  N''),
(N'���������', N'����-����������', N'1',NULL,N'�������',N'�������������', N'��������',375296333333, N'375296333333��������',  N'333333',  N''),		
(N'���������', N'����������-��������', N'1',NULL,N'�����',N'����������', N'������',375296444444, N'375296444444������',  N'444444',  N''),		
(N'���������', N'����������-��������', N'1',NULL,N'�������',N'����������', N'�����������',375296555555, N'375296555555�����������',  N'555555',  N'')		
GO
SELECT * FROM Employees
WHERE OrganizationName = '���������'
GO
--------------------------------------------------------------------------------------------
 INSERT INTO HealingProcedures
VALUES (N' ', N' '),
(N'������ �� �����', N'������ �� �����'),
(N'���������������� ������', N'���������������� ������'),(N'�����������', N'�����������'),
(N'��������� air flow', N'��������� air flow'),( N'�������������� ������', N'�������������� ������'),
(N'������� �������', N'������� �������'),(N'������� ��������', N'������� ��������'),
(N'������� ��������', N'������� ��������'),(N'������� ������������', N'������� ������������'),

(N'�����', N'�����'),( N'���������������� ������� ������� ���', N'���������������� ������� ������� ���'),
(N'������������� ������ ����', N'������������� ������ ����'),( N'���������� ����������� ������', N'���������� ����������� ������'),
(N'����� �������', N'����� �������'),( N'������������������� �������', N'������������������� �������'),
(N'������� ������', N'������� ������'),( N'��������-������� ������������ ������', N'��������-������� ������������ ������'),
(N'����������� �������', N'����������� �������'),( N'��������� �������', N'��������� �������'),
(N'�����������', N'�����������'),( N'���������� ������� ������', N'���������� ������� ������'),
(N'���������� ������� ������', N'���������� ������� ������'),( N'��������� ������ �� �����������', N'��������� ������ �� �����������'),
(N'������������� ������������ �������', N'������������� ������������ �������')
	   GO
SELECT * FROM HealingProcedures
GO
--------------------------------------------------------------------------------------------
 --INSERT INTO Diseases
--VALUES (N'123', N'������ ������ ���������', N'������ �������� �� ���������� �������� �� ��� ��� ������ ����'),
--       (N'124', N'���������� �����', N'������������ ������ �����'),
 --      (N'125', N'������', N'��������� �������� ����'),(N'126', N'�������', N'��������� ������ ����� � ����������� �����')
--	   GO
--SELECT * FROM Diseases
--GO
--------------------------------------------------------------------------------------------
 INSERT INTO Patients
VALUES 
(N'����',N'����������',N'�������', N'375293423035', N'375293423035�������',  N'�����','01.01.1977'),
(N'������',N'����������', N'������������', N'375293123032', N'375293123032������������', N'�����','02.02.1983'),
(N'�����',N'����������',N'�������',N'375293123031', N'375293123031�������', N'��������','11.11.1965'),
( N'����',N'���������',N'��������', N'375296123030', N'375296123030��������', N'�������','03.05.1990'),
(N'���������',N'����������',N'������', N'375296123035',  N'375296123035������', N'��������','07.10.1960')
GO
SELECT * FROM Patients
GO
--------------------------------------------------------------------------------------------
SET DATEFORMAT dmy
GO
/* INSERT INTO PatientReceipts
VALUES 
	   ( N'375296222222����������', '16.11.2015', '08:30', N'375293123032������������', N'���� ����', N'������������� ������������ �������',N'31 �������'),
	   (  N'375296222222����������', '21.11.2017', '11:30',N'375293123032������������',  N'������', N'������� �������',N'31 ������, 33 ����������'),
	   (  N'375296222222����������', '20.11.2017', '19:30',N'375293123032������������',  N'������', N'������� �������',N'21 ������'),
	   (  N'375296333333��������', '29.11.2017', '20:00',N'375293123032������������',  N'������', N'������� �������',N'11 ������'),
	   ( N'375296333333��������', '24.12.2017', '12:30', N'375293123031�������', N'���������� �����', N'���������������� ������� ������� ���', N'������������ � ������� ������� �������'),
	   (  N'375296333333��������', '25.12.2017', '16:30', N'375293123031�������', N'���������� �����', N'���������������� ������� ������� ���', N'������ ������� �������'),
	   ( N'375296444444������', '15.09.2017', '17:30',N'375296123030��������',  N'������', N'������������� ������ ����', N'11, 21 ���������� ����� � ������'),
	   ( N'375296444444������', '16.09.2017', '09:30',N'375296123030��������',  N'������', N'������������� ������ ����', N'31, 41 ������'),
	   ( N'375296444444������', '16.11.2015', '16:00', N'375296123035������', N'�������', N'������� ��������', N'27 ������, 37 �������'),
	   ( N'375296555555�����������', '16.11.2015', '15:30',N'375296123035������',  N'���������� ����', N'����� �������', N'38 �������'),
	   ( N'375296555555�����������', '17.11.2015', '14:00',N'375296123035������',  N'���������� ����', N'����� �������', N'38 �������'),
	   ( N'375296555555�����������', '18.11.2015', '11:00', N'375296123035������', N'���������� �����', N'��������� air flow', N'������ � ����������� air flow')
GO
SELECT * FROM PatientReceipts
ORDER BY ReceiptDate
GO*/
------------------------------------------------------------------------------------------
---------------------------------5. �������� ������������� (�� �������� � ��.4.6-4.8)
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
/*SELECT * FROM PatientReceipts_VIEW1       --�������� ����������� ����������
ORDER BY PatientReceipts_VIEW1.ProcedureName  --,PatientReceipts_VIEW1.EmployeeCode  --� �����������(���� �����)
GO*/
--------------                         --��������� ������������� ��� �������� ����, ������� � ����� ��������
ALTER VIEW PatientReceipts_VIEW1 AS    -- ������ ������ �� �����������   
SELECT E.FullEmployeeName, H.ProcedureName,COUNT(H.ProcedureName) AS ProceduresQuantity  
FROM dbo.PatientReceipts AS P INNER JOIN dbo.Employees AS E ON P.EmployeeCode = E.EmployeeCode
					 --INNER JOIN dbo.Diseases AS D ON  P.DiseaseCode = D.DiseaseCode
					 INNER JOIN dbo.HealingProcedures AS H ON P.ProcedureName = H.ProcedureName
					 INNER JOIN dbo.Patients AS Pat ON P.PatientCode = Pat.PatientCode
GROUP BY E.FullEmployeeName, H.ProcedureName
GO
SELECT * FROM PatientReceipts_VIEW1         --�������� ����������� ����������
ORDER BY PatientReceipts_VIEW1.FullEmployeeName, PatientReceipts_VIEW1.ProcedureName  --� �����������
GO

/*DROP VIEW PatientReceipts_VIEW1           --�������� ��� ��������� ������������� �� ��
GO */

---------------------------------7.�������� ���������, �������------------------------------------------------------

 --------------------------------�������� �������� ���������----------------------------------------------------------
  ------------������� ���������� �� FullEmployeeName ����� �/��� ���� ������
  ------------����. ��������� - ����������: ���������� ���������� �����/���� ������ ������ ���� �� ���������� ����
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

EXEC pr_Schedule_@FEName_@RDate_first @FEName ='�������� �.�.', @RDate = N'24.12.2017'
GO  --��������: ������� ��� ������ ����� ��������� ������ ��������� �� ���� 16.11.2015

   EXEC pr_Schedule_@FEName_@RDate_first @FEName ='�������� �.�.', @RDate = NULL
   GO  --��������: ������� ��� ������ ����� ��������� ������ ��������� (�� ��� ����)

    EXEC pr_Schedule_@FEName_@RDate_first @FEName =NULL, @RDate =N'24.12.2017'
    GO  --��������: ������� ��� ������ ���� ������ �� ���� 16.11.2015

	EXEC pr_Schedule_@FEName_@RDate_first @FEName =NULL, @RDate =NULL
    GO  --��������: ������� ��� ������ ���� ������ (�� ��� ����)
*/
 /*DROP PROCEDURE pr_Schedule_@FEName_@RDate_first */

 
  
  ------------------------------CODE------------------------------------------------
  ------------����. ��������� - ����������: ���������� ���������� �����/���� ������ ������ ���� �� ���������� ����
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

EXEC pr_Schedule_@FECode_@RDate_first_CODE @FECode ='375296333333��������', @RDate = N'24.12.2017'
GO  --��������: ������� ��� ������ ����� ��������� ������ ��������� �� ���� 16.11.2015

   EXEC pr_Schedule_@FECode_@RDate_first_CODE @FECode ='375296333333��������', @RDate = NULL
   GO  --��������: ������� ��� ������ ����� ��������� ������ ��������� (�� ��� ����)

    EXEC pr_Schedule_@FECode_@RDate_first_CODE @FECode =NULL, @RDate =N'24.12.2017'
    GO  --��������: ������� ��� ������ ���� ������ �� ���� 16.11.2015

	EXEC pr_Schedule_@FECode_@RDate_first_CODE @FECode =NULL, @RDate =NULL
    GO  --��������: ������� ��� ������ ���� ������ (�� ��� ����)
    */
 /*DROP PROCEDURE pr_Schedule_@FEName_@RDate_first */


  ------------������� ���������� �� �������� PatientPhone �������� �/��� ���� ������
  ------------����. ��������� - ����������: ���������� ���������� ��������� ��������/���� ��������� ������ ���� �� ���������� ����
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
GO  --��������: ������� ��� ��������� �������� ���.375296123035 �� ���� 16.11.2015

   EXEC pr_Schedule_@PPhone_@RDate_first @PPhone ='375293123031', @RDate = NULL
   GO  --��������: ��������� �������� ���.375296123035 (�� ��� ����)

    EXEC pr_Schedule_@PPhone_@RDate_first @PPhone =NULL, @RDate ='24.12.2017'
    GO  --��������: ������� ���������� ��������� ����� ��������� �� ���� 16.11.2015

	EXEC pr_Schedule_@PPhone_@RDate_first @PPhone =NULL, @RDate =NULL
    GO  --��������: ������� ��� ��������� ���� ��������� (�� ��� ����)*/
	/*DROP PROCEDURE pr_Schedule_@PPhone_@RDate_first*/

------------������ ����: ��� ���������� �� ����, ������� ��������, ���� � ����� ������. 
 ------------������� �� ReceiptDate ��������
 ------------����. ��������� - ����������: ����� ������� �� ������������ ����
 /*CREATE PROC pr_Schedule_@RDate_first
@RDate date
 AS 
SELECT E.FullEmployeeName, P.FullPatientName, P.PatientPhone,PR.ReceiptDate,
    PR.ReceiptTime, PR.DiseaseCode, PR.Note  
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
 WHERE PR.ReceiptDate = @RDate 
 GO
 /*��������: ������� ������� (���� �������) �������� � ������� �������� 375293123032*/
 EXEC pr_Schedule_@RDate_first @RDate = '24.12.2017'
 GO*/
 /*DROP PROCEDURE  pr_Schedule_@RDate_first*/
----------------------------------------
----------------------------------------------------------------------------------------------------------------------
 ------------����. ��������� - ����������: ���������� ���������� �����/���� ������ ������ ���� �� ���������� ����
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

EXEC pr_Schedule_@FECode_@RDate_second @FECode ='375296333333��������', @RDate = N'09.04.2018'
GO  --��������: ������� ��� ������ ����� ��������� ������ ��������� �� ���� 16.11.2015

   EXEC pr_Schedule_@FECode_@RDate_second @FECode ='375296333333��������', @RDate = NULL
   GO  --��������: ������� ��� ������ ����� ��������� ������ ��������� (�� ��� ����)

    EXEC pr_Schedule_@FECode_@RDate_second @FECode =NULL, @RDate =N'09.04.2018'
    GO  --��������: ������� ��� ������ ���� ������ �� ���� 16.11.2015

	EXEC pr_Schedule_@FECode_@RDate_second @FECode =NULL, @RDate =NULL
    GO  --��������: ������� ��� ������ ���� ������ (�� ��� ����)
	*/
 /*DROP pr_Schedule_@FECode_@RDate_second */
---------------------------------------------------------------------------------------------------------------------
-----------�������� ���������: ������� �� ���������� �� ���� ������ ������ ������ ������� ���� ��� ����������� �����������------------------------------
 /*CREATE PROC pr_@FECode_DELETE_FROM_Schedule_EMPTYSTRINGS
@FECode varchar (32),
@RDate date,
@PCode varchar(32)
 AS 
  DELETE FROM PatientReceipts
   WHERE  EmployeeCode=@FECode AND ReceiptDate=@RDate AND PatientCode=@PCode
 GO*/
/*EXEC pr_@FECode_DELETE_FROM_Schedule_EMPTYSTRINGS @FECode ='375296333333��������', @RDate ='16.04.2018', @PCode=NULL
  GO  */
 /*DROP PROCEDURE  pr_@FECode_DELETE_FROM_Schedule_EMPTYSTRINGS */
----------------------------------------------------------------------------------------------------------------------
 ---------------------------------------�������������� ��� ������� ���������-----------------------------------------
------------������ ����: ��� ���������� �� ����, ������� ��������, ���� � ����� ������. 
 ------------������� �� PatientPhone ��������
 ------------����. ��������� - ����������: ����� ������ ������� ��������� �������� �� ��� ��������
 CREATE PROC pr_Schedule_@PPhone_first
 @PPhone numeric (16, 0)
 AS 
SELECT P.FullPatientName,P.PatientPhone,E.FullEmployeeName, PR.ReceiptDate, PR.ReceiptTime,PR.DiseaseCode, PR.Note 
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
 WHERE P.PatientPhone = @PPhone
 GO
 /*��������: ������� ������� (���� �������) �������� � ������� �������� 375296123035*/
 EXEC pr_Schedule_@PPhone_first @PPhone ='375296123035'
 GO
  /*DROP PROCEDURE  pr_Schedule_@PPhone_first */

 -----------------------------------------------------------------------------------------------------------------
 ------------������� �� FullPatientName ��������
 ------------����. ��������� - ����������: ����� ������ ������� ��������� �������� �� ��� �������
 CREATE PROC pr_Schedule_@FPatientName_first
 @FPatientName varchar (32)
 AS 
SELECT P.FullPatientName,P.PatientPhone,E.FullEmployeeName, PR.ReceiptDate, PR.ReceiptTime,PR.DiseaseCode, PR.Note 
    FROM PatientReceipts PR INNER JOIN Employees E ON PR.EmployeeCode = E.EmployeeCode
	                        INNER JOIN Patients P ON PR.PatientCode = P.PatientCode
 WHERE P.FullPatientName = @FPatientName
 GO
 /*��������: ������� ������� (���� �������) �������� � ������� �������� 375296123035*/
 EXEC pr_Schedule_@FPatientName_first @FPatientName ='������'
 GO
  /*DROP PROCEDURE  pr_Schedule_@FPatientName_first */

------------------------------------------------------------------------------------------------------------------------------

 ---------------�������� ���������: �������� ���������� �� ���� �� ���� ���������� � ���� ������------------------------------
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
EXEC pr_INSERT_Schedule_@FECode_@RDate_first @FECode ='375296333333��������', @RDate = '17.04.2018' --@FECode ='375296555555�����������', @RDate = '09.04.2018'
    GO */
/*SELECT * FROM PatientReceipts WHERE PatientReceipts.ReceiptDate = '09.04.2018';
DELETE FROM PatientReceipts; where PatientReceipts.PatientCode = NULL; OR ProcedureName = NULL;*/
/*DROP PROCEDURE  pr_INSERT_Schedule_@FECode_@RDate_first 
DELETE FROM Patients;*/

----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
        