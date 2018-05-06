using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MyDentalOffice
{
    class MainClassConnection  //базовый класс подключения
    {
        public string connectionString;//строка подключения
        public string connection;//подключение
        public string sqlExpression;//команда
        public MainClassConnection(string connectionString, string connection, string sqlExpression)
        {
            this.connectionString = connectionString;
            this.connection = connection;
            this.sqlExpression = sqlExpression;
        }
    }
    class Patient  //пациент
    {
        public string Name;//имя пациента
        public string Patronymic;//отчество пациента
        public string FullName;//фамилия
        public string Phone;//телефон
        public string Code;//код
        public string Address;//адрес пациента
        public DateTime Age;  //возраст пациента 
        public Patient(string Name, string Patronymic, string FullName, string Phone, string Code, string Address, DateTime Age)
        {
            this.Name = Name;
            this.Patronymic = Patronymic;
            this.FullName = FullName;
            this.Phone = Phone;
            this.Code = Code;
            this.Address = Address;
            this.Age = Age;
        }
        public Patient(string FullName, string Phone, string Code)
        {
            this.FullName = FullName;
            this.Phone = Phone;
            this.Code = Code;
        }
        public Patient(string Code) { this.Code = Code; }
    }
    class Employee //специалист
    {
        public string EOrganizationName;//наименование организации
        public string EPosition;//занимаемая должность
        public string EQualificationCategory;//квалификационная категория
        public DateTime EWorkExpirience;// опыт работы: с какого года
        public string EName;//имя специалиста
        public string EPatronymic;//отчество специалиста
        public string FullName;//фамилия
        public string Phone;//телефон
        public string Code;//код  
        public string EEmployeePassCode; //пароль доступа
        public string EPassportDate;//паспортные данные
        public Employee(string EOrganizationName, string EPosition, string EQualificationCategory, DateTime EWorkExpirience, string EName, string EPatronymic,
                        string FullName, string Phone, string Code, string EEmployeePassCode, string EPassportDate)
        {
            this.EOrganizationName = EOrganizationName;
            this.EPosition = EPosition;
            this.EQualificationCategory = EQualificationCategory;
            this.EWorkExpirience = EWorkExpirience;
            this.EName = EName;
            this.EPatronymic = EPatronymic;
            this.FullName = FullName;
            this.Phone = Phone;
            this.Code = Code;
            this.EEmployeePassCode = EEmployeePassCode;
            this.EPassportDate = EPassportDate;
        }
        public Employee(string Code) { this.Code = Code; }
    }
    class Shedule//расписание
    {
        public string SheduleEmployeeCode;//код специалиста
        public DateTime SheduleReceiptDate;//дата приема
        public string SheduleReceiptTime;//время приема
        public string ShedulePatientCode;//код пациента
        public string SheduleDiseaseCode;//проблема
        public string SheduleProcedureName;//процедура
        public string SheduleNote;//примечание
        public Shedule(string SheduleEmployeeCode, DateTime SheduleReceiptDate, string SheduleReceiptTime, string ShedulePatientCode,
          string SheduleDiseaseCode, string SheduleProcedureName, string SheduleNote)
        {
            this.SheduleEmployeeCode = SheduleEmployeeCode;
            this.SheduleReceiptDate = SheduleReceiptDate;
            this.SheduleReceiptTime = SheduleReceiptTime;
            this.ShedulePatientCode = ShedulePatientCode;
            this.SheduleDiseaseCode = SheduleDiseaseCode;
            this.SheduleProcedureName = SheduleProcedureName;
            this.SheduleNote = SheduleNote;
        }
        public Shedule(string SheduleEmployeeCode, DateTime SheduleReceiptDate)
        {
            this.SheduleEmployeeCode = SheduleEmployeeCode;
            this.SheduleReceiptDate = SheduleReceiptDate;
        }
        /*class HealingProcedures //процедура - заготовка к диплому
        {
            public string ProcedureName;//наименование
            public string ProcedureDescription;//описание
            public HealingProcedures(string ProcedureName, string ProcedureDescription)
            {
                this.ProcedureName = ProcedureName;
                this.ProcedureDescription = ProcedureDescription;
            }
        }
        class PRTime //класс "Время приема" - заготовка к диплому
        {
            public string ReceiptTime;
            public string TimeNumber;
            public PRTime(string ReceiptTime, string TimeNumber)
            {
                this.ReceiptTime = ReceiptTime;
                this.TimeNumber = TimeNumber;
            }
        }*/
    }
}


