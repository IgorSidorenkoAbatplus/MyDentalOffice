using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
//using System.Drawing.Drawing2D;

namespace MyDentalOffice
{
    public partial class MyDentalOfficeMain : Form
    {
        public MyDentalOfficeMain()
        {
            InitializeComponent();
            DateTimePickerShedule.Value = DateTime.Today;
            DateTimePickerPatientAge.Value = DateTime.Today;
            TbRDate.Text = System.DateTime.Now.ToShortDateString();
            this.myDentalOffice_3DataSet.PatientReceipts.Clear();
        }
        /*-----------------------------------Блок определения общих управляющих элементов приложения---------------------------*/
        MainClassConnection MainClassConnection = new MainClassConnection(null, null, null);//создание экземпляра класса подключения
        static string connectionString = @"Data Source=DESKTOP-OKAK99H;Initial Catalog=MyDentalOffice_3;Integrated Security=True";
        //static string connectionString = @"Data Source=.\SQLEXPRESS; Initial Catalog=MyDentalOffice_3;Integrated Security=True";
        SqlConnection connection = new SqlConnection(connectionString); //объявление подключения от текущей строки подключения 
        string sqlExpression = null;
        private void MyDentalOfficeMain_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'myDentalOffice_3DataSet.Patients' table. You can move, or remove it, as needed.
            //this.patientsTableAdapter.Fill(this.myDentalOffice_3DataSet.Patients);
            this.healingProceduresTableAdapter.Fill(this.myDentalOffice_3DataSet.HealingProcedures);
            //this.patientReceiptsTableAdapter.Fill(this.myDentalOffice_3DataSet.PatientReceipts);
            this.employeesTableAdapter.Fill(this.myDentalOffice_3DataSet.Employees);
        }
        private void toolStripMenuItemClose_Click(object sender, EventArgs e)
        {
            Close();
        }
        private void toolStripMenuItemAboutApplication_Click(object sender, EventArgs e)
        {
            AboutApplication AboutApplication = new AboutApplication();
            AboutApplication.ShowDialog();
        }
        private void toolStripMenuItemAuthor_Click(object sender, EventArgs e)
        {
            Reference Author = new Reference();
            Author.ShowDialog();
        }
        private void BtnExit_Click(object sender, EventArgs e)
        {
            Close();
        }
        //открытие вкладок в контекстном меню
        private void toolStripMenuItemPage1_Click(object sender, EventArgs e)
        {
            TabControlMain.SelectTab(TabPagePatients);
        }
        private void toolStripMenuItemShedule_Click(object sender, EventArgs e)
        {
            TabControlMain.SelectTab(TabPageCreateShedule);
        }
        private void toolStripMenuItemSearchRecord_Click(object sender, EventArgs e)
        {
            TabControlMain.SelectTab(TabPagePatientsRecordSearch);
        }
        private void toolStripMenuItemEmployees_Click(object sender, EventArgs e)
        {
            TabControlMain.SelectTab(TabPageEmployees);
        }
        /*------------------------------Закрытие формы с предложением сохраниить данные--------------------------------------------*/
        private void MyDentalOfficeMain_FormClosing(object sender, FormClosingEventArgs e)//предложение сохранения данных первой вкладки при закрытии приложения 
        {
            DialogResult resp = MessageBox.Show("Внимание! При наличии в расписании несохраненных данных, без сохранения, они будут утеряны. Сохранить текущее состояние данных? ", "Закрыть приложение", MessageBoxButtons.YesNo);
            if (resp == DialogResult.Yes)
            {
                saveShedule();
            }
        }
        /*------------------------------------------------Блок первой вкладки: Учетная запись пациента------------------------------------*/
        SqlDataAdapter DataAdapter_Patients;//адаптер для грида DataGridView_Patients
        DataTable DataTable_Patients = new DataTable();//новая таблица для грида DataGridView_Patients
        private void BtnCreatePatientsRecord_Click(object sender, EventArgs e)//создать учетную запись пациента
        {
            refresh();//очистить датасет и дататейбл грида
            Patient APatient = new Patient(TbPatientName.Text, TbPatientPatronymic.Text, TbFullPatientName.Text, TbPatientPhone.Text,
            TbPatientCode.Text, TbPatientAddress.Text, Convert.ToDateTime(this.DateTimePickerPatientAge.Value));
            APatient.Name = TbPatientName.Text;
            APatient.Patronymic = TbPatientPatronymic.Text;
            APatient.FullName = TbFullPatientName.Text;
            APatient.Phone = TbPatientPhone.Text;
            TbPatientCode.Text = TbPatientPhone.Text + TbFullPatientName.Text;
            APatient.Code = TbPatientCode.Text;
            APatient.Address = TbPatientAddress.Text;
            APatient.Age = Convert.ToDateTime(this.DateTimePickerPatientAge.Value);
            try //открыть подключение
            {
                connection.Open();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            try
            {
                if (string.IsNullOrEmpty(TbFullPatientName.Text))
                    MessageBox.Show("Заполните поле Фамилия!");
                else
                {
                    APatient.FullName = TbFullPatientName.Text;
                    if (string.IsNullOrEmpty(TbPatientPhone.Text))
                        MessageBox.Show("Заполните поле Телефон!");
                    else
                    {
                        try
                        {
                            APatient.Phone = TbPatientPhone.Text;
                        }
                        catch
                        { MessageBox.Show("Корректно заполните поле Телефон!"); }

                        if (string.IsNullOrEmpty(TbPatientCode.Text))
                        {
                             sqlExpression = null;
                            TbPatientCode.Text = TbPatientPhone.Text + TbFullPatientName.Text;
                            APatient.Code = TbPatientCode.Text; //APatient.Phone + APatient.FullName;
                            sqlExpression = "INSERT INTO [Patients] VALUES ('" + APatient.Name + "', '" + APatient.Patronymic + "', '" + APatient.FullName + "', " + Convert.ToDecimal(APatient.Phone) + ", '" + APatient.Code + "', '" + APatient.Address + "','" + APatient.Age + "');";
                            SqlCommand command = new SqlCommand(sqlExpression, connection);//сформировать SQL-команду для текущего подключения 
                            command.ExecuteNonQuery();
                            refresh();//очистить и обновить грид 
                            MessageBox.Show("Учетная запись пациента успешно создана");
                        }
                        else
                        {
                            TbPatientCode.Text = TbPatientPhone.Text + TbFullPatientName.Text;
                            APatient.Code = TbPatientCode.Text;
                            try
                            {
                                 sqlExpression = null;
                                sqlExpression = "INSERT INTO [Patients] VALUES ('" + APatient.Name + "', '" + APatient.Patronymic + "', '" + APatient.FullName + "', " + Convert.ToDecimal(APatient.Phone) + ", '" + APatient.Code + "', '" + APatient.Address + "','" + APatient.Age + "');";
                                SqlCommand command = new SqlCommand(sqlExpression, connection);//сформировать SQL-команду для текущего подключения 
                                command.ExecuteNonQuery();
                                refresh();//очистить и обновить грид 
                                MessageBox.Show("Учетная запись пациента успешно создана");
                            }
                            catch { MessageBox.Show("Проверьте правильность ввода данных!"); }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            { connection.Close(); }
        }
        // переопределенная обработка ошибок грида DataGridView_Patients
        private void DataGridView_Patients_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {
                connection.Open();
                this.Validate();//проверка 
                // this.DataAdapter_Patients.Update(this.DataTable_Patients);//для автосохранения - отменено
            }
            catch (Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }
        //очистка текстбоксов
        private void BtnClean_Click(object sender, EventArgs e)
        {
            TbPatientName.Clear(); TbPatientPatronymic.Clear(); TbFullPatientName.Clear(); TbPatientPhone.Clear();
            TbPatientCode.Clear(); TbPatientAddress.Clear();
        }
        //обновление данных в гриде DataGridView_Patients
        private void BtnRefresh_Click(object sender, EventArgs e)
        {
            refresh();
            try //открыть подключение
            {
                connection.Open();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }
        //удаление учетной записи пациента
        private void BtnDeletePatientsRecord_Click(object sender, EventArgs e)
        {
            Patient APatient = new Patient(TbDeletePatientsRecord.Text);
            APatient.Code = null;
            APatient.Code = this.TbDeletePatientsRecord.Text;
            try //открыть подключение
            {
                connection.Open();
                DialogResult resp = MessageBox.Show("Внимание! Может быть удалена только запись, не имеющая связанных цепочек в расписании. Точно хотите удалить данную запись? ", "Удаление учетной записи пациента", MessageBoxButtons.YesNo);
                if (resp == DialogResult.Yes)
                {
                    if (!string.IsNullOrEmpty(APatient.Code))
                    {
                        sqlExpression = null;
                        sqlExpression = "DELETE FROM Patients WHERE PatientCode = '" + APatient.Code + "' ;";
                        SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
                        command.ExecuteNonQuery();
                        MessageBox.Show("Удаление завершено");
                        refresh();//очистить и обновить грид
                    }
                }
                else
                {
                    TbDeletePatientsRecord.Clear();
                }
            }
            catch 
            {
                MessageBox.Show("Нельзя напрямую удалить учетную запись пациента с активной историей посещений.");
            }
            finally
            { connection.Close(); }
        }
        void refresh()//метод обновления данных грида DataGridView_Patients
        {
            gridClear();//почистить данные грида
             sqlExpression = null;
            sqlExpression = "SELECT * FROM Patients;";
            SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
            DataAdapter_Patients = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
            SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_Patients);
            DataAdapter_Patients.Fill(DataTable_Patients);
            DataGridView_Patients.DataSource = DataTable_Patients;
        }
        void gridClear()//метод очистки данных грида (таблицу и датасет) DataGridView_Patients
        {
            DataTable_Patients.Clear();
            this.myDentalOffice_3DataSet.Patients.Clear();
        }
        //копировать данные из поля *Код
        private void btnCopy_Click(object sender, EventArgs e)//копировать данные из поля *Код 
        {
            Clipboard.Clear();    
            Patient APatient = new Patient(TbPatientCode.Text);
            APatient.Code = null;
            TbPatientCode.Focus();
            TbPatientCode.SelectAll();
            if (TbPatientCode.SelectionLength > 0)
                TbPatientCode.Copy();
            APatient.Code = TbPatientCode.Text;
        }
        /*----------------------------------------Блок второй вкладки: Расписание приема пациентов-----------------------------*/
        SqlDataAdapter DataAdapter_SheduleOnECodeAndRDate;//адаптер для грида DataGridView_Shedule
        DataTable DataTable_SheduleOnEmpCodeAndRDate = new DataTable();//новая таблица для грида DataGridView_Shedule
        private void BtnCreateShedule_Click(object sender, EventArgs e) //создать расписание
        {
            cleanDGV();
            Shedule AShedule = new Shedule(TbEmpCode.Text, Convert.ToDateTime(this.DateTimePickerShedule.Value));//создание экземлпяра класса расписания
            AShedule.SheduleEmployeeCode = this.TbEmpCode.Text;
            AShedule.SheduleReceiptDate = Convert.ToDateTime(this.DateTimePickerShedule.Value);
            try
            {
                connection.Open();
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
            try
            {
                if (string.IsNullOrEmpty(TbEmpCode.Text))
                    MessageBox.Show("Заполните поле \"Код специалиста\"!");
                else
                {
                    try
                    {
                         sqlExpression = null;
                        sqlExpression = "pr_INSERT_Schedule_@FECode_@RDate_first @FECode ='" + AShedule.SheduleEmployeeCode + "', @RDate = '" + AShedule.SheduleReceiptDate + "' ;";
                        SqlCommand command = new SqlCommand(sqlExpression, connection);//Формируем SQL-команду для текущего подключения 
                        command.ExecuteNonQuery();
                        MessageBox.Show("Расписание на указанную дату успешно создано.");
                    }
                    catch { MessageBox.Show("Проверьте корректность ввода данных!"); }
                    try
                    {
                         sqlExpression = null;
                        sqlExpression = "SELECT * FROM PatientReceipts WHERE EmployeeCode ='" + AShedule.SheduleEmployeeCode + "' AND ReceiptDate = '" + AShedule.SheduleReceiptDate + "' ;";
                        SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
                        DataAdapter_SheduleOnECodeAndRDate = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
                        SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_SheduleOnECodeAndRDate);
                        DataAdapter_SheduleOnECodeAndRDate.Fill(DataTable_SheduleOnEmpCodeAndRDate);
                        DataGridView_Shedule.DataSource = DataTable_SheduleOnEmpCodeAndRDate;
                    }
                    catch (Exception ex) { MessageBox.Show(ex.Message); }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }
        void cleanDGV()//метод очистки данных грида (таблицу и датасет) DataGridView_Shedule
        {
            DataTable_SheduleOnEmpCodeAndRDate.Clear();
            this.myDentalOffice_3DataSet.PatientReceipts.Clear();
        }
        private void MainSearch_Click(object sender, EventArgs e) //Вызов расписания из бд по данным из текстбокса\дататаймпикера кликом мышки
        {
            Shedule AShedule = new Shedule(TbEmpCode.Text, Convert.ToDateTime(DateTimePickerShedule.Value));
            AShedule.SheduleEmployeeCode = this.TbEmpCode.Text;
            AShedule.SheduleReceiptDate = Convert.ToDateTime(this.DateTimePickerShedule.Value);
            TbRDate.Text = Convert.ToString(this.DateTimePickerShedule.Text);
            cleanDGV();//очистка данных грида (табл. и датасет)        
            try
            {
                connection.Open();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            try
            {
                sqlExpression = null;
                if (string.IsNullOrEmpty(TbEmpCode.Text))
                    TbEmpCode.Text = TbEmpCode.Text;
                else
                {
                    try
                    {
                        sqlExpression = "SELECT * FROM PatientReceipts WHERE EmployeeCode ='" + AShedule.SheduleEmployeeCode + "' AND ReceiptDate = '" + AShedule.SheduleReceiptDate + "' ;";
                        SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
                        DataAdapter_SheduleOnECodeAndRDate = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
                        SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_SheduleOnECodeAndRDate);//создание построителя команд: для адаптера становятся доступными команды обновления и тд.
                        DataAdapter_SheduleOnECodeAndRDate.Fill(DataTable_SheduleOnEmpCodeAndRDate); // передача данных из адаптера в DataTable_SheduleOnEmpCodeAndRDate:комент для новой таблицы
                        DataGridView_Shedule.DataSource = DataTable_SheduleOnEmpCodeAndRDate;//соединение данных таблицы с элементом DataGridView:комент для новой таблицы 
                    }
                    catch (Exception ex)
                    { MessageBox.Show(ex.Message); }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }
        private void new_DataError(object sender, DataGridViewDataErrorEventArgs e)//новый метод обработки вывода ошибок грида DataGridView_Shedule
        {
            try
            {
                connection.Open();
                this.Validate();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally { connection.Close(); }
        }
        void saveShedule()//метод сохранения данных грида DataGridView_Shedule
        {
            try
            {
                connection.Open();
                try
                {
                    this.Validate();
                    this.DataAdapter_SheduleOnECodeAndRDate.Update(this.DataTable_SheduleOnEmpCodeAndRDate);
                }
                catch (System.Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show(ex.Message);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }
        private void BtnSaveShedule_Click(object sender, EventArgs e) //сохранение данных таблицы
        {
            saveShedule();
            MessageBox.Show("Сохранение данных завершено");
        }
        private void DataGridView_Shedulee_Leave(object sender, EventArgs e)//сохранение данных при закрытии текущей таблицы грида DataGridView_Shedule
        {
            saveShedule();
        }
       /* private void DataGridView_Shedule_MouseLeave(object sender, EventArgs e)
        {
            saveShedule();
        }*/

        private void ComboBoxEmpCode_SelectedValueChanged(object sender, EventArgs e) //передача данных в верификационное поле при выборе нового значения
        {

            TbEmpCode.Text = ComboBoxEmpCode.Text.ToString();
        }
        //вставить код пациента из буфера обмена в грид DataGridView_Shedule
        private void BtnAddPatientCode_Click(object sender, EventArgs e)//вставить код пациента, скопированный кнопкой Копировать вкладки "Учетная запись пациента" после создания записи пациента
        {
            Patient APatient = new Patient(Convert.ToString(this.TbPatientCode.Text));
            APatient.Code = null;
            Clipboard.Clear();
            APatient.Code = this.TbPatientCode.Text;
            if ((!string.IsNullOrEmpty(APatient.Code)) && (DataGridView_Shedule.RowCount == 29))
            {
                int selectedColumnIndex = DataGridView_Shedule.CurrentCell.ColumnIndex;
                int selectedRowIndex = DataGridView_Shedule.CurrentCell.RowIndex;
                if (DataGridView_Shedule.CurrentCell.ColumnIndex == 1)
                {
                    DataGridView_Shedule.Focus();
                    DataGridView_Shedule[selectedColumnIndex, selectedRowIndex].Value = APatient.Code;
                    saveShedule();
                }
            }
            else
            {
                MessageBox.Show("Чтобы вставить значение, поле *Код пациента должно быть заполнено; затем, установите курсор в нужную ячеку колонки \"*Код пациента\", и нажмите кнопку \"*Вставить\" повторно ");

            }
        }
        /*------------------------------------------------Блок третьей вкладки: История посещений пациента------------------------------------*/
        SqlDataAdapter DataAdapter_SearchRecord;//адаптер для грида DataGridView_SearchRecord 
        DataTable DataTable_SearchRecord = new DataTable();//новая таблица для данных DataGridView_SearchRecord 
        SqlDataAdapter DataAdapter_SearchHistory;//адаптер для грида DataGridView_SearchHistory  
        DataTable DataTable_SearchHistory = new DataTable();//новая таблица для данных DataGridView_SearchHistory 
        /*-------------Поиск учетной записи пациента----------------------------*/
        private void BtnSearchRecord_Click(object sender, EventArgs e)//поиск учетной записи пациента
        {
            Patient APatient = new Patient(TbSearchRecordOnFullName.Text, TbSearchRecordOnPhone.Text, TbSearchRecordOnCode.Text);
            APatient.FullName = TbSearchRecordOnFullName.Text;
            APatient.Phone = TbSearchRecordOnPhone.Text;
            APatient.Code = TbSearchRecordOnCode.Text;
            try //открыть подключение
            {
                connection.Open();
                 sqlExpression = null;
                if ((RadioButtonSearchRecordOnCode.Checked == true) && (!string.IsNullOrEmpty(TbSearchRecordOnCode.Text)))
                {
                    clear_DGVSearchRecord();//почистить данные грида DataGridView_SearchRecord (таблицу и датасет)
                    sqlExpression = "SELECT * FROM Patients WHERE PatientCode = '" + APatient.Code + "';";
                    SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
                    DataAdapter_SearchRecord = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
                    SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_SearchRecord);
                    DataAdapter_SearchRecord.Fill(DataTable_SearchRecord);
                    DataGridView_SearchRecord.DataSource = DataTable_SearchRecord;
                }
                else if ((RadioButtonSearchRecordOnFullName.Checked == true) && (!string.IsNullOrEmpty(TbSearchRecordOnFullName.Text)))
                {
                    clear_DGVSearchRecord();//почистить данные грида DataGridView_SearchRecord (таблицу и датасет)
                    sqlExpression = "SELECT * FROM Patients WHERE FullPatientName = '" + APatient.FullName + "';";
                    SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения  
                    DataAdapter_SearchRecord = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
                    SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_SearchRecord);
                    DataAdapter_SearchRecord.Fill(DataTable_SearchRecord);
                    DataGridView_SearchRecord.DataSource = DataTable_SearchRecord;
                }
                else if ((RadioButtonSearchRecordOnPhone.Checked == true) && (!string.IsNullOrEmpty(TbSearchRecordOnPhone.Text)))
                {
                    clear_DGVSearchRecord();//почистить данные грида DataGridView_SearchRecord (таблицу и датасет)
                    sqlExpression = "SELECT * FROM [Patients] WHERE PatientPhone = " + Convert.ToDecimal(APatient.Phone) + ";";
                    SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения  
                    DataAdapter_SearchRecord = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
                    SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_SearchRecord);
                    DataAdapter_SearchRecord.Fill(DataTable_SearchRecord);
                    DataGridView_SearchRecord.DataSource = DataTable_SearchRecord;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            { connection.Close(); }
        }
        void clear_DGVSearchRecord()//метод очистки данных грида DataGridView_SearchRecord (таблицу и датасет)
        {
            DataTable_SearchRecord.Clear();
            this.myDentalOffice_3DataSet.Patients.Clear();
        }
        private void DataGridView_SearchRecord_DataError(object sender, DataGridViewDataErrorEventArgs e)//переопределенный метод обработки ошибок грида DataGridView_SearchRecord 
        {
            try
            {
                connection.Open();
                this.Validate();
            }
            catch
            {
                System.Windows.Forms.MessageBox.Show("Ошибка ввода данных. Проверьте корректность введенных значений.");//(ex.Message);
            }
            finally { connection.Close(); }
        }
        private void BtnCleanForRecord_Click(object sender, EventArgs e)//очистить текстбоксы в GroupBoxSearchRecord
        {
            TbSearchRecordOnFullName.Clear(); TbSearchRecordOnPhone.Clear(); TbSearchRecordOnCode.Clear();
        }
        /*-------------Поиск истории пациента--------------------*/
        private void BtnSearchHistory_Click(object sender, EventArgs e)//поиск истории пациента
        {
            Patient APatient = new Patient(TbSearchHistoryOnFullName.Text, TbSearchHistoryOnPhone.Text, TbSearchHistoryOnCode.Text);
            APatient.FullName = TbSearchHistoryOnFullName.Text;
            APatient.Phone = TbSearchHistoryOnPhone.Text;
            APatient.Code = TbSearchHistoryOnCode.Text;
            try //открыть подключение
            {
                connection.Open();
                 sqlExpression = null;
                if ((RadioButtonSearchHistoryOnCode.Checked == true) && (!string.IsNullOrEmpty(TbSearchHistoryOnCode.Text)))
                {
                    clear_DGVSearchHistory();//почистить данные грида DataGridView_SearchHistory (таблицу и датасет)
                    sqlExpression = "SELECT * FROM PatientReceipts WHERE PatientCode = '" + APatient.Code + "';";
                    SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
                    DataAdapter_SearchHistory = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
                    SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_SearchHistory);
                    DataAdapter_SearchHistory.Fill(DataTable_SearchHistory);
                    DataGridView_SearchHistory.DataSource = DataTable_SearchHistory;
                }
                else if ((RadioButtonSearchHistoryOnFullName.Checked == true) && (!string.IsNullOrEmpty(TbSearchHistoryOnFullName.Text)))
                {
                    clear_DGVSearchHistory();//почистить данные грида DataGridView_SearchHistory (таблицу и датасет)
                    sqlExpression = "SELECT * FROM [PatientReceipts] [PR] INNER JOIN [Patients] [P] ON [PR].[PatientCode] = [P].[PatientCode] WHERE [P].[FullPatientName] = '" + APatient.FullName + "';";
                    SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
                    DataAdapter_SearchHistory = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
                    SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_SearchHistory);
                    DataAdapter_SearchHistory.Fill(DataTable_SearchHistory);
                    DataGridView_SearchHistory.DataSource = DataTable_SearchHistory;
                }
                else if ((RadioButtonSearchHistoryOnPhone.Checked == true) && (!string.IsNullOrEmpty(TbSearchHistoryOnPhone.Text)))
                {
                    clear_DGVSearchHistory();//почистить данные грида DataGridView_SearchHistory (таблицу и датасет)
                    sqlExpression = "SELECT * FROM [PatientReceipts] [PR] INNER JOIN [Patients] [P] ON [PR].[PatientCode] = [P].[PatientCode] WHERE PatientPhone = " + Convert.ToDecimal(APatient.Phone) + ";";
                    SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
                    DataAdapter_SearchHistory = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
                    SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_SearchHistory);
                    DataAdapter_SearchHistory.Fill(DataTable_SearchHistory);
                    DataGridView_SearchHistory.DataSource = DataTable_SearchHistory;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally { connection.Close(); }
        }
        void clear_DGVSearchHistory()//метод очистки данных грида DataGridView_SearchHistory (таблицу и датасет) 
        {
            DataTable_SearchHistory.Clear();
            this.myDentalOffice_3DataSet.PatientReceipts.Clear();
        }
        private void BtnCleanForHistory_Click(object sender, EventArgs e)//очистить текстбоксы в GroupBoxSearchHistory
        {
            TbSearchHistoryOnFullName.Clear(); TbSearchHistoryOnPhone.Clear(); TbSearchHistoryOnCode.Clear();
        }
        private void DataGridView_SearchHistory_DataError(object sender, DataGridViewDataErrorEventArgs e)//переопределенный метод обработки ошибок грида DataGridView_SearchHistory
        {
            try
            {
                connection.Open();
                this.Validate();
            }
            catch
            {
                System.Windows.Forms.MessageBox.Show("Ошибка ввода данных. Проверьте корректность введенных значений.");
            }
            finally { connection.Close(); }
        }
        /*------------------------------------------------Блок четвертой вкладки: Учетная запись специалиста------------------------------------*/
        SqlDataAdapter DataAdapter_EmployeeRecord;//адаптер для грида DGV_Employee 
        DataTable DataTable_EmployeeRecord = new DataTable();//новая таблица для данных  DGV_Employee
        private void BtnCreateEmployeeRecord_Click(object sender, EventArgs e)//создать учетную запись специалиста 
        {
            //новый экземпляр класса специалист
            Employee AnEmployee = new Employee(TbEmployeeRecordOrganizationName.Text, TbEmployeeRecordPosition.Text, TbEmployeeRecordQCategory.Text,
            Convert.ToDateTime(DTPEmployeeRecordWExpirience.Value), TbEmployeeRecordName.Text, TbEmployeeRecordPatronymic.Text, TbEmployeeRecordFEName.Text,
            TbEmployeeRecordPhone.Text, TbEmployeeRecordCode.Text, TbEmployeeRecordPassEmpCode.Text, RtbEmployeeRecordPassportDate.Text);
            AnEmployee.EOrganizationName = TbEmployeeRecordOrganizationName.Text;//наименование организации
            AnEmployee.EPosition = TbEmployeeRecordPosition.Text;//должность
            AnEmployee.EQualificationCategory = TbEmployeeRecordQCategory.Text;//квалификационная категория
            AnEmployee.EWorkExpirience = Convert.ToDateTime(DTPEmployeeRecordWExpirience.Value);//стаж работы по специальности
            AnEmployee.EName = TbEmployeeRecordName.Text;//имя
            AnEmployee.EPatronymic = TbEmployeeRecordPatronymic.Text;//отчество
            AnEmployee.FullName = TbEmployeeRecordFEName.Text;//фамилия
            AnEmployee.Phone = TbEmployeeRecordPhone.Text;//телефон
            TbEmployeeRecordCode.Text = TbEmployeeRecordPhone.Text + TbEmployeeRecordFEName.Text;
            AnEmployee.Code = TbEmployeeRecordCode.Text;//код
            AnEmployee.EEmployeePassCode = TbEmployeeRecordPassEmpCode.Text;//пароль
            AnEmployee.EPassportDate = RtbEmployeeRecordPassportDate.Text;//паспортные данные
            try //открыть подключение
            {
                connection.Open();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            try
            {
                if (string.IsNullOrEmpty(TbEmployeeRecordFEName.Text))
                    MessageBox.Show("Заполните поле Фамилия!");
                else
                {
                    AnEmployee.FullName = TbEmployeeRecordFEName.Text;
                    if (string.IsNullOrEmpty(TbEmployeeRecordPhone.Text))
                        MessageBox.Show("Заполните поле Телефон!");
                    else
                    {
                        AnEmployee.Phone = TbEmployeeRecordPhone.Text;
                        if (string.IsNullOrEmpty(TbEmployeeRecordCode.Text))
                        {
                             sqlExpression = null;
                            TbEmployeeRecordCode.Text = TbEmployeeRecordPhone.Text + TbEmployeeRecordFEName.Text;
                            AnEmployee.Code = TbEmployeeRecordCode.Text;
                            sqlExpression = "INSERT INTO [Employees] VALUES ('" + AnEmployee.EOrganizationName + "', '" + AnEmployee.EPosition + "', '" + AnEmployee.EQualificationCategory + "', '" + AnEmployee.EWorkExpirience + "', '" + AnEmployee.EName + "','" + AnEmployee.EPatronymic + "','" + AnEmployee.FullName + "', " + Convert.ToDecimal(AnEmployee.Phone) + ", '" + AnEmployee.Code + "','" + AnEmployee.EEmployeePassCode + "','" + AnEmployee.EPassportDate + "');";
                            SqlCommand command = new SqlCommand(sqlExpression, connection);//сформировать SQL-команду для текущего подключения 
                            command.ExecuteNonQuery();
                            refreshEmployeeDGV();//очистить и обновить грид 
                            MessageBox.Show("Учетная запись специалиста успешно создана");
                        }
                        else
                        {
                            TbEmployeeRecordCode.Text = TbEmployeeRecordPhone.Text + TbEmployeeRecordFEName.Text;
                            AnEmployee.Code = TbEmployeeRecordCode.Text;
                            try
                            {
                                 sqlExpression = null;
                                sqlExpression = "INSERT INTO [Employees] VALUES ('" + AnEmployee.EOrganizationName + "', '" + AnEmployee.EPosition + "', '" + AnEmployee.EQualificationCategory + "', '" + AnEmployee.EWorkExpirience + "', '" + AnEmployee.EName + "','" + AnEmployee.EPatronymic + "','" + AnEmployee.FullName + "', " + Convert.ToDecimal(AnEmployee.Phone) + ", '" + AnEmployee.Code + "','" + AnEmployee.EEmployeePassCode + "','" + AnEmployee.EPassportDate + "');";
                                SqlCommand command = new SqlCommand(sqlExpression, connection);//сформировать SQL-команду для текущего подключения 
                                command.ExecuteNonQuery();
                                refreshEmployeeDGV();//очистить и обновить грид 
                                MessageBox.Show("Учетная запись специалиста успешно создана");
                            }
                            catch { MessageBox.Show("Проверьте правильность ввода данных!"); }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            { connection.Close(); }
        }
        // переопределенная обработка ошибок грида DGV_Employee
        private void DGV_Employee_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {
                connection.Open();
                this.Validate();
            }
            catch (Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }
        //очистка текстбоксов
        private void BtnCleanEmployee_Click(object sender, EventArgs e)
        {
            TbEmployeeRecordOrganizationName.Clear(); TbEmployeeRecordPosition.Clear(); TbEmployeeRecordQCategory.Clear();
            TbEmployeeRecordName.Clear(); TbEmployeeRecordPatronymic.Clear(); TbEmployeeRecordFEName.Clear();
            TbEmployeeRecordPhone.Clear(); TbEmployeeRecordCode.Clear(); TbEmployeeRecordPassEmpCode.Clear(); RtbEmployeeRecordPassportDate.Clear();
        }
        //обновление данных в гриде DGV_Employee
        private void BtnRefreshEmployee_Click(object sender, EventArgs e)
        {
            refreshEmployeeDGV();
            try //открыть подключение
            {
                connection.Open();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }
        void refreshEmployeeDGV()//метод обновления данных грида DGV_Employee
        {
            dGVEmployeeClear();//почистить данные грида DGV_Employee
             sqlExpression = null;
            sqlExpression = "SELECT * FROM Employees;";
            SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
            DataAdapter_EmployeeRecord = new SqlDataAdapter(command);//создание адаптера с командой - посредника между бд и DataSet
            SqlCommandBuilder CommandBuilder = new SqlCommandBuilder(DataAdapter_EmployeeRecord);
            DataAdapter_EmployeeRecord.Fill(DataTable_EmployeeRecord);
            DGV_Employee.DataSource = DataTable_EmployeeRecord;
        }
        void dGVEmployeeClear()//метод очистки данных грида (таблицу и датасет) DGV_Employee 
        {
            DataTable_EmployeeRecord.Clear();
           // this.myDentalOffice_3DataSet.Employees.Clear();//если включить - почистит содержимое комбобокса расписания
        }
        //удалить учетную запись специалиста
        private void ButtondeleteEmployeeRecord_Click(object sender, EventArgs e)
        {
            Employee AnEmployee = new Employee(TbDeliteEmployeeRecordCode.Text);
            AnEmployee.Code = null;
            AnEmployee.Code = TbDeliteEmployeeRecordCode.Text;
            try //открыть подключение
            {
                connection.Open();
                DialogResult resp = MessageBox.Show("Внимание! Может быть удалена только запись, не имеющая связанных цепочек в расписании. Точно хотите удалить данную запись? ", "Удаление учетной записи специалиста", MessageBoxButtons.YesNo);
                if (resp == DialogResult.Yes)
                {
                    if (!string.IsNullOrEmpty(AnEmployee.Code))
                    {
                        sqlExpression = null;
                        sqlExpression = "DELETE FROM Employees WHERE EmployeeCode = '" + AnEmployee.Code + "' ;";
                        SqlCommand command = new SqlCommand(sqlExpression, connection); //создание SQL-команды для текущего подключения 
                        command.ExecuteNonQuery();
                        MessageBox.Show("Удаление завершено");
                        refreshEmployeeDGV();
                        TbDeliteEmployeeRecordCode.Clear();                   
                    }
                }
                else
                {
                    TbDeliteEmployeeRecordCode.Clear();
                }
            }
            catch
            {
                MessageBox.Show("Нельзя напрямую удалить учетную запись специалиста с активной историей приема пациентов.");
            }
            finally
            { connection.Close(); }
        }
        //копировать данные из поля *Код 
        private void BtnCopyEmployee_Click(object sender, EventArgs e)
        {
            Employee AnEmployee = new Employee(TbEmployeeRecordCode.Text);
            AnEmployee.Code = null;
            Clipboard.Clear();
            TbEmployeeRecordCode.Focus();
            TbEmployeeRecordCode.SelectAll();
            if (TbEmployeeRecordCode.SelectionLength > 0)
                TbEmployeeRecordCode.Copy();
            AnEmployee.Code = TbEmployeeRecordCode.Text;
        }

    }
}
