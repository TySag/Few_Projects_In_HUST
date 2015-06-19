using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Resources;
using System.Text;
using System.Windows.Forms;
using MySql.Data.MySqlClient;

namespace Car
{
    public partial class CarMain : Form
    {
        Users user;
        Staffs staff;
        MySqlHelper sql;
        bool power;
        static string poweruser = "poweruser";
        static string powerpwd = "123456";
        static string sysdatabase = "car";
        string addstring(string word)
        {
            return "'" + word + "'";
        }
        public void ClearText()
        {
            foreach (Control c in this.Controls)
            {
                if (c.GetType() == typeof(TextBox))
                {
                    ((TextBox)c).Text = "";
                }
            }
        }
        public void ClearText(GroupBox g)
        {
            foreach (Control c in g.Controls)
            {
                if (c.GetType() == typeof(TextBox))
                {
                    ((TextBox)c).Text = "";
                }
            }
        }
        public void MoveEdit()
        {

        }
        public void ClearTab(){
            InfoShow.TabPages.Remove(UserInfo);//hide
            InfoShow.TabPages.Remove(CarInfo);//hide
            InfoShow.TabPages.Remove(StaffInfo);//hide  
            InfoShow.TabPages.Remove(OrderInfo);//hide  
            InfoShow.TabPages.Remove(Record);//hide
            InfoShow.TabPages.Remove(FixInfo);//hide    
            InfoShow.TabPages.Remove(AccInfo);//hide    
            InfoShow.TabPages.Remove(CarsInfo);//hide  
        }
        public void AddNone_Mod()
        {
            RoleLabel.Text = "NONE";
            InfoShow.TabPages.Add(CarInfo);//hide
            Tourist_Label.Location = new Point(52, 139);
            this.UserM.Controls.Add(Tourist_Label);
            Tourist_Label.Visible = true;
            Signin.Location = new Point(64, 182);
            this.UserM.Controls.Add(Signin);
            Signin.Visible = true;
            EditMenuItem.Enabled = false;
            MakeMenuItem.Enabled = false;
            SigninMenuItem.Enabled = true;
        }
        public void ClearNone_Mod()
        {
            ClearTab();
            Signin.Visible = false;
            Tourist_Label.Visible = false;    
            EditMenuItem.Enabled = true;
            MakeMenuItem.Enabled = true;
            SigninMenuItem.Enabled = false;
        }
        public void ShowStaffInfo()
        {
            Sid_Label.Text = "当前登陆："+ staff.Sid; 
            Sname_Label.Text = "姓名：" + staff.Name;  
            Spos_Label.Text = "职位：" + staff.Pos;
        }
        public void AddStaff_Mod()
        {
            RoleLabel.Text = "STAFF";
            ShowStaffInfo();
            InfoShow.TabPages.Add(CarInfo);//hide
            InfoShow.TabPages.Add(CarsInfo);//hide 
            InfoShow.TabPages.Add(UserInfo);//hide      
            InfoShow.TabPages.Add(OrderInfo);//hide
            InfoShow.TabPages.Add(Record);//hide
            InfoShow.TabPages.Add(FixInfo);//hide    
            InfoShow.TabPages.Add(AccInfo);//hide    
            Sid_Label.Location = new Point(52,128);
            this.UserM.Controls.Add(Sid_Label);
            Sid_Label.Visible = true;
            Sname_Label.Location = new Point(52, 156);
            this.UserM.Controls.Add(Sname_Label);
            Sname_Label.Visible = true;
            Spos_Label.Location = new Point(52, 185);
            this.UserM.Controls.Add(Spos_Label);
            Spos_Label.Visible = true;
            LogOut.Location = new Point(63, 215);
            this.UserM.Controls.Add(LogOut);
            LogOut.Visible = true;
            //UserShowMenuItem.Enabled = true;
            SignoutMenuItem.Enabled = true;
            MakeOrder.Enabled = false;
            CancelOrder.Enabled = false;
        }
        public void ClearStaff_Mod()
        {
            ClearTab(); 
            Sid_Label.Visible = false;
            Sname_Label.Visible = false;
            Spos_Label.Visible = false;
            LogOut.Visible = false;
            UserShowMenuItem.Enabled = false;
            SignoutMenuItem.Enabled = false;
            MakeOrder.Enabled = true;
            CancelOrder.Enabled = true;
        }
        public void ShowUserInfo()
        {
            Uid_Label.Text = "ID：" + user.Uid; 
            UserName_Label.Text = "姓名：" + user.Name; 
            Mail_Label.Text = "邮箱：" + user.Mail;   
            Phone_Label.Text = "电话：" + user.Phone;      
            Address_Label.Text = "地址：" + user.Address;
        }
        
        public void RelaseUser()
        {
            OUidText.ReadOnly = false;
            RUserIDText.ReadOnly = false;
            FixUIDText.ReadOnly = false;
            AccUIDText.ReadOnly = false;
        }
        public void KeepUser()
        {
            OUidText.Text = user.Uid;
            OUidText.ReadOnly = true;
            RUserIDText.Text = user.Uid;
            RUserIDText.ReadOnly = true;
            FixUIDText.Text = user.Uid;
            FixUIDText.ReadOnly = true;
            AccUIDText.Text = user.Uid;
            AccUIDText.ReadOnly = true;
        }
        public void AddUser_Mod()
        {
            RoleLabel.Text = "USER";
            ShowUserInfo();
            KeepUser();
            InfoShow.TabPages.Add(CarInfo);//hide
            InfoShow.TabPages.Add(CarsInfo);//hide    
            InfoShow.TabPages.Add(OrderInfo);//hide
            InfoShow.TabPages.Add(Record);//hide
            InfoShow.TabPages.Add(FixInfo);//hide    
            InfoShow.TabPages.Add(AccInfo);//hide    
            Uid_Label.Location = new Point(110, 47);
            this.UserM.Controls.Add(Uid_Label);
            Uid_Label.Visible = true;
            UserName_Label.Location = new Point(110, 81);
            this.UserM.Controls.Add(UserName_Label);
            UserName_Label.Visible = true;
            Mail_Label.Location = new Point(13, 125);
            this.UserM.Controls.Add(Mail_Label);
            Mail_Label.Visible = true;
            Phone_Label.Location = new Point(13, 149);
            this.UserM.Controls.Add(Phone_Label);
            Phone_Label.Visible = true;
            Address_Label.Location = new Point(13, 172);
            this.UserM.Controls.Add(Address_Label);
            Address_Label.Visible = true;
            LogOut.Location = new Point(63, 215);
            this.UserM.Controls.Add(LogOut);
            LogOut.Visible = true;
            EditMenuItem.Enabled = false;
            MakeMenuItem.Enabled = false;
            //UserShowMenuItem.Enabled = true;
            SignoutMenuItem.Enabled = true;
        }
        public void ClearUser_Mod()
        {
            ClearTab();
            Uid_Label.Visible = false;
            UserName_Label.Visible = false;
            Mail_Label.Visible = false;
            Phone_Label.Visible = false;
            Address_Label.Visible = false;
            LogOut.Visible = false;
            EditMenuItem.Enabled = true;
            MakeMenuItem.Enabled = true;
            UserShowMenuItem.Enabled = false;
            SignoutMenuItem.Enabled = false;
            RelaseUser();
        }
        public CarMain()
        {
            InitializeComponent();
            sql = new MySqlHelper(poweruser, powerpwd, sysdatabase);
            BodyChange_none();
        }

        //sign to the system
        private void Signin_Click(object sender, EventArgs e)
        {
            Login loginbox = new Login();
            loginbox.ShowDialog();
            if (loginbox.success)
            {
                power = loginbox.power;
                if (loginbox.power)
                {
                    staff = new Staffs(loginbox.staff);
                    BodyChange_Staff();
                }
                else
                {
                    user = new Users(loginbox.user);
                    BodyChange_User();
                }
            }
            loginbox.Dispose();
        }

        void BodyChange_none()
        {
            ClearPower();
            ClearUser_Mod();
            ClearStaff_Mod();
            AddNone_Mod();
        }
        void BodyChange_Staff()
        {//Carsinfo,       
            ClearNone_Mod();
            AddStaff_Mod();
        }
        void BodyChange_User()
        {
            ClearNone_Mod();
            AddUser_Mod();
        }
        //CarInfo be added , and it load data
        private void Info_ControlAdded(object sender, ControlEventArgs e)
        {
            DataTable dt;
            try
            {
                switch (e.Control.Name)
                {
                    case "CarInfo":
                        CarChoose.Location = new Point(5, 16);
                        Condition.Controls.Add(CarChoose);
                        CarChoose.Visible = true;
                        //sql = new MySqlHelper(poweruser, powerpwd, sysdatabase);
                        //sqlword = "select * from carsinfo";
                        dt = SelectCar(CarNameText.Text,CarBrandText.Text);//sql.ExecuteDt(sqlword);
                        CarData.DataSource = dt;
                        break;
                    case "CarsInfo":
                        //sql = new MySqlHelper(poweruser, powerpwd, sysdatabase);
                        //sqlword = "select * from cars";
                        dt = SelectCars(CarsIDText.Text,CarsNameText.Text,CarsPriceText.Text,CarsDepositText.Text, CarsStateText.Text);//sql.ExecuteDt(sqlword);
                        CarsData.DataSource = dt;
                        break;
                    case "UserInfo":
                        //sql = new MySqlHelper(poweruser, powerpwd, sysdatabase);
                        //sqlword = "select * from users";
                        dt = SelectUser(UserIDText.Text, UserNameText.Text,UserMailText.Text);//sql.ExecuteDt(sqlword);
                        UserData.DataSource = dt;
                        break;
                    case "OrderInfo":
                        //sql = new MySqlHelper(poweruser, powerpwd, sysdatabase);
                        //sqlword = "select * from Orders";
                        dt = SelectOrder(OrderIDText.Text,OUidText.Text,OCarsIDText.Text);//sql.ExecuteDt(sqlword);
                        OrderData.DataSource = dt;
                        break;
                    case "Record":
                        //sql = new MySqlHelper(poweruser, powerpwd, sysdatabase);
                        //sqlword = "select * from Records";
                        dt = SelectRecord(RUserIDText.Text, RCarsIDText.Text,RStaffIDText.Text);//sql.ExecuteDt(sqlword);
                        RecordData.DataSource = dt;
                        break;
                    case "FixInfo":
                        //sql = new MySqlHelper(poweruser, powerpwd, sysdatabase);
                        //sqlword = "select * from Fixlist";
                        dt = SelectFixSp(FixIDText.Text, FixUIDText.Text, FixCarNameText.Text);//sql.ExecuteDt(sqlword);
                        FixData.DataSource = dt;
                        break;
                    case "AccInfo":
                        //sql = new MySqlHelper(poweruser, powerpwd, sysdatabase);
                        //sqlword = "select * from accident";
                        dt = SelectAccSp(AccIDText.Text, AccUIDText.Text, AccCarNameText.Text);//sql.ExecuteDt(sqlword);
                        AccData.DataSource = dt;
                        break;
                    default: break;
                }
            }
            catch
            {
                //done nothing
            }
        }
        //CarData
        private void CarData_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            CarData.ClearSelection();
        }
        //UserData
        private void UserData_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            UserData.ClearSelection();
        }
        //CarsData
        private void CarsData_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            CarsData.ClearSelection();
        }
        //Order data
        private void OrderData_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            OrderData.ClearSelection();
        }
        //Record data
        private void RecordData_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            RecordData.ClearSelection();
        }
        //Fix data
        private void FixData_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            FixData.ClearSelection();
        }
        //Acc Data
        private void AccData_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            AccData.ClearSelection();
        }
        //sign out
        private void LogOut_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("确定退出吗？", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {  
                BodyChange_none();
            }
        }
        //sign in
        private void SigninMenuItem_Click(object sender, EventArgs e)
        {
            
            Login loginbox = new Login();
            loginbox.ShowDialog();
            if (loginbox.success)
            {
                if (loginbox.power)
                {
                    staff = new Staffs(loginbox.staff);
                    BodyChange_Staff();
                }
                else
                {
                    user = new Users(loginbox.user);
                    BodyChange_User();
                }
            }
            loginbox.Dispose();
        }
        //show User Message
        private void UserShowMenuItem_Click(object sender, EventArgs e)
        {
        }
        //sign out
        private void SignoutMenuItem_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("确定退出吗？", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                BodyChange_none();
            }
        }
        //select change
        private void InfoShow_SelectedIndexChanged(object sender, EventArgs e)
        {
            //
            CarChoose.Visible = false;
            UserChoose.Visible = false;
            CarsChoose.Visible = false;
            RecordChoose.Visible = false;
            FixChoose.Visible = false;
            AccChoose.Visible = false;
            OrderChoose.Visible = false;
            try
            {
                switch (InfoShow.SelectedTab.Name)
                {
                    case "CarInfo":
                        CarChoose.Location = new Point(5, 16);
                        Condition.Controls.Add(CarChoose);
                        CarChoose.Visible = true;
                        PowerAdd.Enabled = true;
                        PowerDel.Enabled = true;
                        PowerUpdate.Enabled = true;
                        //PowerUpdate.Text = "修改";
                        break;
                    case "CarsInfo":
                        CarsChoose.Location = new Point(5, 16);
                        Condition.Controls.Add(CarsChoose);
                        CarsChoose.Visible = true;
                        PowerAdd.Enabled = true;
                        PowerDel.Enabled = true ;
                        PowerUpdate.Enabled = true ;
                        //PowerUpdate.Text = "修改";
                        break;
                    case "UserInfo":       
                        UserChoose.Location = new Point(5, 16);
                        Condition.Controls.Add(UserChoose);
                        UserChoose.Visible = true;
                        PowerAdd.Enabled = true ;
                        PowerDel.Enabled = false ;
                        PowerUpdate.Enabled = true ;
                        //PowerUpdate.Text = "修改";
                        break;
                    case "OrderInfo":
                        OrderChoose.Location = new Point(5, 16);
                        Condition.Controls.Add(OrderChoose);
                        OrderChoose.Visible = true;
                        PowerAdd.Enabled = false;
                        PowerDel.Enabled = false ;
                        //PowerUpdate.Text = "确认订单";
                        PowerUpdate.Enabled = false ;
                        break;
                    case "Record":
                        RecordChoose.Location = new Point(5, 16);
                        Condition.Controls.Add(RecordChoose);
                        RecordChoose.Visible = true;
                        PowerAdd.Enabled = true ;
                        PowerDel.Enabled = false ;
                        PowerUpdate.Enabled = false ;
                        //PowerUpdate.Text = "修改";
                        break;
                    case "FixInfo":
                        FixChoose.Location = new Point(5, 16);
                        Condition.Controls.Add(FixChoose);
                        FixChoose.Visible = true;
                        PowerAdd.Enabled = true ;
                        PowerDel.Enabled = false ;
                        PowerUpdate.Enabled = false;
                        //PowerUpdate.Text = "修改";
                        break;
                    case "AccInfo":
                        AccChoose.Location = new Point(5, 16);
                        Condition.Controls.Add(AccChoose);
                        AccChoose.Visible = true;
                        PowerAdd.Enabled = true ;
                        PowerDel.Enabled = false ;
                        PowerUpdate.Enabled = false;
                        //PowerUpdate.Text = "修改";
                        break;
                    default: break;
                }
            }
            catch
            {
                return;
            }
        }
        //select button
        private void Selected_Button_Click(object sender, EventArgs e)
        {            
            try
            {
                switch (InfoShow.SelectedTab.Name)
                {
                    case "CarInfo":
                        CarData.DataSource = SelectCar(CarNameText.Text, CarBrandText.Text);//sql.ExecuteDt(sqlword);
                        break;
                    case "CarsInfo":
                        CarsData.DataSource = SelectCars(CarsIDText.Text, CarsNameText.Text, CarsPriceText.Text, CarsDepositText.Text, CarsStateText.Text);//sql.ExecuteDt(sqlword);
                        break;
                    case "UserInfo":
                        UserData.DataSource = SelectUser(UserIDText.Text, UserNameText.Text, UserMailText.Text);//sql.ExecuteDt(sqlword);
                        break;
                    case "OrderInfo":
                        OrderData.DataSource = SelectOrder(OrderIDText.Text, OUidText.Text, OCarsIDText.Text);//sql.ExecuteDt(sqlword);
                        break;
                    case "Record":
                        RecordData.DataSource = SelectRecord(RUserIDText.Text, RCarsIDText.Text, RStaffIDText.Text);//sql.ExecuteDt(sqlword);
                        break;
                    case "FixInfo":
                        FixData.DataSource = SelectFixSp(FixIDText.Text, FixUIDText.Text, FixCarNameText.Text);//sql.ExecuteDt(sqlword);
                        break;
                    case "AccInfo":
                        AccData.DataSource = SelectAccSp(AccIDText.Text, AccUIDText.Text, AccCarNameText.Text);//sql.ExecuteDt(sqlword);
                        break;
                    default: break;
                }
            }
            catch
            {
                MessageBox.Show("查询失败 ");
                return;
            }
        }
        //updata button
        private void Updata_Button_Click(object sender, EventArgs e)
        {
            try
            {
                CarData.DataSource = SelectCar(CarNameText.Text, CarBrandText.Text);//sql.ExecuteDt(sqlword);
                CarsData.DataSource = SelectCars(CarsIDText.Text, CarsNameText.Text, CarsPriceText.Text, CarsDepositText.Text, CarsStateText.Text);//sql.ExecuteDt(sqlword);
                UserData.DataSource = SelectUser(UserIDText.Text, UserNameText.Text, UserMailText.Text);//sql.ExecuteDt(sqlword);
                OrderData.DataSource = SelectOrder(OrderIDText.Text, OUidText.Text, OCarsIDText.Text);//sql.ExecuteDt(sqlword);
                RecordData.DataSource = SelectRecord(RUserIDText.Text, RCarsIDText.Text, RStaffIDText.Text);//sql.ExecuteDt(sqlword);
                FixData.DataSource = SelectFixSp(FixIDText.Text, FixUIDText.Text, FixCarNameText.Text);//sql.ExecuteDt(sqlword);
                AccData.DataSource = SelectAccSp(AccIDText.Text, AccUIDText.Text, AccCarNameText.Text);//sql.ExecuteDt(sqlword);
                MessageBox.Show("更新成功 ");
            }
            catch
            {
                MessageBox.Show("更新失败 ");
            }
        }

        private void EditMessage_Click(object sender, EventArgs e)
        {
            switch (RoleLabel.Text)
            {
                case "NONE":
                    NONE_board.Location = new Point(6, 17);
                    PowerBox.Controls.Add(NONE_board);
                    NONE_board.Visible = true;
                    NONE_board.BringToFront();    
                    break;
                case "USER":
                    UserEditBox.Location = new Point(6, 17);
                    PowerBox.Controls.Add(UserEditBox);
                    UserEditBox.Visible = true;
                    UserEditBox.BringToFront();   
                    break;
                case "STAFF":
                    StaffEditBox.Location = new Point(6, 17);
                    PowerBox.Controls.Add(StaffEditBox);
                    StaffEditBox.Visible = true;
                    StaffEditBox.BringToFront();   
                    break;
                default: break;
            }
        }

        private void SelectPower_Click(object sender, EventArgs e)
        {
            switch (RoleLabel.Text)
            {
                case "NONE":
                    NONE_board.Location = new Point(6, 17);
                    PowerBox.Controls.Add(NONE_board);  
                    NONE_board.Visible = true;
                    NONE_board.BringToFront();
                    break;
                case "USER":
                    break;
                case "STAFF":
                    break;
                default: break;
            }
        }

        private void MakeOrder_Click(object sender, EventArgs e)
        {
            ClearOrderBox();
            switch (RoleLabel.Text)
            {
                case "NONE":
                    NONE_board.Location = new Point(6, 17);
                    PowerBox.Controls.Add(NONE_board);
                    NONE_board.Visible = true;
                    NONE_board.BringToFront();
                    break;
                case "USER":
                    MakeOrderBox.Location = new Point(6, 14);
                    PowerBox.Controls.Add(MakeOrderBox);
                    MakeOrderBox.Visible = true;
                    MakeOrderBox.BringToFront();
                    break;
                case "STAFF":
                    break;
                default: break;
            }
        }

        private void CancelOrder_Click(object sender, EventArgs e)
        {
            ClearOrderBox();
            switch (RoleLabel.Text)
            {
                case "NONE":
                    NONE_board.Location = new Point(6, 17);
                    PowerBox.Controls.Add(NONE_board);
                    NONE_board.Visible = true;
                    NONE_board.BringToFront();
                    break;
                case "USER":
                    CancelOrderBox.Location = new Point(6, 16);
                    PowerBox.Controls.Add(CancelOrderBox);
                    CancelOrderBox.Visible = true;
                    CancelOrderBox.BringToFront();
                    break;
                case "STAFF":
                    break;
                default: break;
            }
        }

        private void NONE_Return_Click(object sender, EventArgs e)
        {
            NONE_board.Visible = false;
        }

        private void UserReset_Click(object sender, EventArgs e)
        {
            if (ResetUserPass.Text + ResetUserName.Text + ResetPhone.Text + ResetAddress.Text == "")
            {
                MessageBox.Show("没有修改内容");
                StaffEditBox.Visible = false;
                return;
            }
            bool s = UpdateUser(ResetUserPass.Text, ResetUserName.Text, ResetPhone.Text, ResetAddress.Text);
            if (!s)
            {
                MessageBox.Show("更新失败，请稍后重试");
            }
            else
            {
                if (ResetUserName.Text != "") user.Name = ResetUserName.Text;
                if (ResetPhone.Text != "") user.Phone = ResetPhone.Text;
                if (ResetAddress.Text != "") user.Address = ResetAddress.Text;
                ShowUserInfo();
                MessageBox.Show("更新成功"); 
                UserEditBox.Visible = false;
            }
        }

        private void UserEditCancel_Click(object sender, EventArgs e)
        {
            UserEditBox.Visible = false;
        }

        public bool UpdateUser(string pass, string name, string phone, string address) {
            string sqlword = "update users set ";
            if (pass != "")
            {
                sqlword += "pass = " + addstring(pass)+",";
            }
            if (name != "")
            {
                sqlword += "name = " + addstring(name)+",";
            }
            if (phone != "")
            {
                sqlword += "phone = " + addstring(phone)+",";
            }
            if (address != "")
            {
                sqlword += "address = " + addstring(address);
            }
            sqlword += " where uid = " + addstring(user.Uid); 
            try
            {
                sql.ExecuteSql(sqlword);
                return true;
            }
            catch 
            {
                return false;
            }
        }

        private void StaffReset_Click(object sender, EventArgs e)
        {
            if (ResetStaffPass.Text + ResetStaffName.Text == "")
            {
                MessageBox.Show("没有修改内容");
                StaffEditBox.Visible = false;
                return;
            }
            bool s = UpdateStaff(ResetStaffPass.Text, ResetStaffName.Text);
            if (!s)
            {
                MessageBox.Show("更新失败，请稍后重试");
            }
            else
            {
                if (ResetStaffName.Text != "") staff.Name = ResetStaffName.Text;
                ShowStaffInfo();
                MessageBox.Show("更新成功");
                StaffEditBox.Visible = false;
            }
        }
        public bool UpdateStaff(string pass, string name)
        {
            string sqlword = "update staffs set ";
            if (pass != "")
            {
                sqlword += "pass = " + addstring(pass)+",";
            }
            if (name != "")
            {
                sqlword += "name = " + addstring(name);
            }
            sqlword += " where sid = " + addstring(staff.Sid);
            try
            {
                sql.ExecuteSql(sqlword);
                return true;
            }
            catch
            {
                return false;
            }
        }
        private void StaffResetCancal_Click(object sender, EventArgs e)
        {
            StaffEditBox.Visible = false;
        }
        //Edit a Car

        private void MakeOrderSure_Click(object sender, EventArgs e)
        {
            string sqlword = "select blacklabel from users where uid = " + user.Uid;
            try
            {
                MySqlDataReader sqlR = sql.ExecuteReader(sqlword);
                sqlR.Read();
                user.Blacklabel = (bool)sqlR[0];
            }
            catch
            {
                MessageBox.Show("检查用户标签失败 ");
                return;
            }
            if (user.Blacklabel)
            {
                MessageBox.Show("您已经被加入黑名单,请联系客服解决问题");
                return;
            }
            if (MakeOrderCarID.Text == "")
            {
                MessageBox.Show("请填写Car ID");
                return;
            }
            if (GetCarState(MakeOrderCarID.Text) != "wait")
            {
                MessageBox.Show("该车状态无法出行 ");
                return;
            }
            bool s = InsertIntoOrder(MakeOrderCarID.Text, MakeOrderDay.Text);
            if (s)
            {
                MessageBox.Show("订单已收到");
                MakeOrderBox.Visible = false;
                OrderData.DataSource = SelectOrder(OrderIDText.Text, OUidText.Text, OCarsIDText.Text);
            }
            else
            {
                MessageBox.Show("订单失败，请查准车号");
            }
        }

        private void MakeOrderCancel_Click(object sender, EventArgs e)
        {
            MakeOrderBox.Visible = false;
        }

        private void CancelOrderCancel_Click(object sender, EventArgs e)
        {
            CancelOrderBox.Visible = false;
        }

        private void CancelOrderSure_Click(object sender, EventArgs e)
        {
            if(CancelOrderText.Text==""){
                MessageBox.Show("请输入订单号");
                return;
            }
            bool s = DeleteFromOrder(CancelOrderText.Text);
            if (s)
            {
                MessageBox.Show("订单已取消");
                CancelOrderBox.Visible = false;
                OrderData.DataSource = SelectOrder(OrderIDText.Text, OUidText.Text, OCarsIDText.Text);
            }
            else
            {
                MessageBox.Show("没有该订单,请查实后再输入");
            }
        }
        string GetOrderNo() {
            string Ono="select max(oid) from Orders";
            try
            {
                MySqlDataReader sqlR = sql.ExecuteReader(Ono);
                if (sqlR.Read())
                {
                    if (sqlR[0].ToString() == "") Ono = "1";
                    else Ono = (Convert.ToInt64(sqlR[0]) + 1).ToString();
                }
                else
                {
                    Ono = "1";
                }
            }
            catch
            {
                MessageBox.Show("Mysql connect failed");
            }
            return Ono;
        }
        bool InsertIntoOrder(string Cid, string days){
            if (Convert.ToInt64(days) == 0)
            {
                MessageBox.Show("订单天数不能为0");
            }
            string sqlword = "insert into Orders values (";
            string Ono = GetOrderNo();
            sqlword += addstring(Ono) + ',';
            sqlword += addstring(Cid) + ',';
            sqlword += addstring(user.Uid) + ',';
            if (days == "") ;
            else sqlword += days + ',';
            sqlword += "now(), 0)";
            try{
                sql.ExecuteSql(sqlword);
                Updata();
            }
            catch
            {
                return false;
            }
            return true;
        }
        bool DeleteFromOrder(string Oid)
        {
            string sqlword = "delete from Orders where oid = " + addstring(Oid);
            try
            {
                sql.ExecuteSql(sqlword);
                return true;
            }
            catch
            {
                return false;
            }
        }

        DataTable SelectCar(string Carname="", string Brand="")
        {
            DataTable dt = null;
            bool has = false;
            string sqlword = "select * from CarsInfo ";
            if (Carname == "" && Brand == "") ;
            else
            {
                sqlword += "where ";
                if (Carname != "") {
                    sqlword += "name = "+addstring(Carname);
                    has = true;
                }
                if (Brand != "")
                {
                    if (has) sqlword += " and ";
                    sqlword += "brand = " + addstring(Brand);
                }
            }
            try
            {
                dt = sql.ExecuteDt(sqlword);
            }
            catch
            {
                MessageBox.Show("Can't Connect");
            }
            return dt;
        }

        DataTable SelectCars(string Cid = "", string Cname = "", string Price = "", string Deposit = "", string state = "")
        {
            DataTable dt = null;
            bool has = false;
            string sqlword = "select * from Cars ";
            if (Cid == "" && Cname == "" && Price == "" && Deposit == "" && state == "") ;
            else
            {
                sqlword += "where ";
                if (Cid != "")
                {
                    sqlword += "Cid = " + addstring(Cid);
                    has = true;
                }
                if (Cname != "") {
                    if (has) sqlword += " and ";
                    sqlword += "name = " + addstring(Cname);
                    has = true;
                }
                try
                {
                    if (Price != "")
                    {
                        if (has) sqlword += " and ";
                        if (Price.IndexOf("-") != -1)
                        {
                            string[] d = Price.Split('-');
                            Convert.ToInt64(d[0]);
                            Convert.ToInt64(d[1]);
                            sqlword += "price >= " + d[0];
                            sqlword += " and price <=" + d[1];
                            has = true;
                        }
                        else
                        {
                            if (has) sqlword += " and ";
                            Convert.ToInt64(Price);
                            sqlword += "price = " + Price;
                            has = true;
                        }
                    }
                    if (Deposit != "")
                    {
                        if (has) sqlword += " and ";
                        if (Deposit.IndexOf("-") != -1)
                        {
                            string[] d = Deposit.Split('-');
                            Convert.ToInt64(d[0]);
                            Convert.ToInt64(d[1]);
                            sqlword += "Deposit >= " + d[0];
                            sqlword += " and Deposit <=" + d[1];
                            has = true;
                        }
                        else
                        {
                            if (has) sqlword += " and ";
                            Convert.ToInt64(Deposit);
                            sqlword += "Deposit = " + Deposit;
                            has = true;
                        }
                    }
                }
                catch
                {
                    ErrorBoxShow();
                    return null;
                }
                if (state != "")
                {
                    if (!checkstateinput(state))
                    {
                        ErrorBoxShow();
                        return null;
                    }
                    if (has) sqlword += " and ";
                    sqlword += "sqlword = " + addstring(state);
                }
            }
            try
            {
                dt = sql.ExecuteDt(sqlword);
            }
            catch
            {
                MessageBox.Show("Can't Connect");
            }
            return dt;
        }
        
        DataTable SelectUser(string Uid = "", string name = "", string mail = "")
        {
            DataTable dt = null;
            bool has = false;
            string sqlword = "select * from users ";
            if (Uid == ""&&name==""&&mail=="") ;
            else
            {
                sqlword += "where ";
                if(Uid!=""){
                    sqlword+="uid = "+addstring(Uid);
                    has = true;
                }
                if (name != "")
                {
                    if (has) sqlword += " and ";
                    sqlword += "name = " + addstring(name);
                    has = true;
                }
                if (mail != "")
                {
                    if (has) sqlword += " and ";
                    sqlword += "mail = " + addstring(mail);
                }
            }
            try
            {
                dt = sql.ExecuteDt(sqlword);
            }
            catch
            {
                MessageBox.Show("Can't Connect");
            }
            return dt;
        }

        DataTable SelectOrder(string Oid="", string  Uid= "", string Cid="")
        {
            DataTable dt = null;
            bool has = false;
            string sqlword = "select * from orders where checked = false";
            has = true;
            if (Oid == "" && Cid == "" && Uid == "") ;
            else
            {
                //sqlword += "where ";
                if (Oid != "")
                {
                    if (has) sqlword += " and ";
                    sqlword += "Oid = " + addstring(Oid) ;
                    has = true;
                }
                if(Uid !=""){
                    if (has) sqlword += " and ";
                    sqlword += "Uid = " + addstring(Uid);
                    has = true;
                }
                if (Cid != "")
                {
                    if (has) sqlword += " and ";
                    sqlword += "Cid = " + addstring(Cid);
                }
            }
            try
            {
                dt = sql.ExecuteDt(sqlword);
            }
            catch
            {
                MessageBox.Show("Can't Connect");
            }
            return dt;
        }

        DataTable SelectRecord(string Uid="", string Cid ="", string Sid="")
        {
            DataTable dt = null;
            bool has = false;
            string sqlword = "select * from Records ";
            if (Uid == "" && Cid == "" && Sid == "") ;
            else
            {
                sqlword += "where ";
                if (Uid != "")
                {
                    sqlword += "Uid = " + addstring(Uid);
                    has = true;
                }
                if (Cid != "")
                {
                    if (has) sqlword += " and ";
                    sqlword += "Cid = " + addstring(Cid);
                    has = true;
                }
                if (Sid != "")
                {
                    if (has) sqlword += " and ";
                    sqlword += "Sid = " + addstring(Sid);
                }
            }
            try
            {
                dt = sql.ExecuteDt(sqlword);
            }
            catch
            {
                MessageBox.Show("Can't Connect");
            }
            return dt;
        }

        DataTable SelectFixSp(string Fid="", string Uid="", string Cname="")
        {
            DataTable dt = null;
            string sqlword = "select fixlist.Fid, records.Rid, records.Cid, records.Uid, Cars.Name,fixlist.Fix, fixlist.Cost ";
            sqlword += "from fixlist, records, Cars ";
            sqlword += "where fixlist.Rid = records.Rid and records.Cid = Cars.Cid";
            if (Fid == "" && Uid == "" && Cname == "") ;
            else
            {
                if (Fid != "")
                {
                    sqlword += " and fixlist.Fid = " + addstring(Fid);
                }
                if (Uid != "")
                {
                    sqlword += " and records.Uid = " + addstring(Uid);
                }
                if (Cname != "")
                {//link to other 
                    sqlword += " and Cars.Name = " + addstring(Cname);
                }
            }
            try
            {
                dt = sql.ExecuteDt(sqlword);
            }
            catch
            {
                MessageBox.Show("Can't Connect");
            }
            return dt;
        }

        DataTable SelectAccSp(string Aid="", string Uid="",string Cname="")
        {
            DataTable dt = null;
            string sqlword = "select Accident.Aid, records.Rid, records.Cid, records.Uid, Cars.Name, Accident.Acc ";
            sqlword += "from Accident, records, Cars ";
            sqlword += "where Accident.Rid = records.Rid and records.Cid = Cars.Cid";
            if (Aid == "" && Uid == "" && Cname == "") ;
            else
            {
                if (Aid != "")
                {
                    sqlword += " and Accident.Aid = " + addstring(Aid);
                }
                if (Uid != "")
                {
                    sqlword += " and records.Uid = " + addstring(Uid);
                }
                if (Cname != "")
                {//link to other 
                    sqlword += " and Cars.Name = " + addstring(Cname);
                }
            }
            try
            {
                dt = sql.ExecuteDt(sqlword);
            }
            catch
            {
                MessageBox.Show("Can't Connect");
            }
            return dt;
        }

        void ClearOrderBox()
        {
            MakeOrderCarID.Text = "";
            MakeOrderDay.Text = "";
            CancelOrderText.Text = "";
        }
        string GetCarState(string CarID) {
            string sqlword = "select state from Cars where Cid = " + addstring(CarID);
            MySqlDataReader sqlR = sql.ExecuteReader(sqlword);
            if (sqlR.Read())
            {
                return sqlR[0].ToString();
            }
            return null;
        }
        bool checkstateinput(string state)
        {
            if (state == "use") return true;
            if (state == "fix") return true;
            if (state == "traffic") return true;
            if (state == "wait") return true;
            if (state == "select") return true;
            if (state == "return") return true;
            return false;
        }
        void ErrorBoxShow()
        {
            MessageBox.Show("输入数据违法");
        }

        private void PowerAdd_Click(object sender, EventArgs e)
        {
            CarData.AllowUserToAddRows = true;
            CarsData.AllowUserToAddRows = true;
            UserData.AllowUserToAddRows = true;
            RecordData.AllowUserToAddRows = true;
            FixData.AllowUserToAddRows = true;
            AccData.AllowUserToAddRows = true;
        }

        private void PowerUpdate_Click(object sender, EventArgs e)
        {
            CarData.AllowUserToAddRows = false;
            CarsData.AllowUserToAddRows = false;
            UserData.AllowUserToAddRows = false;
            RecordData.AllowUserToAddRows = false;
            FixData.AllowUserToAddRows = false;
            AccData.AllowUserToAddRows = false;
            switch (InfoShow.SelectedTab.Name)
            {
                case "CarInfo":
                    break;
                case "CarsInfo":
                    break;
                case "UserInfo":
                    break;
                case "OrderInfo":
                    /*
                    foreach (DataGridViewRow dr in OrderData.SelectedRows)
                    {
                        dr.Cells["checked"].Value = true;
                    }*/
                    break;
                case "Record":
                    break;
                case "FixInfo":
                    break;
                case "AccInfo":
                    break;
                default: break;
            }
        }

        private void PowerDel_Click(object sender, EventArgs e)
        {
            CarData.AllowUserToAddRows = false;
            CarsData.AllowUserToAddRows = false;
            UserData.AllowUserToAddRows = false;
            RecordData.AllowUserToAddRows = false;
            FixData.AllowUserToAddRows = false;
            AccData.AllowUserToAddRows = false;
            switch (InfoShow.SelectedTab.Name)
            {
                case "CarInfo":
                    foreach (DataGridViewRow dr in CarData.SelectedRows)
                    {
                        CarData.Rows.Remove(dr);
                    }
                    break;
                case "CarsInfo":
                    foreach (DataGridViewRow dr in CarsData.SelectedRows)
                    {
                        CarsData.Rows.Remove(dr);
                    }
                    break;
                case "UserInfo":
                    foreach (DataGridViewRow dr in UserData.SelectedRows)
                    {
                        UserData.Rows.Remove(dr);
                    }
                    break;
                case "OrderInfo":
                    foreach (DataGridViewRow dr in OrderData.SelectedRows)
                    {
                        OrderData.Rows.Remove(dr);
                    }
                    break;
                case "Record":
                    foreach (DataGridViewRow dr in RecordData.SelectedRows)
                    {
                        RecordData.Rows.Remove(dr);
                    }
                    break;
                case "FixInfo":
                    foreach (DataGridViewRow dr in FixData.SelectedRows)
                    {
                        FixData.Rows.Remove(dr);
                    }
                    break;
                case "AccInfo":
                    foreach (DataGridViewRow dr in AccData.SelectedRows)
                    {
                        AccData.Rows.Remove(dr);
                    }
                    break;
                default: break;
            }
        }

        private void PowerExit_Click(object sender, EventArgs e)
        {
            string sqlword;
            if (MessageBox.Show("确定退出编辑模式吗？", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {  
                PowerEditBox.Visible = false;
                Updata();
            }
            else
            {
                sqlword = "select * from fixlist where fid = null";
                FixData.DataSource = sql.ExecuteDt(sqlword);
                sqlword = "select * from accident where aid = null";
                AccData.DataSource = sql.ExecuteDt(sqlword);
            }
            CarData.AllowUserToAddRows = false;
            CarData.AllowUserToDeleteRows = false;
            CarData.ReadOnly = true;
            CarsData.AllowUserToAddRows = false;
            CarsData.AllowUserToDeleteRows = false;
            CarsData.ReadOnly = true;
            UserData.AllowUserToAddRows = false;
            UserData.AllowUserToDeleteRows = false;
            UserData.ReadOnly = true;
            RecordData.AllowUserToAddRows = false;
            RecordData.AllowUserToDeleteRows = false;
            RecordData.ReadOnly = true;
            OrderData.ReadOnly = true;
            OrderData.AllowUserToDeleteRows = false;
            FixData.AllowUserToAddRows = false;
            FixData.ReadOnly = true;
            AccData.AllowUserToAddRows = false;
            AccData.ReadOnly = true;
            CarData.RowHeadersVisible = false;
            RecordData.RowHeadersVisible = false;
            UserData.RowHeadersVisible = false;
            CarsData.RowHeadersVisible = false;
            OrderData.RowHeadersVisible = false;
            FixData.RowHeadersVisible = false;
            AccData.RowHeadersVisible = false;
        }

        private void EditMenuItem_Click(object sender, EventArgs e)
        {
            switch (InfoShow.SelectedTab.Name)
            {
                case "CarInfo":
                    PowerAdd.Enabled = true;
                    PowerDel.Enabled = true;
                    PowerUpdate.Enabled = true;
                    break;
                case "CarsInfo":
                    PowerAdd.Enabled = true;
                    PowerDel.Enabled = true;
                    PowerUpdate.Enabled = true;
                    break;
                case "UserInfo":
                    PowerAdd.Enabled = true;
                    PowerDel.Enabled = false;
                    PowerUpdate.Enabled = true;
                    break;
                case "OrderInfo":
                    PowerAdd.Enabled = false;
                    PowerDel.Enabled = false;
                    PowerUpdate.Enabled = false;
                    break;
                case "Record":
                    PowerAdd.Enabled = true;
                    PowerDel.Enabled = false;
                    PowerUpdate.Enabled = false;
                    break;
                case "FixInfo":
                    PowerAdd.Enabled = true;
                    PowerDel.Enabled = false;
                    PowerUpdate.Enabled = false;
                    break;
                case "AccInfo":
                    PowerAdd.Enabled = true;
                    PowerDel.Enabled = false;
                    PowerUpdate.Enabled = false;
                    break;
                default: break;
            }
            PowerEditBox.Location = new Point(6, 17);
            PowerBox.Controls.Add(PowerEditBox);
            PowerEditBox.Visible = true;
            PowerEditBox.BringToFront();
            CarData.ReadOnly = false;
            RecordData.ReadOnly = false;
            UserData.ReadOnly = false;
            CarsData.ReadOnly = false;
            OrderData.ReadOnly = false;
            FixData.ReadOnly = false;
            AccData.ReadOnly = false;
            CarData.RowHeadersVisible = true;
            RecordData.RowHeadersVisible = true;
            UserData.RowHeadersVisible = true;
            CarsData.RowHeadersVisible = true;
            OrderData.RowHeadersVisible = true;
            FixData.RowHeadersVisible = true;
            AccData.RowHeadersVisible = true;
            //update the add word;
            string sqlword;
            sqlword = "select * from fixlist";
            FixData.DataSource = sql.ExecuteDt(sqlword);
            sqlword = "select * from accident";
            AccData.DataSource = sql.ExecuteDt(sqlword);
        }

        private void ApplyChange_Click(object sender, EventArgs e)
        {
            //Car Cars User Order
            string sqlword;
            try
            {
                switch (InfoShow.SelectedTab.Name)
                {
                    case "CarInfo":
                        sqlword = "select * from carsinfo";
                        sql.SyncSql((DataTable)CarData.DataSource, sqlword);
                        break;
                    case "CarsInfo":
                        sqlword = "select * from cars";
                        sql.SyncSql((DataTable)CarsData.DataSource, sqlword);
                        break;
                    case "UserInfo":
                        sqlword = "select * from users";
                        sql.SyncSql((DataTable)UserData.DataSource, sqlword);
                        break;
                    case "OrderInfo":
                        sqlword = "select * from orders";
                        sql.SyncSql((DataTable)OrderData.DataSource, sqlword);
                        break;
                    case "Record":
                        sqlword = "select * from records";
                        sql.SyncSql((DataTable)RecordData.DataSource, sqlword);
                        ReturnCost.Location = new Point(6, 16);
                        PowerBox.Controls.Add(ReturnCost);
                        ReturnCost.Visible = true;
                        ReturnCost.BringToFront();
                        sqlword = "select (cars.Deposit - records.Cost) as returncost from records, cars where cars.cid = records.cid and records.date = (select max(date) from records)";
                        MySqlDataReader sqlR = sql.ExecuteReader(sqlword);
                        sqlR.Read();
                        double cost = Convert.ToDouble(sqlR[0].ToString());
                        ReturnCostBoard.SelectAll();
                        ReturnCostBoard.SelectionAlignment = HorizontalAlignment.Center;
                        if (cost < 0)
                        {
                            ReturnCostBoard.Text = "客户海英支付 " + (-cost).ToString();
                        }
                        else
                        {
                            ReturnCostBoard.Text = "应还付款 " + cost.ToString();
                        }
                        //
                        break;
                    case "FixInfo":
                        sqlword = "select * from fixlist";
                        sql.SyncSql((DataTable)FixData.DataSource, sqlword);
                        break;
                    case "AccInfo":
                        sqlword = "select * from accident";
                        sql.SyncSql((DataTable)AccData.DataSource, sqlword);
                        break;
                    default: break;
                }
                MessageBox.Show("更新成功 ");
            }
            catch
            {
                MessageBox.Show("更新失败， 请重试");
            }
            Updata();
            sqlword = "select * from fixlist";
            FixData.DataSource = sql.ExecuteDt(sqlword);
            sqlword = "select * from accident";
            AccData.DataSource = sql.ExecuteDt(sqlword);
        }

        private void CancelChange_Click(object sender, EventArgs e)
        {
            string sqlword;
            Updata();
            sqlword = "select * from fixlist";
            FixData.DataSource = sql.ExecuteDt(sqlword);
            sqlword = "select * from accident";
            AccData.DataSource = sql.ExecuteDt(sqlword);
        }
        void Updata(){
            CarData.DataSource = SelectCar(CarNameText.Text, CarBrandText.Text);//sql.ExecuteDt(sqlword);
            CarsData.DataSource = SelectCars(CarsIDText.Text, CarsNameText.Text, CarsPriceText.Text, CarsDepositText.Text, CarsStateText.Text);//sql.ExecuteDt(sqlword);
            UserData.DataSource = SelectUser(UserIDText.Text, UserNameText.Text, UserMailText.Text);//sql.ExecuteDt(sqlword);
            OrderData.DataSource = SelectOrder(OrderIDText.Text, OUidText.Text, OCarsIDText.Text);//sql.ExecuteDt(sqlword);
            RecordData.DataSource = SelectRecord(RUserIDText.Text, RCarsIDText.Text, RStaffIDText.Text);//sql.ExecuteDt(sqlword);
            FixData.DataSource = SelectFixSp(FixIDText.Text, FixUIDText.Text, FixCarNameText.Text);//sql.ExecuteDt(sqlword);
            AccData.DataSource = SelectAccSp(AccIDText.Text, AccUIDText.Text, AccCarNameText.Text);//sql.ExecuteDt(sqlword);
        }

        private void ReportMenuItem_Click(object sender, EventArgs e)
        {
            MoneyShow.Location = new Point(220, 31);
            this.Controls.Add(MoneyShow);
            MoneyShow.BringToFront();
            MoneyShow.Visible = true;
        }

        private void UserCheck_Click(object sender, EventArgs e)
        {
            UserJudge.Location = new Point(5, 18);
            this.Controls.Add(UserJudge);
            UserJudge.BringToFront();
            UserJudge.Visible = true;
        }
        double point = -1;
        private void GetUserPoint_Click(object sender, EventArgs e)
        {
            double All, Fix, Acc;
            if (UserJName.Text == "")
            {
                MessageBox.Show("请输入待评价用户 ");
                return;
            }
            string sqlword = "select count(rid) from records where uid = " + addstring(UserJName.Text);
            try
            {
                MySqlDataReader sqlR = sql.ExecuteReader(sqlword);
                sqlR.Read();
                LendJ.Text = "借车次数 : " + sqlR[0].ToString();
                All = Convert.ToDouble(sqlR[0].ToString());
                sqlword = "select count(fid) from fixlist, records where fixlist.rid = records.rid and records.uid = " + addstring(UserJName.Text); 
                sqlR = sql.ExecuteReader(sqlword);
                sqlR.Read();
                FixCarJ.Text = "车辆损坏次数 : " + sqlR[0].ToString();
                Fix = Convert.ToDouble(sqlR[0].ToString());
                sqlword = "select count(aid) from accident, records where accident.rid = records.rid and records.uid = " + addstring(UserJName.Text);
                sqlR = sql.ExecuteReader(sqlword);
                sqlR.Read();
                AccCarJ.Text = "违反交通次数 : " + sqlR[0].ToString();
                Acc = Convert.ToDouble(sqlR[0].ToString());
                if (All == 0)
                {
                    UserPoint.Text = "评分 : -";
                }
                else
                {
                    point = 50*((All-Fix)/All)+50*((All-Acc)/All);
                    UserPoint.Text = "评分 : " + point.ToString("0.00");
                }
            }
            catch
            {
                MessageBox.Show("DataReader Break, 请查证信息");
            }
        }

        private void ExitPoint_Click(object sender, EventArgs e)
        {
            UserJudge.Visible = false;
        }

        private void AddToBlack_Click(object sender, EventArgs e)
        {
            if (point < 0)
            {
                MessageBox.Show("没有进行评价,或者该用户没有借车记录");
                return;
            }
            if (point >= 60)
            {
                MessageBox.Show("用户评价高于60，不可以加入黑名单");
                return;
            }
            string sqlword = "update users set blacklabel = 1 where uid = "+addstring(UserJName.Text);
            try
            {
                sql.ExecuteSql(sqlword);
            }
            catch
            {
                MessageBox.Show("加入黑名单失败");
            }
            UserData.DataSource = SelectUser(UserIDText.Text, UserNameText.Text, UserMailText.Text);//sql.ExecuteDt(sqlword);
        }

        private void CloseTable_Click(object sender, EventArgs e)
        {
            MoneyShow.Visible = false;
        }

        private void MakeTable_Click(object sender, EventArgs e)
        {
            string sqlword = "select * from records where date >= ";
            sqlword += addstring(Convert.ToDateTime(OldTimer.Text).ToString());//.Substring(0,OldTimer.Text.IndexOf("星"))
            sqlword += " and date <= ";
            sqlword += addstring(Convert.ToDateTime(NewTimer.Text).ToString());//.Substring(0, NewTimer.Text.IndexOf("星"))
            sqlword  = sqlword.Replace("/", "-");
            try
            {
                RecordShow.DataSource = sql.ExecuteDt(sqlword);
                sqlword = sqlword.Replace("*", "sum(Cost)");
                MySqlDataReader mqlR = sql.ExecuteReader(sqlword);
                if (mqlR.Read())
                {
                    if (mqlR[0].ToString() == "") AllMoney.Text = "总计收益 : 0";
                    else AllMoney.Text = "总计收益 : " + mqlR[0].ToString();
                }
                else
                {
                    AllMoney.Text = "总计收益 : 0";
                }
            }
            catch
            {
                MessageBox.Show("数据库异常 ");
            }
            //先查一次，得到所有数据

        }
    
        public void ClearPower(){
            MoneyShow.Visible = false;
            PowerEditBox.Visible = false;
            CarData.AllowUserToAddRows = false;
            CarData.AllowUserToDeleteRows = false;
            CarData.ReadOnly = true;
            CarsData.AllowUserToAddRows = false;
            CarsData.AllowUserToDeleteRows = false;
            CarsData.ReadOnly = true;
            UserData.AllowUserToAddRows = false;
            UserData.AllowUserToDeleteRows = false;
            UserData.ReadOnly = true;
            RecordData.AllowUserToAddRows = false;
            RecordData.AllowUserToDeleteRows = false;
            RecordData.ReadOnly = true;
            OrderData.ReadOnly = true;
            OrderData.AllowUserToDeleteRows = false;
            FixData.AllowUserToAddRows = false;
            FixData.ReadOnly = true;
            AccData.AllowUserToAddRows = false;
            AccData.ReadOnly = true;
            CarData.RowHeadersVisible = false;
            RecordData.RowHeadersVisible = false;
            UserData.RowHeadersVisible = false;
            CarsData.RowHeadersVisible = false;
            OrderData.RowHeadersVisible = false;
            FixData.RowHeadersVisible = false;
            AccData.RowHeadersVisible = false;
            MakeOrderCancel_Click(null,null);
            CancelOrderCancel_Click(null, null);
        }

        private void RecordShow_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            RecordShow.ClearSelection();
        }

        private void ReturnCostSure_Click(object sender, EventArgs e)
        {
            ReturnCost.Visible = false;
        }
    }
}
